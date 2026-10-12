-- Ultimate Manager cloud saves: run this once in Supabase (SQL Editor > New query > paste > Run).
-- Saves are stored under a long secret key made from each player's name and password.
-- The table is locked (no direct access); the game can only use the two functions below,
-- and each one needs the exact key.

create table if not exists public.cloud_saves (
  key text primary key,
  data jsonb not null,
  updated_at timestamptz not null default now()
);
alter table public.cloud_saves enable row level security;
revoke all on public.cloud_saves from anon, authenticated;

create or replace function public.um_get(p_key text)
returns table(data jsonb, updated_at timestamptz)
language sql security definer set search_path = public as $$
  select c.data, c.updated_at from public.cloud_saves c
  where length(p_key) >= 60 and c.key = p_key;
$$;

create or replace function public.um_put(p_key text, p_data jsonb)
returns void
language plpgsql security definer set search_path = public as $$
begin
  if length(p_key) < 60 then raise exception 'bad key'; end if;
  insert into public.cloud_saves(key, data, updated_at) values (p_key, p_data, now())
  on conflict (key) do update set data = excluded.data, updated_at = now();
end $$;

revoke all on function public.um_get(text) from public;
revoke all on function public.um_put(text, jsonb) from public;
grant execute on function public.um_get(text) to anon, authenticated;
grant execute on function public.um_put(text, jsonb) to anon, authenticated;

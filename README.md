# Ultimate Manager

Upload every file in this folder to the root of a GitHub repository and turn on GitHub Pages
(Settings > Pages > Deploy from a branch > main / root).

When you upload a new version of index.html, also change VERSION at the top of sw.js
(for example ultimate-manager-v2) so phones fetch the update.


Cloud sync: when the game runs from GitHub Pages it signs players into the Supabase project
https://qhmtfcnzhmvpafkwivgm.supabase.co and keeps each career in the public.saves table.
Sign in on another device with the same name and password to carry on there.

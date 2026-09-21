# Common Ground — capstone idea board

Dark, responsive Times New Roman message board. Enter a name, share an idea, toggle a vote, and comment. No password or member accounts to manage.

## Preview

Run `python3 -m http.server 8765` here, then open http://localhost:8765. With empty config, this is explicitly a local preview: records only persist in this browser.

## Connect shared storage

1. Create a free Supabase project at https://supabase.com/dashboard.
2. Run `schema.sql` in its SQL editor once.
3. Enable anonymous sign-ins in Authentication settings.
4. Set `supabaseUrl` and `supabaseKey` in `config.js` using the project's URL and **publishable key** (legacy anon key also works). Never put a secret/service-role key in this file.
5. Push the updated config to GitHub. Pages redeploys automatically.

Names are self-declared. Supabase silently creates a session so each browser can cast one vote per idea and only remove its own vote. Clearing browser data or using another device creates another identity; this is a casual group board, not verified voting. Names, ideas, and comments on the shared board are publicly readable by anyone with the site URL. Database policies enforce ownership and content limits. Rename affects future posts; old contributions retain their original name.

## Hosting

Publish only this directory in a dedicated GitHub repository, with Pages configured to deploy from the main branch root. No build step is needed. `.nojekyll` disables Jekyll. The live connection uses the Supabase JavaScript client from jsDelivr. The board refreshes every 30 seconds while idle; reload to refresh an open comment thread.

## Checks

`node --check app.js` checks syntax. Browser checks should cover required name, posting, vote/unvote, comments, sorting, reload persistence, safe text rendering, and mobile overflow. Shared database integration requires a configured Supabase project and running the schema.

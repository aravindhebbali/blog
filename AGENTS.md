# AGENTS.md — working agreement for this repo

## Workflow
- Work in phases; keep the session TODO list updated (one task `in_progress`
  at a time; mark completed only after it is done AND verified).
- Atomic commits: one logical change per commit. Single-line messages only,
  conventional-commit style, lowercase, no trailing period — matching repo
  history (`feat:`, `fix:`, `build:`, `docs:`, `chore:`).
- Push (`git push origin quarto-mvp`) at the end of every phase. Early pushes
  mid-phase are allowed when a preview/CI check is useful (pushing
  `quarto-mvp` triggers a Netlify branch deploy) — announce before an early push.
- Never force-push. Never commit secrets, credentials, or scratch
  (`.Renviron`, `*.rds`, `Rplots.pdf`, data files).

## Verification gates (run before committing within a phase)
- `quarto render` exits 0; `_site/` contains `index.xml`, `sitemap.xml`,
  `search.json`; `_site/img/` complete.
- `git status` shows only intended files — no stray artifacts.
- After content edits, spot-check the rendered page in `_site/`.

## Editing frozen posts
- `_freeze/posts/<slug>/index/execute-results/html.json` caches the post's
  processed markdown, so prose edits do NOT appear in output from a full
  `quarto render` alone.
- After editing a frozen post, run `quarto render <post>/index.qmd` (regenerates
  the cache) and commit the updated `_freeze/` json in the same commit.
- A clean fresh-clone render is the way to verify what Netlify will build
  (Netlify runs plain `quarto render` against committed `_freeze/`).

## Build commands
- `quarto render` (or `npm run build`)
- If not on PATH: `& "$env:LOCALAPPDATA\Programs\Quarto\bin\quarto.exe" render`
- Legacy Hugo/blogdown tree (`content/`, `themes/`, `static/`, `config.toml`,
  `index.Rmd`, `layouts/`) is deleted by Phase 3 — never re-add references.

## Current phase plan
1. Content fixes + build verification
2. Freeze cache + final post migration
3. Legacy purge
4. Redirects (netlify.toml) + analytics placeholder
5. Link verification
6. Release workflow (template + RELEASES.md)
7. Deploy (ff-merge to master, tag v2026-mvp, post-deploy checks)

## Deferred (explicitly not in this plan)
- Pilot release post, `renv.lock`, comments (Giscus), search tuning,
  `master` → `main` rename + CI.

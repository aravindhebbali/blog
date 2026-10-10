# Release workflow conventions

How package releases are announced in this blog.

## Which changes get a blog post

- `release` and `minor` (X.Y.\*, X.\*.0) — publish a blog post based on
  `posts/_release-template.qmd`.
- `patch` (X.\*.Z) — publish a GitHub release only; no blog post.

## Posting workflow

1. Copy `posts/_release-template.qmd` to
   `posts/<package>-<version>/index.qmd`.
2. Fill the frontmatter: `title` = "Package X.Y.Z", `categories: [packages]`,
   `tags: [package_name]`, and an `image` (default `/img/github_<pkg>.png`;
   generate an OG card with `R/make_og_card.R` if none exists).
3. **Copy the `NEWS.md` entry for that version verbatim** into What's New —
   `NEWS.md` stays the single source of truth; do not hand-rewrite it.
4. Fill Breaking Changes / New Features / Bug Fixes from the entry. Keep the
   `Session Info` details block.
5. Set `date` to the release date; add `aliases` if the post supersedes an
   older announcement of the same package.
6. Render (`quarto render`) and check the post locally, then commit.

## Categories

- `packages` — package release announcements.
- `release` — reserved for major rewrites worth a deeper write-up (optional
  second category alongside `packages`).
- `tutorial` — step-by-step teaching posts.
- `general` — everything else.

## Deferred

- Automating the NEWS.md excerpt via `R/build_release_notes.R` — revisit
  after at least two release posts have been written by hand.

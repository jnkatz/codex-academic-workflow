# How To Adapt An Existing Repo

This guide shows how to apply the thin Codex academic workflow to a real repository without restructuring it.

The example here is based on `ids126`, a slide-first teaching repo that already uses Quarto and `caltech-revealjs`.

## Goal

Add the workflow layer:

- `AGENTS.md`
- `scripts/check-protected-paths.sh`
- `scripts/run-verifications.sh`
- `workflow/project.yml`
- `workflow/decision-log.md`
- `workflow/substance-review.md`
- `workflow/protected-paths.txt`
- `workflow/reports/`

Do not move existing files just to fit the scaffold.

## Step 1: Identify The Real Artifact Tracks

Before writing the manifest, inspect the repo as it already exists.

For `ids126`, the real structure is:

- active decks live in week directories such as `01week/`, `02week/`, and `03week/`
- the starter deck is `new-week-slides.qmd`
- shared slide support code lives in `shared/slides/_common.R`
- there is no active paper track
- the slide theme comes from `caltech-revealjs`, vendored into `_extensions/caltech`

That means the workflow should describe the repo honestly rather than inventing placeholder directories.

## Step 2: Write `AGENTS.md`

Use `AGENTS.md` to explain:

- what the repo is for
- which artifact track is primary
- real render commands
- source-of-truth rules
- anything Codex should avoid changing

For `ids126`, the important points were:

- this is a slide-first teaching repo
- new decks start from `new-week-slides.qmd`
- `~/Dropbox/software/caltech-revealjs` is the canonical theme source
- the course structure should be preserved

## Step 3: Point The Manifest At Real Paths

In an existing repo, the manifest should point at real files and directories.

For `ids126`, the key choices were:

```yaml
paper:
  main: "not-in-use"

analysis:
  root: "shared/"
  entrypoints:
    - "shared/slides/_common.R"
    - "07week/make_gay_total.R"
    - "07week/make_nes1992.R"
    - "07week/make_nes92_ps.R"

slides:
  main: "new-week-slides.qmd"
  format: "quarto"
  theme: "caltech-revealjs"

commands:
  slides_render: "quarto render tests/test-slides.qmd && quarto render 02week/02week-slides.qmd && quarto render 03week/03week-slides.qmd"
```

The important move is that `paper.main` is explicitly `not-in-use` rather than left ambiguous, and `analysis.root` points at `shared/` because that is where the real support code lives.

## Step 4: Add The Local Review Files

Use:

- `workflow/decision-log.md` for durable decisions
- `workflow/substance-review.md` for local review priorities
- `workflow/protected-paths.txt` for intentionally high-risk files
- `workflow/reports/` for saved workflow output

If unfinished work genuinely needs a resumable handoff, use the shared `baton` skill and its ignored `.baton/` directory. Do not add a durable "latest handoff" file to the scaffold.

For `ids126`, the substantive review file focused on:

- pedagogical pacing
- notation consistency across weeks
- careful use of causal language
- alignment between figures, code, and lecture narrative

The protected-paths file should stay short.
For a repo like `ids126`, good candidates would be fragile shared helpers or hand-maintained reference files, not every slide deck in the repo.

## Step 5: Validate Before Doing More

Run:

```bash
bash /path/to/codex-academic-workflow/scripts/validate-scaffold.sh
```

That checks:

- the scaffold files exist
- the manifest has the required sections
- the configured paths actually exist

For `ids126`, this passed without creating `paper/`, `analysis/`, or `slides/` directories because the validator now respects manifest-based paths.

## Step 6: Start Narrow

After the scaffold is in place, do not immediately run every workflow.

For a repo like `ids126`, the sensible first workflow is:

- `deck-review`

Not:

- `paper-workflow submission`

because the repo does not have an active paper track.

## What To Avoid

- Do not rename folders just to match the scaffold placeholders.
- Do not invent a paper track when the repo does not have one.
- Do not duplicate the theme source of truth between the consuming repo and `caltech-revealjs`.
- Do not leave repo-specific logic implicit if it can be written into `AGENTS.md` or `workflow/substance-review.md`.

## Checklist

- Add the thin scaffold files only.
- Point the manifest at real paths.
- Mark unused tracks as `not-in-use`.
- Preserve the repo's existing structure.
- Validate the scaffold.
- Start with the narrowest relevant workflow.

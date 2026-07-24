# Codex Academic Workflow

A thin project scaffold for academic work in Codex.
This repository is the companion template to `codex-skills`, not a replacement for it.

The goal is to keep project-local facts local:

- manuscript paths
- build commands
- bibliography locations
- analysis entrypoints
- slide deck paths
- substantive review criteria

Reusable review logic belongs in `codex-skills`.

## Documentation

Start here:

- [docs/getting-started.md](docs/getting-started.md)
- [docs/manifest-reference.md](docs/manifest-reference.md)
- [docs/how-to-adapt-an-existing-repo.md](docs/how-to-adapt-an-existing-repo.md)

## Design

This scaffold treats three artifact tracks as first-class siblings:

- `paper/`
- `analysis/`
- `slides/`

The minimal project-local workflow state lives under `workflow/`:

- `workflow/project.yml`
- `workflow/decision-log.md`
- `workflow/substance-review.md`
- `workflow/protected-paths.txt`
- `workflow/reports/`

The local `AGENTS.md` file tells Codex how this specific project works.

## How This Fits Together

- `codex-skills` supplies reusable shared skills such as `academic-bootstrap`, `paper-workflow`, `deck-review`, `review-paper-code`, `prose-check`, `apsa-style`, and `assess-outline`.
- this scaffold supplies the thin local files those skills rely on
- `caltech-revealjs` remains the canonical slide theme for Quarto decks when the project wants the Caltech slide track

## Quick Start

1. Copy this scaffold into a new academic project repo, or clone it as a starting point.
2. Fill in:
   - `AGENTS.md`
   - `workflow/project.yml`
   - `workflow/substance-review.md`
3. Install the shared skills you need from `codex-skills`.
4. Run `academic-bootstrap validate` in the project.
5. Use:
   - `paper-workflow` for manuscript review
   - `deck-review` for slide review
   - `review-paper-code` for reproducibility and paper-code alignment

For a fuller walkthrough, see [docs/getting-started.md](docs/getting-started.md).

## Installing Shared Skills

Install the shared skills from `codex-skills` rather than copying them into this repository.
For Jonathan's machines, develop and version skills in `codex-skills`, promote them into the chezmoi mirror with `vendor-skill.sh`, and apply that mirror to `~/.codex/skills`.

Typical install targets:

- `skills/academic-bootstrap`
- `skills/paper-workflow`
- `skills/deck-review`
- `skills/review-paper-code`
- `skills/prose-check`
- `skills/prose-revision`
- `skills/apsa-style`
- `skills/assess-outline`

For projects with preregistrations or grants, also install:

- `skills/review-pap`
- `skills/review-grant`

## Applying The Scaffold To An Existing Repo

For an existing project:

1. Copy in the thin scaffold files rather than restructuring the whole repo.
2. Point `workflow/project.yml` at the repo's real manuscript, analysis, and slide paths.
3. Record project-specific instructions in `AGENTS.md`.
4. Run `academic-bootstrap validate`.
5. Start with the narrowest relevant workflow:
   - `paper-workflow draft`
   - `paper-workflow submission`
   - `paper-workflow code`
   - `deck-review`

The manifest fields used by those commands are documented in [docs/manifest-reference.md](docs/manifest-reference.md).

## Suggested Skill Set

For most projects:

- `academic-bootstrap`
- `paper-workflow`
- `deck-review`
- `review-paper-code`
- `prose-check`
- `prose-revision`
- `apsa-style`
- `assess-outline`

Add `review-pap` and `review-grant` when relevant.

## Validation

Run:

```bash
bash scripts/validate-scaffold.sh
bash scripts/smoke-test.sh
```

`validate-scaffold.sh` checks that the local scaffold files and directories exist and flags obvious manifest gaps.
`smoke-test.sh` validates the root scaffold plus all bundled examples and performs lightweight renders when local tools are available.

Additional helper scripts:

- `scripts/check-protected-paths.sh`
- `scripts/run-verifications.sh`

## Examples

The `examples/` directory includes:

- `latex-paper/` for a LaTeX manuscript track
- `quarto-paper/` for a Quarto manuscript track
- `slides-deck/` for a Quarto slide deck using `caltech-revealjs`

The examples are intentionally small.
They are there to exercise the manifest shape and workflow expectations, not to serve as polished academic templates.

## Scope

This repo intentionally does not vendor shared skills, hidden hooks, or copied Claude workflow files.
It is a thin local scaffold for Codex projects.

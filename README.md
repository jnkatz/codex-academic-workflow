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

## Design

This scaffold treats three artifact tracks as first-class siblings:

- `paper/`
- `analysis/`
- `slides/`

The minimal project-local workflow state lives under `workflow/`:

- `workflow/project.yml`
- `workflow/decision-log.md`
- `workflow/substance-review.md`
- `workflow/reports/`

The local `AGENTS.md` file tells Codex how this specific project works.

## How This Fits Together

- `codex-skills` supplies reusable shared skills such as `academic-bootstrap`, `paper-workflow`, `deck-review`, `review-paper`, `review-paper-code`, `proofread`, and `write-well`.
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

## Suggested Skill Set

For most projects:

- `academic-bootstrap`
- `paper-workflow`
- `deck-review`
- `review-paper-light`
- `review-paper`
- `review-paper-code`
- `proofread`
- `write-well`
- `apsa-style`
- `assess-outline`

Add `review-pap` and `review-grant` when relevant.

## Validation

Run:

```bash
bash scripts/validate-scaffold.sh
```

This checks that the local scaffold files and directories exist and flags obvious manifest gaps.

## Examples

The `examples/` directory includes:

- `latex-paper/` for a LaTeX manuscript track
- `quarto-paper/` for a Quarto manuscript track
- `slides-deck/` for a Quarto slide deck using `caltech-revealjs`

## Scope

This repo intentionally does not vendor shared skills, hidden hooks, or copied Claude workflow files.
It is a thin local scaffold for Codex projects.

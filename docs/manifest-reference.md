# Manifest Reference

The local workflow manifest lives at `workflow/project.yml`.
Its job is to tell the shared skills where the real project artifacts live.

## Minimal Shape

```yaml
project:
  name: "my-project"
  domain: "social-science"

paper:
  type: "paper"
  format: "quarto"
  main: "paper/paper.qmd"
  bibliography: "paper/references.bib"

analysis:
  root: "analysis/"
  entrypoints:
    - "analysis/run.R"
  dependency_files:
    - "analysis/renv.lock"
  outputs:
    tables: []
    figures: []

slides:
  main: "slides/lecture-01.qmd"
  format: "quarto"
  theme: "caltech-revealjs"

commands:
  paper_build: "quarto render paper/paper.qmd"
  analysis_check: "Rscript analysis/run.R"
  slides_render: "quarto render slides/lecture-01.qmd"
```

## Top-Level Sections

### `project`

- `name`: short project name
- `domain`: loose domain label such as `economics`, `political-science`, or `teaching`

### `paper`

- `type`: `paper`, `pap`, or `grant`
- `format`: `latex`, `quarto`, or `unknown`
- `main`: path to the main manuscript, or `not-in-use`
- `bibliography`: main bibliography path, or `not-in-use`

Use `not-in-use` when a project genuinely has no paper track.

### `analysis`

- `root`: main analysis directory or other real code root
- `entrypoints`: scripts most relevant to the workflow
- `dependency_files`: lockfiles, environment files, or other reproducibility files
- `outputs.tables`: known table output locations
- `outputs.figures`: known figure output locations

For existing repos, this can point at shared support code rather than a literal `analysis/` directory.

### `slides`

- `main`: main deck file or slide root path
- `format`: `quarto`, `beamer`, or `unknown`
- `theme`: theme dependency name, usually `caltech-revealjs` for the Caltech slide track

Use a real path even if the repo has many decks.
For a multi-deck course repo, point this at the starter deck or primary render entrypoint.

### `commands`

- `paper_build`: the most useful explicit paper build command
- `analysis_check`: the most useful explicit analysis verification command
- `slides_render`: the most useful explicit slide render command

These should be commands a human would actually run.
Prefer explicit commands over clever wrappers.

## Existing-Repo Guidance

The manifest is not a demand that every repo adopt the scaffold's placeholder directories.
Point it at the paths the repo already uses.

Good examples:

- `paper.main: not-in-use` for a teaching repo with no paper track
- `analysis.root: shared/` for a course repo with shared code helpers
- `slides.main: new-week-slides.qmd` for a multi-deck course repo

## Validation Rules

The scaffold validator checks:

- required scaffold files exist
- the manifest has the required top-level sections
- configured track paths exist when they are in use
- `not-in-use` is accepted for intentionally unused tracks

It does not verify that the commands succeed.
That remains the job of project-specific smoke tests or manual checks.

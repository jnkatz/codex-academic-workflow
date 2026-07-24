# Getting Started

This guide explains how to use the split Codex academic workflow in practice.

The workflow has three parts:

- `codex-skills`: reusable shared skills
- `codex-academic-workflow`: the thin local scaffold
- `caltech-revealjs`: the slide theme dependency for Quarto decks when you want the Caltech slide track

## Choose Your Starting Point

### New project

Use the scaffold repo directly when you are starting a new academic project and want a standard local structure.

Steps:

1. Create a new repo from this scaffold or copy its top-level files into a new repo.
2. Fill in `AGENTS.md`.
3. Fill in `workflow/project.yml`.
4. Fill in `workflow/substance-review.md`.
5. Install the shared skills you need from `codex-skills`.
6. Run `academic-bootstrap validate`.

### Existing project

Use the scaffold selectively when a repo already has a real structure you do not want to disturb.

Steps:

1. Copy only:
   - `AGENTS.md`
   - `scripts/check-protected-paths.sh`
   - `scripts/run-verifications.sh`
   - `workflow/project.yml`
   - `workflow/decision-log.md`
   - `workflow/substance-review.md`
   - `workflow/protected-paths.txt`
   - `workflow/reports/`
2. Point `workflow/project.yml` at the repo's actual manuscript, code, and slide paths.
3. Preserve the repo's existing structure; do not move files just to fit the scaffold.
4. Run `academic-bootstrap validate`.

For a worked example, see [how-to-adapt-an-existing-repo.md](how-to-adapt-an-existing-repo.md).

## Install The Shared Skills

Typical starting set:

- `academic-bootstrap`
- `paper-workflow`
- `deck-review`
- `review-paper-code`
- `prose-check`
- `prose-revision`
- `apsa-style`
- `assess-outline`

Add these when relevant:

- `review-pap`
- `review-grant`

Preferred install method:

- develop and version personal skills in `jnkatz/codex-skills`
- promote the catalog into the chezmoi mirror with `vendor-skill.sh`
- apply the mirror to `~/.codex/skills`; do not hand-copy or symlink source directories

## Fill In The Local Files

### `AGENTS.md`

Use this for project-local facts:

- what the repo is for
- which artifact track is primary
- real build/render commands
- notation and writing conventions
- repo-specific warnings

### `workflow/project.yml`

Use this as the machine-readable pointer file for the workflow.
Point it at the real paths, not idealized ones.

Examples:

- a LaTeX paper project can set `paper.main: paper/main.tex`
- a Quarto paper project can set `paper.main: paper/paper.qmd`
- a slide-first teaching repo can set `paper.main: not-in-use`

### `workflow/substance-review.md`

Use this for the domain-specific review rubric that should stay local to the project.
This is where project-specific “agent logic” lives in explicit written form.

### `workflow/decision-log.md`

Use this for durable decisions and repeated corrections.
If Codex keeps making the same wrong assumption, record the correction here.

### `workflow/protected-paths.txt`

Use this for a short list of paths that should be treated as high-risk.
The scaffold includes `scripts/check-protected-paths.sh` as an explicit safeguard.

Typical candidates:

- bibliography files
- fragile shared helpers
- hand-maintained reference materials

### Unfinished-work handoffs

Use the shared `baton` skill when unfinished work genuinely needs a resumable handoff. Batons live under the project's ignored `.baton/` directory and are not part of the durable scaffold. Put lasting decisions in `workflow/decision-log.md`.

## Common Commands

After setup, the normal workflow is:

1. `academic-bootstrap validate`
2. `paper-workflow draft` or `paper-workflow submission`
3. `paper-workflow code`
4. `deck-review`
5. `bash scripts/run-verifications.sh`
6. `bash scripts/check-protected-paths.sh`

Use the narrowest command that matches the current task.

## Recommended Patterns

- Keep shared logic in skills, not in copied project scripts.
- Keep project-local facts in `AGENTS.md` and `workflow/`.
- Use explicit saved reports rather than hidden automation.
- Do not force every repo into literal `paper/`, `analysis/`, and `slides/` directories when existing paths already work.

## What This Workflow Does Not Do

- It does not vendor the shared skills into every project.
- It does not recreate Claude-specific hooks or hidden agents.
- It does not replace project judgment with automation.

#!/bin/sh
set -eu

root_dir="$(pwd)"
status=0

run_validate() {
  dir="$1"
  printf '\n==> Validating %s\n' "$dir"
  if (cd "$dir" && sh "$root_dir/scripts/validate-scaffold.sh"); then
    :
  else
    status=1
  fi
}

run_optional_quarto_render() {
  dir="$1"
  file="$2"

  if ! command -v quarto >/dev/null 2>&1; then
    printf 'SKIP: quarto not found for %s/%s\n' "$dir" "$file"
    return 0
  fi

  printf 'RENDER: %s/%s\n' "$dir" "$file"
  if (cd "$dir" && quarto render "$file"); then
    :
  else
    status=1
  fi
}

printf 'Running scaffold smoke tests in %s\n' "$root_dir"

run_validate "$root_dir"
run_validate "$root_dir/examples/latex-paper"
run_validate "$root_dir/examples/quarto-paper"
run_validate "$root_dir/examples/slides-deck"

run_optional_quarto_render "$root_dir/examples/quarto-paper" "paper/paper.qmd"

if [ -d "$root_dir/examples/slides-deck/_extensions/caltech" ]; then
  run_optional_quarto_render "$root_dir/examples/slides-deck" "slides/lecture-01.qmd"
else
  printf 'SKIP: slides example render requires local caltech-revealjs installation in examples/slides-deck/_extensions/caltech\n'
fi

if [ "$status" -eq 0 ]; then
  printf '\nSmoke tests passed.\n'
else
  printf '\nSmoke tests found failures.\n'
fi

exit "$status"

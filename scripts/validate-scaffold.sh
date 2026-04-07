#!/bin/sh
set -eu

status=0

check_path() {
  path="$1"
  kind="$2"
  if [ "$kind" = "file" ] && [ -f "$path" ]; then
    printf 'OK: %s\n' "$path"
  elif [ "$kind" = "dir" ] && [ -d "$path" ]; then
    printf 'OK: %s/\n' "$path"
  else
    printf 'MISSING: %s\n' "$path"
    status=1
  fi
}

check_manifest_key() {
  key="$1"
  if command -v rg >/dev/null 2>&1; then
    matcher="rg -n"
  else
    matcher="grep -nE"
  fi

  if $matcher "^[[:space:]]*$key:" workflow/project.yml >/dev/null 2>&1; then
    printf 'OK: workflow/project.yml contains key "%s"\n' "$key"
  else
    printf 'CHECK: workflow/project.yml is missing key "%s"\n' "$key"
    status=1
  fi
}

printf 'Validating Codex academic scaffold in %s\n' "$(pwd)"

check_path AGENTS.md file
check_path workflow dir
check_path workflow/project.yml file
check_path workflow/decision-log.md file
check_path workflow/substance-review.md file
check_path workflow/reports dir
check_path paper dir
check_path analysis dir
check_path slides dir

check_manifest_key project
check_manifest_key paper
check_manifest_key analysis
check_manifest_key slides
check_manifest_key commands

if [ "$status" -eq 0 ]; then
  printf 'Scaffold validation passed.\n'
else
  printf 'Scaffold validation found gaps.\n'
fi

exit "$status"

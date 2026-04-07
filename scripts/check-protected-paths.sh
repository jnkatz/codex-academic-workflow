#!/bin/sh
set -eu

protected_file="workflow/protected-paths.txt"
status=0

if [ ! -f "$protected_file" ]; then
  printf 'MISSING: %s\n' "$protected_file"
  exit 1
fi

patterns_file="$(mktemp)"
paths_file="$(mktemp)"
trap 'rm -f "$patterns_file" "$paths_file"' EXIT

grep -v '^[[:space:]]*#' "$protected_file" | sed '/^[[:space:]]*$/d' >"$patterns_file"

if [ "$#" -gt 0 ]; then
  printf '%s\n' "$@" >"$paths_file"
elif git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  {
    git diff --name-only
    git diff --cached --name-only
    git ls-files --others --exclude-standard
  } | sed '/^$/d' | sort -u >"$paths_file"
else
  printf 'No paths provided and not inside a git repository.\n'
  exit 1
fi

if [ ! -s "$paths_file" ]; then
  printf 'No candidate paths to check.\n'
  exit 0
fi

printf 'Checking protected paths using %s\n' "$protected_file"

while IFS= read -r path; do
  [ -z "$path" ] && continue
  matched=0
  while IFS= read -r pattern; do
    case "$path" in
      $pattern)
        printf 'BLOCK: %s matches protected pattern %s\n' "$path" "$pattern"
        matched=1
        status=1
        ;;
    esac
  done <"$patterns_file"

  if [ "$matched" -eq 0 ]; then
    printf 'OK: %s\n' "$path"
  fi
done <"$paths_file"

exit "$status"

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

manifest_value() {
  section="$1"
  key="$2"
  awk -v section="$section" -v key="$key" '
    $0 ~ "^" section ":" {
      in_section = 1
      next
    }
    in_section && $0 ~ "^[A-Za-z_]+:" {
      in_section = 0
    }
    in_section {
      line = $0
      sub(/^[[:space:]]+/, "", line)
      if (line ~ "^" key ":") {
        sub(/^[^:]+:[[:space:]]*/, "", line)
        gsub(/"/, "", line)
        print line
        exit
      }
    }
  ' workflow/project.yml
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

check_track_path() {
  label="$1"
  path="$2"

  if [ -z "$path" ]; then
    printf 'CHECK: %s track has no configured path\n' "$label"
    status=1
    return
  fi

  if [ "$path" = "not-in-use" ]; then
    printf 'OK: %s track marked not in use\n' "$label"
    return
  fi

  if [ -e "$path" ]; then
    printf 'OK: %s track path exists: %s\n' "$label" "$path"
  else
    printf 'MISSING: %s track path does not exist: %s\n' "$label" "$path"
    status=1
  fi
}

printf 'Validating Codex academic scaffold in %s\n' "$(pwd)"

check_path AGENTS.md file
check_path workflow dir
check_path workflow/project.yml file
check_path workflow/decision-log.md file
check_path workflow/substance-review.md file
check_path workflow/protected-paths.txt file
check_path workflow/handoff.md file
check_path workflow/reports dir

paper_main="$(manifest_value paper main)"
analysis_root="$(manifest_value analysis root)"
slides_main="$(manifest_value slides main)"

check_track_path "paper" "$paper_main"
check_track_path "analysis" "$analysis_root"
check_track_path "slides" "$slides_main"

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

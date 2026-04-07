#!/bin/sh
set -eu

target="${1:-all}"
status=0

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

run_named_command() {
  label="$1"
  track_path="$2"
  command_text="$3"

  if [ "$track_path" = "not-in-use" ]; then
    printf 'SKIP: %s track marked not in use\n' "$label"
    return
  fi

  if [ -z "$command_text" ] || printf '%s' "$command_text" | grep -q 'replace-with-'; then
    printf 'CHECK: %s command is not configured\n' "$label"
    status=1
    return
  fi

  printf '\n==> %s\n' "$label"
  printf 'RUN: %s\n' "$command_text"

  if sh -lc "$command_text"; then
    :
  else
    status=1
  fi
}

if [ ! -f workflow/project.yml ]; then
  printf 'MISSING: workflow/project.yml\n'
  exit 1
fi

paper_main="$(manifest_value paper main)"
analysis_root="$(manifest_value analysis root)"
slides_main="$(manifest_value slides main)"
paper_build="$(manifest_value commands paper_build)"
analysis_check="$(manifest_value commands analysis_check)"
slides_render="$(manifest_value commands slides_render)"

case "$target" in
  all)
    run_named_command "paper_build" "$paper_main" "$paper_build"
    run_named_command "analysis_check" "$analysis_root" "$analysis_check"
    run_named_command "slides_render" "$slides_main" "$slides_render"
    ;;
  paper)
    run_named_command "paper_build" "$paper_main" "$paper_build"
    ;;
  analysis)
    run_named_command "analysis_check" "$analysis_root" "$analysis_check"
    ;;
  slides)
    run_named_command "slides_render" "$slides_main" "$slides_render"
    ;;
  *)
    printf 'Usage: %s [all|paper|analysis|slides]\n' "$0"
    exit 1
    ;;
esac

if [ "$status" -eq 0 ]; then
  printf '\nVerification commands passed.\n'
else
  printf '\nVerification commands found failures or missing configuration.\n'
fi

exit "$status"

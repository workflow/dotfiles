# Runs plannotator-fresh-plan against a stub `plannotator` that echoes the
# hook event it receives on stdin.
set -euo pipefail

main() {
  test_replaces_stale_plan_with_plan_file_contents
  test_keeps_the_rest_of_the_event
  test_passes_event_through_without_plan_file_path
  test_passes_event_through_when_plan_file_is_missing
  echo "plannotator-fresh-plan: all tests passed"
}

test_replaces_stale_plan_with_plan_file_contents() {
  local plan_file
  plan_file=$(plan_file_containing $'# Fresh plan\n\nwith "quotes" and \\ backslashes')

  local received
  received=$(event_with_plan "# Stale plan" "$plan_file" | plannotator-fresh-plan)

  assert_eq "$(jq -j .tool_input.plan <<<"$received")" "$(cat "$plan_file")"
}

test_keeps_the_rest_of_the_event() {
  local plan_file
  plan_file=$(plan_file_containing "# Fresh plan")

  local received
  received=$(event_with_plan "# Stale plan" "$plan_file" | plannotator-fresh-plan)

  assert_eq "$(jq -c 'del(.tool_input.plan)' <<<"$received")" \
    "$(event_with_plan "# Stale plan" "$plan_file" | jq -c 'del(.tool_input.plan)')"
}

test_passes_event_through_without_plan_file_path() {
  local event='{"hook_event_name":"PermissionRequest","tool_input":{"plan":"# Inline plan"}}'

  local received
  received=$(plannotator-fresh-plan <<<"$event")

  assert_eq "$(jq -c . <<<"$received")" "$(jq -c . <<<"$event")"
}

test_passes_event_through_when_plan_file_is_missing() {
  local event
  event=$(event_with_plan "# Inline plan" /nonexistent/plan.md)

  local received
  received=$(plannotator-fresh-plan <<<"$event")

  assert_eq "$(jq -c . <<<"$received")" "$(jq -c . <<<"$event")"
}

plan_file_containing() {
  local plan_file
  plan_file=$(mktemp)
  printf '%s' "$1" >"$plan_file"
  echo "$plan_file"
}

event_with_plan() {
  jq -n --arg plan "$1" --arg path "$2" '{
    session_id: "s1",
    hook_event_name: "PermissionRequest",
    tool_name: "ExitPlanMode",
    tool_input: {plan: $plan, planFilePath: $path}
  }'
}

assert_eq() {
  if [ "$1" != "$2" ]; then
    printf 'FAIL %s\n  actual:   %q\n  expected: %q\n' "${FUNCNAME[1]}" "$1" "$2" >&2
    exit 1
  fi
}

main

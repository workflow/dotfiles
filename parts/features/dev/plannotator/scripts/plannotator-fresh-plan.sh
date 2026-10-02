event=$(cat)
plan_file=$(jq -r '.tool_input.planFilePath // empty' <<<"$event")

if [ -n "$plan_file" ] && [ -f "$plan_file" ]; then
  event=$(jq --rawfile plan "$plan_file" '.tool_input.plan = $plan' <<<"$event")
fi

exec plannotator <<<"$event"

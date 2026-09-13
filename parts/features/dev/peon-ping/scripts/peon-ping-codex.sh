# Codex hooks feed the upstream codex adapter, which needs bash and python3 on
# PATH and must stay silent: plain-text stdout is invalid for Codex's Stop
# event and becomes model context on UserPromptSubmit.
bash "$PEON_CODEX_ADAPTER" "$@" >/dev/null 2>&1 || true

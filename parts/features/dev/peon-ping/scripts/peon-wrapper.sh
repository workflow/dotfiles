export CLAUDE_PEON_DIR="${CLAUDE_PEON_DIR:-$HOME/.claude/hooks/peon-ping}"
exec bash "$PEON_SCRIPT_PATH" "$@"

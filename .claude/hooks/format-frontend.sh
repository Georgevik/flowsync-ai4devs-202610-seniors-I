#!/usr/bin/env bash
# PostToolUse: formatea con Prettier los archivos de frontend/src que modifica un agente.
file=$(jq -r '.tool_input.file_path // empty')
frontend="$CLAUDE_PROJECT_DIR/frontend"

case "$file" in
  "$frontend"/src/*) ;;
  *) exit 0 ;;
esac
[ -f "$file" ] || exit 0

cd "$frontend" && npx --no-install prettier --write --ignore-unknown --log-level warn "$file" >&2
exit 0

#!/usr/bin/env bash
# PostToolUse hook: formats a frontend/src file with prettier after an agent edits it.
set -u

file=$(node -e 'let d="";process.stdin.on("data",c=>d+=c).on("end",()=>{try{process.stdout.write(JSON.parse(d).tool_input?.file_path??"")}catch{}})')

root="${CLAUDE_PROJECT_DIR:-$(pwd)}/frontend/src/"
case "$file" in
  "$root"*.ts|"$root"*.tsx|"$root"*.js|"$root"*.jsx|"$root"*.css|"$root"*.json|"$root"*.html|"$root"*.md)
    cd "$(dirname "$root")/.." && npx --no-install prettier --write "$file" >/dev/null 2>&1
    ;;
esac
exit 0

#!/usr/bin/env bash
# Generate Conventional Commits messages from the staged diff using a local
# OpenAI-compatible model (LM Studio by default). Called by the lazygit "X"
# custom command; output is one commit message per line for its menu.
#
# On failure it prints a human-readable reason and exits non-zero, so lazygit
# surfaces it in an Error popup instead of silently showing an empty menu.
#
# Overridable via env: LG_AI_ENDPOINT, LG_AI_MODEL, LG_AI_TIMEOUT.
set -euo pipefail

SELECTED_TYPE="${1:-ai-defined}"
COMMITS_TO_SUGGEST="${2:-2}"
ENDPOINT="${LG_AI_ENDPOINT:-http://127.0.0.1:1234/v1/chat/completions}"
MODEL="${LG_AI_MODEL:-gemma-4-e4b-it}"
TIMEOUT="${LG_AI_TIMEOUT:-120}"

die() { printf '%s\n' "$*" >&2; exit 1; }

command -v curl >/dev/null 2>&1 || die "curl not found on PATH."
command -v jq   >/dev/null 2>&1 || die "jq not found on PATH."

diff=$(git diff --cached)
[ -n "$diff" ] || die "No staged changes. Stage something first."

PROMPT=$(cat <<EOF
You are an expert at writing Git commits in the Conventional Commits format.
The user selected type: $SELECTED_TYPE

Rules:
- Structure: <type>(<scope>): <description>
- If the type is ai-defined, pick the most suitable type; otherwise use $SELECTED_TYPE
- Add a scope in parentheses when it helps (e.g. auth, api, ui, config)
- Use "!" for breaking changes: type(scope)!: description
- lowercase description, imperative mood, under 50 chars, no trailing period
- Output exactly $COMMITS_TO_SUGGEST messages, one per line
- No markdown, no numbering, no explanations

Recent commits for context:
$(git log --oneline -10)

Staged diff to analyze:
$diff
EOF
)

PAYLOAD=$(printf '%s' "$PROMPT" | jq -Rs --arg model "$MODEL" \
  '{model: $model, messages: [{role: "user", content: .}], temperature: 0.3}')

# Call the model. Capture body + HTTP status; -sS keeps curl quiet but still
# reports transport errors (server down, DNS, timeout) on stderr.
if ! response=$(curl -sS --connect-timeout 3 --max-time "$TIMEOUT" \
  -w $'\n%{http_code}' \
  "$ENDPOINT" -H 'Content-Type: application/json' -d "$PAYLOAD" 2>&1); then
  curl_msg=$(printf '%s' "$response" | grep -m1 '^curl:' || true)
  die "Cannot reach model server at $ENDPOINT
Is it running? ${curl_msg:-connection failed}"
fi

http_code="${response##*$'\n'}"
body="${response%$'\n'*}"

# Some servers (e.g. LM Studio) return {"error":...} even with HTTP 200, so
# check the body for an error regardless of status. The `?` guards against
# .error being a plain string rather than an object.
api_err=$(printf '%s' "$body" | jq -r '(.error.message? // .error?) // empty' 2>/dev/null || true)
if [ "$http_code" != "200" ] || [ -n "$api_err" ]; then
  die "Model request failed (HTTP ${http_code})${api_err:+: $api_err}
Check that model \"$MODEL\" is loaded at $ENDPOINT."
fi

content=$(printf '%s' "$body" | jq -r '.choices[0].message.content // empty' 2>/dev/null || true)
[ -n "$content" ] || die "Model returned no commit messages (empty response)."

printf '%s\n' "$content"

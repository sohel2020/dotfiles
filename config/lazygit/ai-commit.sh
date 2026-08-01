#!/usr/bin/env bash
# Generate Conventional Commits messages from the staged diff using a local
# OpenAI-compatible model (LM Studio by default). Called by the lazygit "X"
# custom command; output is one commit message per line for its menu.
set -euo pipefail

SELECTED_TYPE="${1:-ai-defined}"
COMMITS_TO_SUGGEST="${2:-2}"
ENDPOINT="${LG_AI_ENDPOINT:-http://127.0.0.1:1234/v1/chat/completions}"
MODEL="${LG_AI_MODEL:-gemma-4-e4b-it}"

diff=$(git diff --cached)
if [ -z "$diff" ]; then
  echo "No staged changes. Stage something first."
  exit 1
fi

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

curl -s "$ENDPOINT" -H 'Content-Type: application/json' -d "$PAYLOAD" \
  | jq -r '.choices[0].message.content // empty'

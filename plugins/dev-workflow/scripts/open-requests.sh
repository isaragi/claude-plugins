#!/bin/bash
# Prints the open user requests of the current repository (GitHub issues labelled
# "user-request"), with their `area:` labels, so Claude keeps them in view.
#
# Runs from two hooks and decides from the hook's JSON on stdin:
# - SessionStart (startup, resume, clear, compact): always prints. A new or compacted context
#   has lost the list.
# - UserPromptSubmit: prints only when the prompt asks about the state of the work (状況・進捗・
#   残タスク・やること・依頼・status・todo). On every other message it prints nothing, so the
#   list does not cost tokens on each turn (author's request, 2026-10-17).
# Without stdin JSON (run by hand) it prints.
# Silent outside a GitHub repository, when offline, or when gh is unavailable.
git rev-parse --is-inside-work-tree >/dev/null 2>&1 || exit 0

if [ ! -t 0 ]; then
    input=$(cat)
    if [ -n "$input" ] && command -v python3 >/dev/null 2>&1; then
        decision=$(printf '%s' "$input" | python3 -c '
import json, re, sys
try:
    data = json.load(sys.stdin)
except Exception:
    print("print"); sys.exit()
if data.get("hook_event_name") == "UserPromptSubmit":
    prompt = data.get("prompt") or ""
    asks = re.search(r"状況|進捗|残タスク|やること|やるべきこと|依頼|頼んだ|status|todo", prompt, re.I)
    print("print" if asks else "skip")
else:
    print("print")
' 2>/dev/null)
        [ "$decision" = "skip" ] && exit 0
    fi
fi

list=$(gh issue list --label user-request --state open --limit 50 \
    --json number,title,labels \
    --jq '.[] | "- #\(.number)" + ((.labels | map(.name | select(startswith("area:")) | sub("^area:"; "")) | join(",")) as $a | if $a == "" then "" else " [\($a)]" end) + " \(.title)"' \
    2>/dev/null) || exit 0
[ -z "$list" ] && exit 0
echo "未完了のユーザーの依頼（GitHub issue, label user-request。[ ] は area ラベル。終わったら閉じる。状況の報告ではすべてに触れる）:"
echo "$list"

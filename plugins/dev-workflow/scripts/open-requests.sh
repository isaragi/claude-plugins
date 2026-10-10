#!/bin/bash
# Prints the open user requests of the current repository (GitHub issues labelled
# "user-request"), so Claude sees them on every prompt (UserPromptSubmit hook).
# Silent outside a GitHub repository, when offline, or when gh is unavailable.
git rev-parse --is-inside-work-tree >/dev/null 2>&1 || exit 0
list=$(gh issue list --label user-request --state open --limit 50 \
    --json number,title --jq '.[] | "- #\(.number) \(.title)"' 2>/dev/null) || exit 0
[ -z "$list" ] && exit 0
echo "未完了のユーザーの依頼（GitHub issue, label user-request。終わったら閉じる。状況の報告ではすべてに触れる）:"
echo "$list"

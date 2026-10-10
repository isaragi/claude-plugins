---
name: track-user-requests
description: Turn every user request that is not finished on the spot into a GitHub issue labelled user-request, keep the list in view on every prompt, and report on all of them when asked for status. Use when the user asks for something that will take longer than the current reply, or asks "状況は？".
---

# 頼まれたことを issue で追う

## 受けたとき
- その返事の中で終わらない依頼は、受けた時点で issue にする。
  - `gh issue create --label user-request --title "<依頼の要旨>" --body "<ユーザーの言葉と日付、決まっていること、進め方>"`
  - ラベルがなければ作る：`gh label create user-request --color FBCA04 --description "ユーザーの依頼"`
- ユーザーの判断待ちのものも issue にし、タイトルか本文に「判断待ち」と書く。
- 着手を後回しにするもの（「あとで」）も issue にし、「着手はあと」と書く。

## 進めている間
- 決まったこと・パネルの結論・ユーザーの選択は、その issue にコメントで残す。
- PR には `Closes #<番号>`（完了するとき）か `Refs #<番号>`（一部のとき）を書く。
- メッセージのたびにフックが未完了の一覧を差し込む。毎回目を通し、黙って放置しない。

## 終わったとき
- 報告してから閉じる（PR のマージで自動で閉じてもよい）。一部だけ終わったときは、残りを issue のコメントか本文のチェックリストに書く。

## 「状況は？」と聞かれたら
- 未完了の `user-request` をすべて挙げ、それぞれ「進行中／判断待ち／着手はあと／完了」と次の一手を書く。表にすると読みやすい。
- いま実際に動いている作業と、予告しただけで手を付けていない作業を区別して、正直に書く。

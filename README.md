# claude-plugins

Claude Code 用のプラグインのマーケットプレイスです。複数のリポジトリで使う共通の開発ルールとスキルを、各リポジトリに複製せずに使うために置いています。

## プラグイン

### dev-workflow
| 種類 | 名前 | 内容 |
|---|---|---|
| ルール（セッション開始時に読み込み） | `rules.md` | 日本語で答える、頼まれたことを issue で追う、予告したら着手する、並行して進める、決まったことから導き・測り・残りをパネルで決める、PR のレビューとマージ（Claude API のレビュー `api-review-*` の流れ）、main に push しない、取り消しにくい操作は確認する |
| フック（セッション開始・再開・コンパクト直後と、「状況」「進捗」「残タスク」などを聞いたとき） | `open-requests.sh` | いまのリポジトリの未完了の `user-request` issue を、`area:` ラベル付きで一覧にして差し込む。ほかのメッセージでは差し込まない（トークンの節約）。GitHub のリポジトリでないとき・オフラインのときは何もしない |
| スキル | `persona-panel` | 決まったことからも測っても決まらないデザイン・UX の判断を、10人以上のペルソナのパネル（シミュレーション）に開かれた質問で聞いて決める。問いの書き方、ユーザーの言葉の渡し方、確かめられないものの渡し方 |
| スキル | `blind-pr-review` | Claude API のレビュー（`.github/claude-api-review/`）が無いリポジトリでの予備。背景を伝えない別のエージェントに PR をレビューしてもらう |
| スキル | `ui-pr-evidence` | 画面を変える PR に、変更前後のスクリーンショット（ライト・ダーク）と動画を `gh … --attach` で載せる。見た目の不具合の issue にも画像を貼る |
| スキル | `track-user-requests` | 頼まれたことを `user-request` の issue にし、状況の報告ですべてに触れる |

## 使い方

### 自分の Mac の全プロジェクトで使う
```bash
claude plugin marketplace add isaragi/claude-plugins
claude plugin install dev-workflow@isaragi --scope user
```

### リポジトリから参照する（ファイルは複製しない）
リポジトリの `.claude/settings.json`:
```json
{
  "extraKnownMarketplaces": {
    "isaragi": { "source": { "source": "github", "repo": "isaragi/claude-plugins" } }
  },
  "enabledPlugins": { "dev-workflow@isaragi": true }
}
```
各自の環境では一度 `claude plugin install dev-workflow@isaragi --scope project` を実行します。

### GitHub Actions（anthropics/claude-code-action）
```yaml
- uses: anthropics/claude-code-action@v1
  with:
    anthropic_api_key: ${{ secrets.ANTHROPIC_API_KEY }}
    plugin_marketplaces: "https://github.com/isaragi/claude-plugins.git"
    plugins: "dev-workflow@isaragi"
```

## 注意
- プラグインでは CLAUDE.md を配れないため、常に効かせたいルールは `rules.md` に書き、セッション開始時のフックで読み込ませています。
- ここに置くのは、どのリポジトリ・どの作者にも通じる作業の型です。作者や Mac に固有のこと（作者の好み・許可・端末の制約・日付つきの教訓）は、作者のグローバルの CLAUDE.md に書きます。同じことを両方に書きません。
- リポジトリ固有のこと（ビルドの手順、画面サイズの確認対象、マージの許可など）は、各リポジトリの CLAUDE.md に書きます。

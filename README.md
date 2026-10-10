# claude-plugins

Claude Code 用のプラグインのマーケットプレイスです。複数のリポジトリで使う共通の開発ルールとスキルを、各リポジトリに複製せずに使うために置いています。

## プラグイン

### dev-workflow
| 種類 | 名前 | 内容 |
|---|---|---|
| ルール（セッション開始時に読み込み） | `rules.md` | 日本語で答える、頼まれたことを issue で追う、予告したら着手する、並行して進める、main に push しない、取り消しにくい操作は確認する |
| フック（メッセージごと） | `open-requests.sh` | いまのリポジトリの未完了の `user-request` issue を一覧にして差し込む（GitHub のリポジトリでないとき・オフラインのときは何もしない） |
| スキル | `persona-panel` | デザイン・UX の判断を、10人以上のペルソナのパネル（シミュレーション）に開かれた質問で聞いて決める |
| スキル | `blind-pr-review` | 背景を伝えない別のエージェントに PR をレビューしてもらい、通ればマージする |
| スキル | `ui-pr-evidence` | 画面を変える PR に、変更前後のスクリーンショット（ライト・ダーク）と動画を載せる |
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
- リポジトリ固有のこと（ビルドの手順、画面サイズの確認対象など）は、各リポジトリの CLAUDE.md に書きます。

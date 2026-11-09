# セキュリティ移行計画 v2

## 現在地

- Chunk 1・2のみ完了。以降の実装は承認まで停止。
- 本番FirestoreとローカルRulesは`request.auth != null`。
- Firestore usersは126件、全件に非空の平文`password`がある。
- email重複が1件ある。
- VercelのNeon Postgres `neon-cyan-flask`は接続済み。
- Neon Managed Authも有効だが使用せず、Better Authを専用schemaへセルフホストする。
- Firestore PITR・バックアップはbilling未有効のため未設定。

## 目標構成

- 認証の正本: Vercel上のBetter Auth
- 認証DB: Neon Postgresの専用`better_auth` schema
- Flutter: Better Auth Bearer sessionをKeychain/Keystoreへ保存
- Firestore UID: 既存Firebase UIDを維持
- 橋渡し: Better Auth session検証後にFirebase Custom Tokenを発行
- 認可の正本: クライアント書込不可の`access/{firebaseUid}`
- role: `employee` / `leader` / `admin` / `developer`
- 部署境界: 支社・部署の組を表す`scopeKey`

## 判定ゲート

1. Firestore全件更新前にPITR/バックアップ、または明示的なリスク承認が必要。
2. 重複email 1件を解消するまで全件移行しない。
3. Better Auth失効後にFirestoreを拒否できなければCustom Token案を固定せず、機密データのVercel API経由化へ切り替える。
4. 旧アプリを遮断するまでFirestoreの`password`を一括削除しない。
5. 各Chunkを独立コミットし、Production deploy/data writeは別承認にする。

## Chunk 1: 現状固定（完了）

- Firebase・Vercel接続先、Rules、コレクション、API面を記録。
- 平文126件、重複email 1件を値を出さず集計。
- セキュリティ作業ブランチを作成。

## Chunk 2: 匿名アクセス停止（完了）

- 本番Firestoreが認証必須であることを確認。
- ローカルRulesを本番の暫定Rulesへ同期し、構文検証。

## Chunk 3: 管理APIと新規平文保存の緊急封じ込め（実装済み・本番デプロイ待ち）

- create/delete/sendToTopic APIをFirebase ID Token＋暫定admin判定で保護。
- Flutterから現在のFirebase ID Tokenを送る。
- request body、password、token、UserRecord等のログを削除。
- 新規Firestore userへ`password`を書かない（`toJson`からも除外）。
- 未認証401、一般社員403、管理者成功をテスト。

## Chunk 4: NeonとBetter Auth基盤（実装済み・Vercel env反映待ち）

- Neonのリージョン、環境スコープ、pooled/unpooled URLを確認。
- Neon Managed Authを無効化または未使用として整理。
- Better Auth、PostgreSQL、Bearer/Admin pluginを導入。
- Better Auth専用schemaと`firebaseUid`一意フィールドをmigration。
- Previewでsign-up/sign-in/session/revokeを検証。

## Chunk 5: 移行ツールとdry-run（ツール実装済み・重複email未解消）

- Firebase Auth、Firestore users、Better Auth userをUID/emailで照合。
- 重複emailを解消し、126件の行き先を一意化。
- Better Auth公式password hash処理だけを使用。
- 平文を標準出力・例外・監査ログ・一時ファイルへ残さない。
- 冪等性、部分失敗、再実行、ロールバックをテスト。

## Chunk 6: Custom Token失効同期PoC（CONDITIONAL_GO）

- Better Auth Bearer sessionを検証してFirebase Custom Tokenを発行。
- logout/revoke/disable/password change時のFirebase token失効を検証。
- claimがFirebase ID Token更新後も維持されるか確認。
- Better Auth session失効後にFirestoreが規定時間内に拒否することを自動テスト。
- 保証できない場合は、機密FirestoreアクセスをVercel API経由へ切り替える。
- 結果: checkRevoked は数秒で拒否。Firestore Rules は ID Token 期限まで通るため、marker/API 併用が必須。

## Chunk 7: Flutter二重認証と端末移行

- Better Auth→Custom Token→Firebase sign-inを機能フラグ下で実装。
- Firebaseメール/パスワード認証は一時フォールバックとして残す。
- Secure StorageとSQLiteからpasswordを除去する一度限りのmigrationを追加。
- 生体認証を平文password再送からsessionのローカル解除へ変更。
- logoutでBetter Auth revokeとFirebase signOutを両方実施。

## Chunk 8: adminパイロット

- admin 1名だけをBetter Authへ移行。
- login、Firestore、管理API、失効、無効化、再起動、生体認証を実機確認。
- バックアップ条件後、対象adminのFirestore `password`だけ削除。
- 本人確認と監査確認後に全件移行を承認。

## Chunk 9: 全ユーザー移行と平文撤去

- 最低対応バージョンを強制し、旧アプリの平文再作成を止める。
- 小規模バッチでBetter Authへ移行し、成功分だけFirestore passwordを削除。
- 最後にFirestore password 0件を確認。
- モデル、signup、admin作成、SQLite、Secure Storage、ログからpassword依存を削除。
- 不一致や不審アクセス時はsession/token失効とpassword resetへ切り替える。

## Chunk 10: role・scopeとクエリ

- `access/{firebaseUid}`へrole、scopeKeys、roleVersionを作成。
- 既存jobLevel、支社、部署bitmaskから認可データを移行。
- 社員=本人、リーダー=担当支社かつ担当部署、管理者=全件を確定。
- users/profiles/ureports/未回答者取得をscope指定クエリへ変更。
- 必要な複合indexを追加。

## Chunk 11: 最終RulesとAPI認可

- `isSelf`、`isAdmin`、`isLeader`、`canReadScope`を実装。
- access、UID、scope等の認可フィールドをクライアント変更不可にする。
- 全利用コレクションを明示し、未定義パスを拒否。
- 未認証、本人、他人、同部署、別部署、管理者、自己昇格をRules test。
- 管理APIをBetter Auth session＋access認可へ切り替える。

## Chunk 12: 段階展開と監査

- admin→少人数→全社員の順で展開。
- Firebaseメール/パスワード経路をFlutterから廃止。
- 不要なNeon Managed Auth、旧フィールド、ログ、indexを整理。
- 平文0件、端末移行、越境拒否、API認可、失効同期を再監査。
- 緊急失効、権限変更、ロールバック、password reset手順を文書化して再開判定。

## コミット方針

- 原則1 Chunk 1コミット以上。
- FlutterとNext.jsは別リポジトリで対応コミットを明記。
- schema migration、Rules deploy、data migrationはコード変更と分離。
- commit前にlint/test/build、commit後にcleanな作業ツリーを確認。
- push、deploy、本番data writeはcommitとは別操作として都度承認する。

## 完了条件

- Firestore、SQLite、Secure Storage、ログに平文passwordがない。
- Better Auth credential accountだけに公式ハッシュがある。
- Better Auth userとFirebase UIDが一意対応する。
- 未認証、他人、別部署、自己昇格が自動テストで拒否される。
- Better Auth session失効がFirestoreへ規定時間内に反映される。
- 管理APIが有効なsessionとrole/scopeなしでは実行できない。
- 旧アプリが平文を再作成できない。

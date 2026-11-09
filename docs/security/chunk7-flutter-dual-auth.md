# Chunk 7: Flutter二重認証（2026-11-09）

## 実施内容

- `BetterAuthRepository` を追加（機能フラグ `ENABLE_BETTER_AUTH_BRIDGE`）
  - Better Auth sign-in → `/api/auth/firebase-token` → `signInWithCustomToken`
  - Bearer token を Secure Storage へ保存
  - logout で `/api/auth/revoke-bridge` + Firebase signOut
- `AuthService.signInWithEmail` が bridge 優先、失敗時は Firebase メール/パスワードへフォールバック
- Secure Storage の `userHistory` から password を除去する一度限り migration
- サインイン画面は email のみ履歴保存。生体認証は bridge bearer 復元を優先
- 設定ログアウトを `AuthService.signOut()` に統一

## フラグ

`.env`:

```
ENABLE_BETTER_AUTH_BRIDGE=false
```

パイロット（Chunk 8）で admin 端末のみ `true` にする。

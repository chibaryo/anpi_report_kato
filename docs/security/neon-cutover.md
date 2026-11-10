# Neon / Better Auth cutover (Flutter)

## Flags in `.env`

```
ENABLE_BETTER_AUTH_BRIDGE=true
ENABLE_NEON_DATA_API=false
```

## Behavior

| ENABLE_NEON_DATA_API | Login | Data |
|---|---|---|
| false | Bridge or Firebase fallback | Firestore client |
| true | Better Auth only (`/api/app/auth/sign-in`) | Neon APIs (`/api/app/*`) |

## Required before enabling Neon mode

1. CSV migration complete
2. App schema + ETL applied
3. Min version API deployed
4. Device registration via `/api/app/devices`

## Client modules

- `lib/repository/betterauth/session_repository.dart`
- `lib/repository/api/app_api_client.dart`
- `lib/repository/api/notifications_api_repository.dart`
- `lib/providers/betterauth/session_provider.dart`
- Auth/NoAuth guards honor Better Auth bearer when Neon mode is on

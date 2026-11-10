# Flutter Firestore → Neon API provider checklist

`ENABLE_NEON_DATA_API` must stay `false` until each consumer is switched.

| Provider / screen data | Replacement | Status |
|---|---|---|
| Auth session / guards | `SessionRepository`, Auth/NoAuth guards | Done |
| Login / logout / biometric | `AuthService` Neon branch | Done |
| Notifications home | `neonNotificationsProvider` + `NotificationsApiRepository` | Scaffolded |
| Unanswered users | `/api/app/notifications/:id/unanswered` | API ready |
| Report submit | `/api/app/notifications/:id/reports` | API ready |
| Admin send | `/api/app/send-to-topic` | API ready |
| Users admin list | `/api/app/users` | API ready |
| Device / FCM register | `/api/app/devices` | API ready |
| Profile / moiProfile | `/api/app/me` | API ready |
| Topics / officeLocations | ETL in Postgres; add list APIs next | Pending thin GET routes |
| Templates | ETL done; add list API next | Pending |

## Switch procedure per screen

1. Branch on `SessionRepository.isNeonDataEnabled`
2. Call API repository when true
3. Keep Firestore path when false
4. Validate UI with admin pilot
5. Only then flip the global flag

# HTTP client migration plan (feature-first + Riverpod)

This plan maps the legacy `lib/old_services/client.dart` setup onto **ARCHITECTURE.md**: Dio lives under **`lib/core/api/`**, stays free of feature UI, and uses Riverpod for composition in `main.dart` later.

## Goals

- Replace the global `dio` singleton and `Api` static class with an **injectable** `Dio` + **`ApiClient`** wrapper.
- Preserve behavior from the old client: JSON headers, timeouts, Bearer token on requests, consistent error shape (`ApiException`), Talker-backed request logging, 401 handling **without** importing screens into `core/`.
- Keep **`core/`** unaware of `features/` and routing; the app wires auth token / “signed out” callbacks from a feature or bootstrap layer.

## What the old code did (reference)

| Concern | Old (`old_services/client.dart`) | Target in this architecture |
|--------|-----------------------------------|-----------------------------|
| Base URL / timeouts / headers | Hard-coded in module-level `dio` | `BaseOptions` in a factory (env or const), overridable in tests |
| Auth header | `InterceptorsWrapper` → `Auth.getToken()` | `Future<String> Function()? getToken` injected into factory |
| 401 | `Auth.forget()` + `Navigator.push` to `LoginScreen` | `void Function()? onUnauthorized` (or stream); **router redirect** handled outside `core/` |
| Logging | `TalkerDioLogger` | Same, attached via factory when `Talker` is provided |
| Verbs | `Api.get/post/...` + `_request` | `ApiClient` instance methods + shared `_execute` |
| Errors | `ApiException` from `DioException` / fallbacks | `ApiException` in `core/api/` |

## Directory layout (after implementation)

```text
lib/
├── plan.md
├── main.dart                 # ProviderScope overrides, App, AuthGate
├── core/
│   ├── api/
│   │   ├── api_exception.dart
│   │   ├── api_client.dart
│   │   ├── dio_factory.dart
│   │   └── http_pod.dart         # apiBaseUrl, dio, apiClient (Riverpod)
│   ├── cache/
│   │   └── auth_token_store.dart
│   ├── config/
│   │   └── api_config.dart       # kApiBaseUrl (--dart-define=API_BASE_URL=...)
│   ├── providers/
│   │   └── bootstrap_providers.dart
│   └── utils/
│       └── talker_pod.dart
└── features/
    └── auth/
        ├── login_screen.dart
        ├── home_screen.dart
        ├── models/
        ├── providers/
        └── repository/
```

Feature repositories receive `ApiClient` (or `Dio`) via Riverpod providers; they catch `DioException`/`ApiException`, log with Talker, and throw app-level errors for notifiers—matching **ARCHITECTURE.md §2.A**.

## Implementation steps

1. **Dependencies** (in repo): `dio`, `talker`, `talker_dio_logger`. Tests: `http_mock_adapter` to stub responses without real HTTP.
2. **`ApiException`** — implemented in `api_exception.dart` (legacy-style `message` + `code`).
3. **`DioFactory.create`** — builds `Dio` with:
   - `BaseOptions` (baseUrl, connect/receive timeouts, `Accept` / `Content-Type`).
   - **Auth interceptor**: if `getToken != null`, set `Authorization: Bearer …` when non-empty; log soft failures (Talker), do not crash the request pipeline.
   - **401 interceptor**: on `statusCode == 401`, invoke `onUnauthorized` (clear session in provider / repository); **no** `BuildContext` or `LoginScreen` imports in `core/`.
   - **TalkerDioLogger**: when `talker != null`, same style of settings as the old client.
4. **`ApiClient`** — implemented in `api_client.dart`: verb methods, `_execute` returns `response.data`, maps `DioException` to `ApiException` (including `message` / `error` from JSON body when map-shaped); non-Dio errors logged then wrapped. Use `UrlRequestMatcher` in tests when mocking Dio so default header expectations do not block route matching.
5. **Riverpod (follow-up, not required for unit tests)** — e.g. `Provider<Talker>`, `Provider<Dio>` or `Provider<ApiClient>` built with `createDio` using overrides from `main.dart` (secure storage / auth repository callbacks). Aligns with “No GetIt” in ARCHITECTURE.md.
6. **Multipart uploads** — port `post` + `File` + `FormData` from old `Api.post` inside `ApiClient` when a feature needs it (same `FormData.fromMap` pattern).

## Testing strategy

- **Unit tests** live under `test/core/api/`, targeting `ApiClient` with a `Dio` instance whose `httpClientAdapter` is a `MockAdapter` from `http_mock_adapter`.
- Cases to cover:
  - GET returns decoded `data`.
  - `DioException` with JSON body produces `ApiException` with server `message` or `error`.
  - Auth interceptor: when `getToken` returns a token, request headers include `Bearer`.
- **Do not** widget-test the Dio stack; keep HTTP tests fast and hermetic.

## Explicit non-goals (for this slice)

- No new abstract `IHttpClient` unless a second implementation appears.
- No navigation or `MaterialApp` keys inside `core/api/`.
- No Firebase / FCM in the HTTP layer (stays in auth/bootstrap as today).

## Riverpod, Talker, auth (implemented)

- **`main.dart`**: `WidgetsFlutterBinding`, `SharedPreferences.getInstance()`, `ProviderScope(overrides: [sharedPreferencesProvider])`, root `App` wrapped in `TalkerWrapper` (see **ARCHITECTURE.md** logging).
- **Logging**: `talkerProvider` (`lib/core/utils/talker_pod.dart`) — inject via `ref.watch(talkerProvider)`; use `talker.error(...)`, `talker.warning(...)`, etc. instead of `print`.
- **HTTP**: `apiBaseUrlProvider`, `dioProvider`, `apiClientProvider` in `lib/core/api/http_pod.dart`. Dio reads the token from `authTokenStoreProvider` (not from `authProvider`) to avoid circular dependencies.
- **401 → session**: `authSessionRevisionProvider` bumps when the API returns 401 after clearing the token; `authProvider` watches it and re-runs `restoreSession()` so UI returns to login without importing screens into `core/`.
- **Auth feature** (`lib/features/auth/`): `AuthRepository` (login / profile restore / logout), `Auth` notifier (`authProvider`), `LoginScreen`, `AuthHomeScreen`, models `AppUser` + `AuthSession`. Feature scaffold was started with `dart run scripts/generate.dart feature auth` then replaced freezed placeholders with real code.
- **Legacy reference**: `lib/old_services/**` is **excluded from analyzer** in `analysis_options.yaml` (broken imports from the old app). Port patterns from there into this tree when needed (e.g. social login from `auth_service.dart` → new `AuthRepository` methods later).

## Tests

- `test/core/api/api_client_test.dart` — HTTP + DioFactory.
- `test/features/auth/auth_test.dart` — login, logout, restore with `MemoryAuthTokenStore` + mocked Dio.
- `test/widget_test.dart` — app boots to login (uses in-memory token store so secure storage channels are not invoked).

## Checklist

- [x] Document plan (`lib/plan.md`)
- [x] Add `core/api` (`dio_factory.dart`, `api_client.dart`, `api_exception.dart`)
- [x] Add unit tests (`test/core/api/api_client_test.dart`)
- [x] Wire Riverpod + Talker + auth in `main.dart`; 401 clears session via revision notifier (router/`go_router` redirect can be added later)
- [x] Auth feature + login UI (`features/auth`)

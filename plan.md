# Social auth plan (Google + Apple) — feature-first + Riverpod

This plan adds **Google Sign-In** and **Sign in with Apple** to the existing auth flow (currently `AuthRepository.login(email,password)` + `restoreSession()`), while keeping responsibilities aligned with `ARCHITECTURE.md`.

## Current state (what exists)

- **Token persistence**: `core/cache/auth_token_store.dart` stores a bearer token in secure storage.
- **Session lifecycle**:
  - `AuthRepository.login()` calls `POST auth/login`, extracts `token`, stores it, returns `AuthSession`.
  - `AuthRepository.restoreSession()` reads stored token and fetches `GET profile`.
  - `Auth` provider (`features/auth/providers/auth_provider.dart`) exposes `login()` and `logout()`.
- **Legacy reference**: `lib/old_services/auth_service.dart` already contains a working pattern:
  - Google → obtain an OAuth token → call backend `loginBySocialToken('google', token)`
  - Apple → obtain `identityToken` (with nonce) → call backend `loginBySocialToken('apple', token)`

## Goal

- Add **two new sign-in actions**:
  - Google sign-in
  - Apple sign-in (iOS/macOS only; hidden/disabled elsewhere)
- Keep the app’s source of truth the same: **our API token** (stored in `AuthTokenStore`), and user loaded via `GET profile` (or from login response if provided).

## Backend contract (decide and standardize)

Your legacy backend call is:

- `GET social-auth/<provider>/callback?provider=<provider>&token=<token>` → returns `{ token: "..." }`

To integrate cleanly, pick one of these (both are fine; choose what your backend already supports):

- **Option A (recommended)**: `POST auth/social` body `{ provider, token }` → returns `{ token, user? }`
- **Option B (legacy-compatible)**: keep `GET social-auth/<provider>/callback` returning `{ token }`

This plan assumes you keep **Option B** for fast migration, but implements it behind `AuthRepository` so you can swap later without UI changes.

## Dependencies to add (pubspec)

Add runtime dependencies:

- `google_sign_in` (Google)
- `sign_in_with_apple` (Apple)
- `crypto` (only if you implement nonce hashing as in legacy; Apple flow needs SHA-256 of nonce)

Notes:
- `dio`/`riverpod`/`secure_storage` already exist.
- Avoid adding Firebase unless you explicitly want Firebase Auth; this plan uses **native sign-in → backend exchange**.

## Platform setup checklist

### Android (Google)

- Configure Google OAuth client for Android package + SHA-1/SHA-256.
- Ensure `android/app/src/main/AndroidManifest.xml` includes the right intent-filter metadata if required by the plugin version.
- Verify `applicationId` and signing config match the OAuth client.

### iOS (Google + Apple)

- **Apple**:
  - Enable **“Sign In with Apple”** capability in Xcode.
  - Ensure iOS deployment target satisfies plugin requirements.
- **Google**:
  - Add URL schemes for Google Sign-In (`REVERSED_CLIENT_ID`) in `Info.plist` if required.

### Web / Desktop (optional)

- If you plan to support Web later, treat it as a separate follow-up: Google Sign-In on web has extra configuration; Apple on web typically requires a Services ID and redirect URL.

## Code changes (target architecture)

### 1) Extend `AuthRepository` with social login methods

Keep all network + token persistence here (per `ARCHITECTURE.md §2.A`).

Add methods:

- `Future<AuthSession> loginWithGoogle()`
- `Future<AuthSession> loginWithApple()`
- `Future<AuthSession> loginWithSocialToken({required String provider, required String token})`

Implementation outline:

- Google:
  - Use `google_sign_in` to authenticate and obtain a token (access token or id token depending on backend expectation).
  - Call `loginWithSocialToken(provider: 'google', token: <token>)`.
- Apple:
  - Generate `rawNonce` and `nonce = sha256(rawNonce)`.
  - Call `SignInWithApple.getAppleIDCredential(scopes: [...], nonce: nonce)`.
  - Use `credential.identityToken` as the token to send to backend.
  - Call `loginWithSocialToken(provider: 'apple', token: identityToken)`.
- `loginWithSocialToken`:
  - Call backend endpoint (legacy: `GET social-auth/$provider/callback` with query params).
  - Extract returned API token (usually `token`).
  - `await _store.saveToken(token)`.
  - Return `AuthSession(token: token, user: <optional>)`.
  - Preferred: after saving token, call `GET profile` (same as `restoreSession`) to populate user in the returned session. This ensures UI has user immediately and keeps one canonical user shape.

### 2) Extend `Auth` provider with social actions

In `features/auth/providers/auth_provider.dart`, add:

- `Future<void> loginWithGoogle()`
- `Future<void> loginWithApple()`

Pattern matches the existing email `login()`:

- `state = const AsyncLoading();`
- `state = await AsyncValue.guard(() => ref.read(authRepositoryProvider).loginWithGoogle());`

### 3) Update `LoginScreen` UI to add buttons

In `features/auth/login_screen.dart`:

- Add two buttons under the existing email/password button:
  - “Continue with Google”
  - “Continue with Apple” (only show if `Platform.isIOS || Platform.isMacOS`)
- Disable all auth actions while `authAsync.isLoading`.
- Keep error handling in `ref.listen(authProvider, ...)` as-is (SnackBar).

UI detail:
- Keep the screen dumb: it calls `ref.read(authProvider.notifier).loginWithGoogle()` and `loginWithApple()`.

### 4) Keep unauthorized behavior unchanged

Nothing new needed: once social login stores the same bearer token in `AuthTokenStore`, the existing `DioFactory` + `onUnauthorized` + `authSessionRevisionProvider` behavior remains correct.

## Token type decision (important)

Your backend must clearly specify what it expects for Google:

- **Access token** (OAuth2 token for Google APIs) or
- **ID token** (JWT with Google identity)

Legacy code used **Google access token** from scope authorization. Many backends prefer **ID token**. Decide once, then implement accordingly in `AuthRepository.loginWithGoogle()`.

## Testing plan (fast + hermetic)

Add unit tests in `test/features/auth/` using the existing `http_mock_adapter` approach:

- `loginWithSocialToken`:
  - Mocks the backend callback endpoint returning `{ "token": "abc" }`
  - Verifies `AuthTokenStore.saveToken("abc")` was called (use a memory store or fake)
  - Optionally mocks `GET profile` to ensure user is loaded

Do **not** unit test the platform plugins (Google/Apple); test only the repository method that consumes the token and talks to your API. For plugin flows, rely on manual QA on devices.

## Manual QA checklist

- **Google (Android)**:
  - Fresh install → Google sign-in returns valid session and loads profile
  - Logout clears token and returns to login
  - 401 from any API call clears token and returns to login
- **Apple (iOS)**:
  - First-time Apple sign-in returns session (email/name may be present only the first time; don’t assume it always exists)
  - Subsequent sign-ins still work even if email/fullName are null

## Deliverables (what will change in repo)

- **New/updated code**:
  - `lib/features/auth/repository/auth_repository.dart` (add social methods)
  - `lib/features/auth/providers/auth_provider.dart` (add actions)
  - `lib/features/auth/login_screen.dart` (add social buttons)
- **Dependencies**:
  - Update `pubspec.yaml` to include social auth packages
- **(Optional) docs**:
  - Add a short `docs/social-auth.md` later with screenshots + platform config details


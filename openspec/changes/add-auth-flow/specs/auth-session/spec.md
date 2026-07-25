## ADDED Requirements

### Requirement: Tokens are stored in platform secure storage
The app SHALL persist the access token, refresh token, and their expiry metadata in Keychain on iOS and EncryptedSharedPreferences or the Android KeyStore on Android. Tokens SHALL NOT be written to `UserDefaults`, plain `SharedPreferences`, application logs, or any unencrypted file.

#### Scenario: Tokens persisted after authentication
- **WHEN** signup, login, or social-login returns a token pair
- **THEN** both tokens SHALL be written to platform secure storage

#### Scenario: Tokens are never logged
- **WHEN** the app logs a request or a failure
- **THEN** access and refresh token values SHALL be omitted or redacted

### Requirement: Authenticated requests carry a bearer token
The HTTP client SHALL attach `Authorization: Bearer <access_token>` to every authenticated request. Requests to `signup`, `login`, `social-login`, `forgot-password`, `verify-otp`, `reset-password`, and `refresh-token` SHALL NOT carry the header.

#### Scenario: Protected endpoint call
- **WHEN** the app calls an endpoint that requires authentication and a session exists
- **THEN** the request SHALL include the bearer access token

### Requirement: Silent refresh on expired access token
When an authenticated request fails with 401 and code `ERR_TOKEN_EXPIRED`, the client SHALL pause further authenticated requests, call `POST /api/v1/auth/refresh-token` with `refresh_token` and `device_id`, store the new access token, and retry the original request transparently.

#### Scenario: Access token expired mid-session
- **WHEN** a request returns 401 `ERR_TOKEN_EXPIRED` and the refresh token is still valid
- **THEN** the client SHALL obtain a new access token and retry the original request without user interaction

#### Scenario: Concurrent requests hit 401 together
- **WHEN** several authenticated requests fail with 401 at the same time
- **THEN** the client SHALL issue exactly one refresh call and retry all pending requests once it completes

#### Scenario: Refresh call is not intercepted
- **WHEN** the refresh request itself returns 401
- **THEN** the client SHALL NOT attempt to refresh again for that response

### Requirement: Force logout when the session is unrecoverable
When refresh fails because the refresh token is invalid, expired, or revoked, the app SHALL delete all tokens from secure storage, drop any in-memory user state, and route the user to the Welcome screen with a session-expired notice.

#### Scenario: Refresh token rejected
- **WHEN** `refresh-token` responds with an error
- **THEN** the app SHALL clear stored credentials and navigate to Welcome showing "Phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại."

### Requirement: Session state drives app entry routing
On startup the app SHALL resolve session state to `authenticated` or `unauthenticated` before rendering a destination, showing `AppLoading` while resolving, then routing to Home or Welcome accordingly.

#### Scenario: Returning user with a valid session
- **WHEN** the app starts and secure storage holds a usable refresh token
- **THEN** the app SHALL route directly to Home without showing the Login screen

#### Scenario: Startup with no stored session
- **WHEN** the app starts and secure storage holds no tokens
- **THEN** the app SHALL route to the Welcome screen

### Requirement: Authenticated routes are guarded
Routes that require a session SHALL redirect to Welcome whenever session state is `unauthenticated`, and the auth routes SHALL redirect to Home whenever session state is `authenticated`.

#### Scenario: Unauthenticated access to a protected route
- **WHEN** an unauthenticated user navigates to a protected route
- **THEN** the router SHALL redirect to the Welcome screen

#### Scenario: Authenticated user opens a login route
- **WHEN** an authenticated user navigates to the Login route
- **THEN** the router SHALL redirect to Home

### Requirement: Explicit logout clears the session
The app SHALL provide a logout action that calls `POST /api/v1/auth/logout` with the current refresh token, clears secure storage regardless of the server response, and routes to Welcome.

#### Scenario: Logout while offline
- **WHEN** the logout request fails due to a network error
- **THEN** the app SHALL still clear local tokens and route to the Welcome screen

### Requirement: Auth transport requirements
All auth API calls SHALL use HTTPS with TLS 1.2 or higher, and every request that accepts device information SHALL include a `device_id` that is stable for the installation.

#### Scenario: Request includes device identity
- **WHEN** the app calls any auth endpoint that accepts device information
- **THEN** the request SHALL carry the installation's stable `device_id`

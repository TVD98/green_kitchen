# green_kitchen

Flutter client for Green Kitchen (auth + pantry discovery).

## Backend API

Sibling NestJS API: [`green_kitchen_api`](https://github.com/TVD98/green_kitchen_api).

By default the app talks to the **local API** (real auth, no fake backend):

| Platform | Base URL |
|----------|----------|
| iOS simulator / desktop / web | `http://localhost:3000/api/v1` |
| Android emulator | `http://10.0.2.2:3000/api/v1` |

```bash
# Start API (from green_kitchen_api)
docker compose up --build -d

# Run the app — no dart-define needed for local API
flutter run
```

Optional overrides:

```bash
# Fake auth (offline UI)
flutter run --dart-define=USE_FAKE_AUTH=true

# Custom API host (e.g. physical device → Mac LAN IP)
flutter run --dart-define=API_BASE_URL=http://192.168.x.x:3000/api/v1
```

DI switch: `lib/core/di/injection.dart` (`USE_FAKE_AUTH`).  
Base URL: `lib/core/network/dio_client.dart` (`API_BASE_URL` / `defaultApiBaseUrl()`).

Password-reset OTP is logged in the API console (and may appear as `dev_otp` outside production). Social login is stubbed on the server.

## Getting Started

```bash
flutter pub get
flutter run
```

Resources: [Flutter docs](https://docs.flutter.dev/).

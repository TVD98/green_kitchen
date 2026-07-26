# green_kitchen

Flutter client for Green Kitchen (auth + pantry discovery).

## Backend API

Sibling NestJS API: [`green_kitchen_api`](https://github.com/TVD98/green_kitchen_api).

By default the app uses a fake auth backend (`USE_FAKE_AUTH=true`) so UI works offline. Point at the real API:

```bash
# Start API (from green_kitchen_api)
docker compose up --build -d

# Android emulator
flutter run \
  --dart-define=API_BASE_URL=http://10.0.2.2:3000/api/v1 \
  --dart-define=USE_FAKE_AUTH=false

# iOS simulator / desktop
flutter run \
  --dart-define=API_BASE_URL=http://localhost:3000/api/v1 \
  --dart-define=USE_FAKE_AUTH=false
```

DI switch lives in `lib/core/di/injection.dart` (`USE_FAKE_AUTH`). Base URL: `lib/core/network/dio_client.dart` (`API_BASE_URL`).

Password-reset OTP is logged in the API console (and may appear as `dev_otp` outside production). Social login is stubbed on the server.

## Getting Started

```bash
flutter pub get
flutter run
```

Resources: [Flutter docs](https://docs.flutter.dev/).

# Environment Configuration

This app supports two environments: **Development** and **Production**.

## Environment Setup

### Development (Default)
- **Base URL**: `http://localhost:8000`
- **Full API URL**: `http://localhost:8000/api`

This is the default environment. The app will use localhost when running in debug mode.

### Production
- **Base URL**: `https://family-dish.emergent.host`
- **Full API URL**: `https://family-dish.emergent.host/api`

## How to Switch Environments

### Using Dart Defines (Recommended)

#### For Development (Default - no flag needed):
```bash
flutter run
# or
flutter build apk
flutter build ios
```

#### For Production:
```bash
flutter run --dart-define=PROD=true
# or
flutter build apk --dart-define=PROD=true
flutter build ios --dart-define=PROD=true
```

### Configuration File

The environment is controlled in `lib/config/app_config.dart`:

```dart
static const bool _isProduction = bool.fromEnvironment('PROD', defaultValue: false);
```

- By default, `_isProduction` is `false` (Development mode)
- Set `PROD=true` via `--dart-define` to enable Production mode

## Example Build Commands

### Development Build
```bash
flutter run
flutter build apk --debug
flutter build ios --debug
```

### Production Build
```bash
flutter run --dart-define=PROD=true
flutter build apk --release --dart-define=PROD=true
flutter build ios --release --dart-define=PROD=true
```

## Verify Current Environment

You can check which environment is active by checking the API calls in the app logs. The base URL will be logged when API requests are made (in debug mode).

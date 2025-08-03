# Technology Stack

## Framework & Language
- **Flutter SDK**: ^3.5.4
- **Dart**: Latest stable version
- **Material Design 3**: UI framework

## Backend Integration
- **Appwrite**: ^14.0.0 - Backend-as-a-Service platform
- **Authentication**: Appwrite Account service
- **Database**: Appwrite Databases service

## Key Dependencies
- `intl`: ^0.20.2 - Internationalization support
- `url_launcher`: ^6.3.1 - URL launching capabilities
- `window_manager`: ^0.4.3 - Desktop window management
- `cupertino_icons`: ^1.0.8 - iOS-style icons

## Development Tools
- `flutter_lints`: ^5.0.0 - Dart/Flutter linting rules
- `flutter_native_splash`: ^2.4.4 - Native splash screen generation
- `flutter_launcher_icons`: ^0.14.3 - App icon generation

## Environment Configuration
- Uses `.env` file for environment variables
- Environment variables passed via `--dart-define` flags
- Required variables: `APPWRITE_PROJECT_ID`, `APPWRITE_PROJECT_NAME`, `APPWRITE_PUBLIC_ENDPOINT`

## Common Commands

### Development
```bash
# Install dependencies
flutter pub get

# Run app (development)
flutter run

# Run with environment variables
flutter run --dart-define=APPWRITE_PROJECT_ID="your_id"
```

### Building
```bash
# Build for web (using build script)
./build.sh

# Build for web with preview server
./build.sh --preview

# Build for specific platforms
flutter build apk          # Android APK
flutter build ios          # iOS
flutter build linux        # Linux desktop
flutter build macos        # macOS desktop
flutter build windows      # Windows desktop
```

### Testing & Analysis
```bash
# Run static analysis
flutter analyze

# Format code
flutter format .

# Clean build artifacts
flutter clean
```

## Architecture Patterns
- **Singleton Pattern**: Used for AppwriteRepository
- **Repository Pattern**: Data layer abstraction with AppwriteRepository
- **Model-View Pattern**: Separation of data models and UI components
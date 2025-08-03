# Project Structure

## Root Directory
```
├── lib/                    # Main Dart source code
├── android/               # Android platform-specific code
├── ios/                   # iOS platform-specific code
├── web/                   # Web platform-specific code
├── linux/                 # Linux desktop platform-specific code
├── macos/                 # macOS desktop platform-specific code
├── windows/               # Windows desktop platform-specific code
├── assets/                # Static assets (images, icons)
├── .env.example           # Environment variables template
├── pubspec.yaml           # Flutter project configuration
├── build.sh               # Build script for web deployment
└── README.md              # Project documentation
```

## Source Code Organization (`lib/`)

### Core Application Files
- `main.dart` - Application entry point with initialization
- `app.dart` - Root widget with MaterialApp configuration
- `home.dart` - Main home screen widget

### Data Layer (`lib/data/`)
```
data/
├── models/                # Data models and DTOs
└── repository/            # Data access layer
    └── appwrite_repository.dart  # Appwrite service integration
```

### UI Layer (`lib/ui/`)
```
ui/
├── components/            # Reusable UI components
└── icons/                 # Custom icon definitions
```

### Utilities (`lib/utils/`)
```
utils/
├── extensions/            # Dart extension methods
└── app_initializer.dart   # Application initialization logic
```

## Configuration Files

### Environment Configuration
- `.env.example` - Template for environment variables
- `.env` - Local environment variables (not committed)

### Flutter Configuration
- `pubspec.yaml` - Dependencies and project metadata
- `flutter_launcher_icons.yaml` - App icon configuration
- `flutter_native_splash.yaml` - Splash screen configuration
- `analysis_options.yaml` - Dart analyzer configuration

## Platform-Specific Directories
Each platform directory contains:
- Build configurations
- Platform-specific assets
- Native code integrations
- Deployment configurations

## Asset Management
- `assets/` - Contains app icons, branding images, and splash screens
- Assets are referenced in `pubspec.yaml` under the `flutter` section

## Naming Conventions
- **Files**: snake_case (e.g., `app_initializer.dart`)
- **Classes**: PascalCase (e.g., `AppwriteRepository`)
- **Variables/Methods**: camelCase (e.g., `getCurrentDate()`)
- **Constants**: SCREAMING_SNAKE_CASE (e.g., `APPWRITE_PROJECT_ID`)

## Code Organization Principles
- **Separation of Concerns**: Data, UI, and utility code are separated
- **Single Responsibility**: Each file/class has a focused purpose
- **Repository Pattern**: Data access is abstracted through repositories
- **Singleton Pattern**: Shared services use singleton instances
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:window_manager/window_manager.dart';
import 'package:taskpay/data/services/service_locator.dart';
import 'package:taskpay/data/repository/appwrite_repository.dart';

/// A utility class for initializing the Flutter application.
///
/// This class ensures Flutter bindings are initialized, configures
/// window dimensions for desktop applications, and sets the device
/// orientation for mobile platforms.
class AppInitializer {
  /// Initializes the application setup.
  ///
  /// Ensures Flutter bindings are initialized, sets up window dimensions,
  /// and configures device orientation settings.
  static initialize() async {
    _ensureInitialized();
    await _setupWindowDimensions();
    await _setupDeviceOrientation();
    await _initializeServices();
  }

  /// Initialize application services
  static _initializeServices() async {
    await ServiceLocator().initialize();
    await _initializeAppwrite();
  }

  /// Initialize Appwrite connection
  static _initializeAppwrite() async {
    try {
      final repository = AppwriteRepository();
      final pingResult = await repository.ping();
      if (kDebugMode) {
        debugPrint('Appwrite connection initialized: ${pingResult.status == 200 ? 'Success' : 'Failed'}');
        if (pingResult.status != 200) {
          debugPrint('Ping response: ${pingResult.response}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Failed to initialize Appwrite: $e');
      }
    }
  }

  /// Ensures that Flutter bindings are initialized.
  static _ensureInitialized() {
    WidgetsFlutterBinding.ensureInitialized();
  }

  /// Configures the window dimensions for desktop applications.
  ///
  /// Ensures the window manager is initialized and sets a minimum window size.
  static _setupWindowDimensions() async {
    // Flutter maintains web on its own.
    if (kIsWeb || Platform.isAndroid || Platform.isIOS) return;

    await windowManager.ensureInitialized();
    windowManager.setMinimumSize(const Size(425, 600));
  }

  /// Configures the device orientation and system UI overlays.
  ///
  /// Locks the device orientation to portrait mode and ensures system
  /// UI overlays are manually configured.
  static _setupDeviceOrientation() async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    await SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [SystemUiOverlay.bottom, SystemUiOverlay.top],
    );
  }
}

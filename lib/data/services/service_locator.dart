import 'package:taskpay/data/services/authentication_service.dart';
import 'package:taskpay/data/services/appwrite_authentication_service.dart';
import 'package:taskpay/data/services/auth_manager.dart';
import 'package:taskpay/data/repositories/user_repository.dart';
import 'package:taskpay/data/repositories/appwrite_user_repository.dart';

/// Service locator for dependency injection
class ServiceLocator {
  static final ServiceLocator _instance = ServiceLocator._internal();
  factory ServiceLocator() => _instance;
  ServiceLocator._internal();

  // Services
  AuthenticationService? _authenticationService;
  UserRepository? _userRepository;
  AuthManager? _authManager;

  /// Get authentication service instance
  AuthenticationService get authenticationService {
    _authenticationService ??= AppwriteAuthenticationService();
    return _authenticationService!;
  }

  /// Get user repository instance
  UserRepository get userRepository {
    _userRepository ??= AppwriteUserRepository();
    return _userRepository!;
  }

  /// Get auth manager instance
  AuthManager get authManager {
    _authManager ??= AuthManager();
    return _authManager!;
  }

  /// Reset all services (useful for testing)
  void reset() {
    _authManager?.dispose();
    _authenticationService = null;
    _userRepository = null;
    _authManager = null;
  }

  /// Initialize all services
  Future<void> initialize() async {
    // Initialize services if needed
    // This can be expanded for services that need initialization
  }
}
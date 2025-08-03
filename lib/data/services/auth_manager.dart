import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:taskpay/data/models/user.dart';
import 'package:taskpay/data/models/user_role.dart';
import 'package:taskpay/data/services/authentication_service.dart';
import 'package:taskpay/data/services/service_locator.dart';
import 'package:taskpay/data/repositories/user_repository.dart';

/// Authentication manager that provides a higher-level interface
/// for authentication operations and state management
class AuthManager extends ChangeNotifier {
  final AuthenticationService _authService;
  final UserRepository _userRepository;
  
  User? _currentUser;
  bool _isLoading = false;
  String? _error;
  StreamSubscription<User?>? _authSubscription;

  AuthManager({
    AuthenticationService? authService,
    UserRepository? userRepository,
  }) : _authService = authService ?? ServiceLocator().authenticationService,
       _userRepository = userRepository ?? ServiceLocator().userRepository {
    _initializeAuthState();
  }

  // Getters
  User? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get currentUserId => _currentUser?.id;

  /// Initialize authentication state and listen to changes
  void _initializeAuthState() {
    _authSubscription = _authService.authStateChanges.listen(
      (user) {
        _currentUser = user;
        _error = null;
        notifyListeners();
      },
      onError: (error) {
        _error = error.toString();
        notifyListeners();
      },
    );
  }

  /// Sign up a new user
  Future<bool> signUp({
    required String email,
    required String password,
    required UserRole role,
  }) async {
    try {
      _setLoading(true);
      _clearError();

      final user = await _authService.signUp(email, password, role);
      _currentUser = user;
      
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Sign in an existing user
  Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    try {
      _setLoading(true);
      _clearError();

      final user = await _authService.signIn(email, password);
      _currentUser = user;
      
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Sign out the current user
  Future<bool> signOut() async {
    try {
      _setLoading(true);
      _clearError();

      await _authService.signOut();
      _currentUser = null;
      
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Reset password for the given email
  Future<bool> resetPassword(String email) async {
    try {
      _setLoading(true);
      _clearError();

      await _authService.resetPassword(email);
      
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Switch user's primary role
  Future<bool> switchRole(UserRole newRole) async {
    if (_currentUser == null) {
      _setError('No user is currently signed in');
      return false;
    }

    if (!_currentUser!.canSwitchToRole(newRole)) {
      _setError('User does not have access to this role');
      return false;
    }

    try {
      _setLoading(true);
      _clearError();

      await _userRepository.switchPrimaryRole(_currentUser!.id, newRole);
      
      // Update local user object
      _currentUser = _currentUser!.copyWith(primaryRole: newRole);
      notifyListeners();
      
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Check if user can switch to a specific role
  bool canSwitchToRole(UserRole role) {
    return _currentUser?.canSwitchToRole(role) ?? false;
  }

  /// Clear any existing error
  void clearError() {
    _clearError();
  }

  // Private helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }
}
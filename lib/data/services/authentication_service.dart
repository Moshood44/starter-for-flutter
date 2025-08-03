import 'package:taskpay/data/models/user.dart';
import 'package:taskpay/data/models/user_role.dart';

/// Abstract interface for authentication services
abstract class AuthenticationService {
  /// Signs up a new user with email, password, and role
  Future<User> signUp(String email, String password, UserRole role);

  /// Signs in an existing user with email and password
  Future<User> signIn(String email, String password);

  /// Signs out the current user
  Future<void> signOut();

  /// Gets the currently authenticated user
  Future<User?> getCurrentUser();

  /// Resets password for the given email
  Future<void> resetPassword(String email);

  /// Stream of authentication state changes
  Stream<User?> get authStateChanges;

  /// Checks if a user is currently authenticated
  bool get isAuthenticated;

  /// Gets the current user ID if authenticated
  String? get currentUserId;
}
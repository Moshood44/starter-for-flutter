// ignore_for_file: unused_field, unused_local_variable

import 'dart:async';
import 'package:appwrite/appwrite.dart';
import 'package:taskpay/data/models/user.dart';
import 'package:taskpay/data/models/user_role.dart';
import 'package:taskpay/data/repository/appwrite_repository.dart';
import 'package:taskpay/data/services/authentication_service.dart';

/// Appwrite implementation of AuthenticationService
class AppwriteAuthenticationService implements AuthenticationService {
  static const String _usersCollectionId = 'users';
  static const String _databaseId = 'taskpay_db';

  final AppwriteRepository _repository;
  final Account _account;
  final Databases _databases;
  
  User? _currentUser;
  final StreamController<User?> _authStateController = StreamController<User?>.broadcast();

  AppwriteAuthenticationService._internal(this._repository)
      : _account = _repository.account,
        _databases = _repository.databases {
    _initializeAuthState();
  }

  static AppwriteAuthenticationService? _instance;

  /// Factory constructor that returns singleton instance
  factory AppwriteAuthenticationService() {
    _instance ??= AppwriteAuthenticationService._internal(AppwriteRepository());
    return _instance!;
  }

  /// Initialize authentication state on app start
  Future<void> _initializeAuthState() async {
    try {
      final user = await getCurrentUser();
      _currentUser = user;
      _authStateController.add(user);
    } catch (e) {
      _currentUser = null;
      _authStateController.add(null);
    }
  }

  @override
  Future<User> signUp(String email, String password, UserRole role) async {
    try {
      // Create account with Appwrite
      final account = await _account.create(
        userId: ID.unique(),
        email: email,
        password: password,
      );

      // Create user document in database with role information
      final userDoc = await _databases.createDocument(
        databaseId: _databaseId,
        collectionId: _usersCollectionId,
        documentId: account.$id,
        data: {
          'email': email,
          'primaryRole': role.name,
          'availableRoles': [role.name],
          'createdAt': DateTime.now().toIso8601String(),
          'isVerified': false,
        },
      );

      // Create User object
      final user = User(
        id: account.$id,
        email: email,
        primaryRole: role,
        availableRoles: [role],
        createdAt: DateTime.now(),
        isVerified: false,
      );

      _currentUser = user;
      _authStateController.add(user);

      return user;
    } on AppwriteException catch (e) {
      throw _handleAppwriteException(e);
    }
  }

  @override
  Future<User> signIn(String email, String password) async {
    try {
      // Sign in with Appwrite
      await _account.createEmailPasswordSession(
        email: email,
        password: password,
      );

      // Get current user after successful sign in
      final user = await getCurrentUser();
      if (user == null) {
        throw AuthenticationException('Failed to retrieve user after sign in');
      }

      _currentUser = user;
      _authStateController.add(user);

      return user;
    } on AppwriteException catch (e) {
      throw _handleAppwriteException(e);
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _account.deleteSession(sessionId: 'current');
      _currentUser = null;
      _authStateController.add(null);
    } on AppwriteException catch (e) {
      throw _handleAppwriteException(e);
    }
  }

  @override
  Future<User?> getCurrentUser() async {
    try {
      // Get current account
      final account = await _account.get();
      
      // Get user document from database
      final userDoc = await _databases.getDocument(
        databaseId: _databaseId,
        collectionId: _usersCollectionId,
        documentId: account.$id,
      );

      // Convert to User object
      final user = User(
        id: account.$id,
        email: account.email,
        primaryRole: UserRole.fromString(userDoc.data['primaryRole']),
        availableRoles: (userDoc.data['availableRoles'] as List<dynamic>)
            .map((role) => UserRole.fromString(role as String))
            .toList(),
        createdAt: DateTime.parse(userDoc.data['createdAt']),
        isVerified: userDoc.data['isVerified'] ?? false,
      );

      return user;
    } on AppwriteException catch (e) {
      if (e.code == 401) {
        // User not authenticated
        return null;
      }
      throw _handleAppwriteException(e);
    }
  }

  @override
  Future<void> resetPassword(String email) async {
    try {
      await _account.createRecovery(
        email: email,
        url: 'https://taskpay.app/reset-password', // This should be configured based on your app
      );
    } on AppwriteException catch (e) {
      throw _handleAppwriteException(e);
    }
  }

  @override
  Stream<User?> get authStateChanges => _authStateController.stream;

  @override
  bool get isAuthenticated => _currentUser != null;

  @override
  String? get currentUserId => _currentUser?.id;

  /// Handle Appwrite exceptions and convert to custom exceptions
  Exception _handleAppwriteException(AppwriteException e) {
    switch (e.code) {
      case 400:
        return AuthenticationException('Invalid request. Please check your input.');
      case 401:
        return AuthenticationException('Invalid credentials. Please try again.');
      case 409:
        return AuthenticationException('User already exists with this email.');
      case 429:
        return AuthenticationException('Too many requests. Please try again later.');
      default:
        return AuthenticationException(e.message ?? 'Authentication failed');
    }
  }

  /// Dispose resources
  void dispose() {
    _authStateController.close();
  }
}

/// Custom exception for authentication errors
class AuthenticationException implements Exception {
  final String message;
  final String code;

  AuthenticationException(this.message, [this.code = 'AUTH_ERROR']);

  @override
  String toString() => 'AuthenticationException: $message';
}
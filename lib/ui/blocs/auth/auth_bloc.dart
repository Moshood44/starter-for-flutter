import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskpay/data/services/auth_manager.dart';
import 'package:taskpay/data/services/service_locator.dart';
import 'package:taskpay/ui/blocs/auth/auth_event.dart';
import 'package:taskpay/ui/blocs/auth/auth_state.dart';

/// BLoC for managing authentication state and operations
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthManager _authManager;

  AuthBloc({AuthManager? authManager})
      : _authManager = authManager ?? ServiceLocator().authManager,
        super(const AuthInitial()) {
    
    // Register event handlers
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<AuthSignInRequested>(_onAuthSignInRequested);
    on<AuthSignUpRequested>(_onAuthSignUpRequested);
    on<AuthPasswordResetRequested>(_onAuthPasswordResetRequested);
    on<AuthSignOutRequested>(_onAuthSignOutRequested);
    on<AuthRoleSwitchRequested>(_onAuthRoleSwitchRequested);
    on<AuthErrorCleared>(_onAuthErrorCleared);

    // Listen to auth manager changes - AuthManager extends ChangeNotifier
    _authManager.addListener(_onAuthManagerChanged);
  }

  /// Handle authentication status check
  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    
    if (_authManager.isAuthenticated && _authManager.currentUser != null) {
      emit(AuthAuthenticated(user: _authManager.currentUser!));
    } else {
      emit(const AuthUnauthenticated());
    }
  }

  /// Handle sign in request
  Future<void> _onAuthSignInRequested(
    AuthSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final success = await _authManager.signIn(
      email: event.email,
      password: event.password,
    );

    if (success && _authManager.currentUser != null) {
      emit(AuthAuthenticated(user: _authManager.currentUser!));
    } else {
      emit(AuthError(message: _authManager.error ?? 'Sign in failed'));
    }
  }

  /// Handle sign up request
  Future<void> _onAuthSignUpRequested(
    AuthSignUpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final success = await _authManager.signUp(
      email: event.email,
      password: event.password,
      role: event.role,
    );

    if (success && _authManager.currentUser != null) {
      emit(AuthAuthenticated(user: _authManager.currentUser!));
    } else {
      emit(AuthError(message: _authManager.error ?? 'Sign up failed'));
    }
  }

  /// Handle password reset request
  Future<void> _onAuthPasswordResetRequested(
    AuthPasswordResetRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final success = await _authManager.resetPassword(event.email);

    if (success) {
      emit(AuthPasswordResetSent(email: event.email));
    } else {
      emit(AuthError(message: _authManager.error ?? 'Password reset failed'));
    }
  }

  /// Handle sign out request
  Future<void> _onAuthSignOutRequested(
    AuthSignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final success = await _authManager.signOut();

    if (success) {
      emit(const AuthUnauthenticated());
    } else {
      emit(AuthError(message: _authManager.error ?? 'Sign out failed'));
    }
  }

  /// Handle role switch request
  Future<void> _onAuthRoleSwitchRequested(
    AuthRoleSwitchRequested event,
    Emitter<AuthState> emit,
  ) async {
    if (state is! AuthAuthenticated) {
      emit(const AuthError(message: 'User must be authenticated to switch roles'));
      return;
    }

    emit(const AuthLoading());

    final success = await _authManager.switchRole(event.newRole);

    if (success && _authManager.currentUser != null) {
      emit(AuthAuthenticated(user: _authManager.currentUser!));
    } else {
      emit(AuthError(message: _authManager.error ?? 'Role switch failed'));
    }
  }

  /// Handle error clearing
  void _onAuthErrorCleared(
    AuthErrorCleared event,
    Emitter<AuthState> emit,
  ) {
    _authManager.clearError();
    
    if (_authManager.isAuthenticated && _authManager.currentUser != null) {
      emit(AuthAuthenticated(user: _authManager.currentUser!));
    } else {
      emit(const AuthUnauthenticated());
    }
  }

  /// Handle auth manager state changes
  void _onAuthManagerChanged() {
    if (_authManager.isAuthenticated && _authManager.currentUser != null) {
      if (state is! AuthAuthenticated) {
        add(const AuthCheckRequested());
      }
    } else if (state is AuthAuthenticated) {
      add(const AuthCheckRequested());
    }
  }

  @override
  Future<void> close() {
    _authManager.removeListener(_onAuthManagerChanged);
    return super.close();
  }
}
import 'package:equatable/equatable.dart';
import 'package:taskpay/data/models/user_role.dart';

/// Base class for all authentication events
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/// Event triggered when app starts to check authentication status
class AuthCheckRequested extends AuthEvent {
  const AuthCheckRequested();
}

/// Event triggered when user attempts to sign in
class AuthSignInRequested extends AuthEvent {
  final String email;
  final String password;

  const AuthSignInRequested({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}

/// Event triggered when user attempts to sign up
class AuthSignUpRequested extends AuthEvent {
  final String email;
  final String password;
  final UserRole role;

  const AuthSignUpRequested({
    required this.email,
    required this.password,
    required this.role,
  });

  @override
  List<Object?> get props => [email, password, role];
}

/// Event triggered when user requests password reset
class AuthPasswordResetRequested extends AuthEvent {
  final String email;

  const AuthPasswordResetRequested({required this.email});

  @override
  List<Object?> get props => [email];
}

/// Event triggered when user signs out
class AuthSignOutRequested extends AuthEvent {
  const AuthSignOutRequested();
}

/// Event triggered when user switches role
class AuthRoleSwitchRequested extends AuthEvent {
  final UserRole newRole;

  const AuthRoleSwitchRequested({required this.newRole});

  @override
  List<Object?> get props => [newRole];
}

/// Event triggered to clear any authentication errors
class AuthErrorCleared extends AuthEvent {
  const AuthErrorCleared();
}
import 'user_role.dart';

class User {
  final String id;
  final String email;
  final UserRole primaryRole;
  final List<UserRole> availableRoles;
  final DateTime createdAt;
  final bool isVerified;

  const User({
    required this.id,
    required this.email,
    required this.primaryRole,
    required this.availableRoles,
    required this.createdAt,
    this.isVerified = false,
  });

  // JSON serialization
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'primaryRole': primaryRole.name,
      'availableRoles': availableRoles.map((role) => role.name).toList(),
      'createdAt': createdAt.toIso8601String(),
      'isVerified': isVerified,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      email: json['email'] as String,
      primaryRole: UserRole.fromString(json['primaryRole'] as String),
      availableRoles: (json['availableRoles'] as List<dynamic>)
          .map((role) => UserRole.fromString(role as String))
          .toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      isVerified: json['isVerified'] as bool? ?? false,
    );
  }

  // Validation
  bool get isValid {
    return id.isNotEmpty && 
           email.isNotEmpty && 
           _isValidEmail(email) &&
           availableRoles.contains(primaryRole);
  }

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  bool canSwitchToRole(UserRole role) {
    return availableRoles.contains(role);
  }

  User copyWith({
    String? id,
    String? email,
    UserRole? primaryRole,
    List<UserRole>? availableRoles,
    DateTime? createdAt,
    bool? isVerified,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      primaryRole: primaryRole ?? this.primaryRole,
      availableRoles: availableRoles ?? this.availableRoles,
      createdAt: createdAt ?? this.createdAt,
      isVerified: isVerified ?? this.isVerified,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User &&
        other.id == id &&
        other.email == email &&
        other.primaryRole == primaryRole &&
        other.availableRoles.length == availableRoles.length &&
        other.availableRoles.every((role) => availableRoles.contains(role)) &&
        other.createdAt == createdAt &&
        other.isVerified == isVerified;
  }

  @override
  int get hashCode {
    return Object.hash(id, email, primaryRole, availableRoles, createdAt, isVerified);
  }

  @override
  String toString() {
    return 'User(id: $id, email: $email, primaryRole: $primaryRole, isVerified: $isVerified)';
  }
}
enum UserRole {
  poster,
  tasker;

  String get displayName {
    switch (this) {
      case UserRole.poster:
        return 'Poster';
      case UserRole.tasker:
        return 'Tasker';
    }
  }

  static UserRole fromString(String role) {
    switch (role.toLowerCase()) {
      case 'poster':
        return UserRole.poster;
      case 'tasker':
        return UserRole.tasker;
      default:
        throw ArgumentError('Invalid user role: $role');
    }
  }
}
import 'package:taskpay/data/models/user_profile.dart';
import 'package:taskpay/data/models/user_role.dart';

/// Data class for user profile creation/update
class UserProfileData {
  final String displayName;
  final String? bio;
  final List<String> skills;
  final String? profileImageUrl;

  const UserProfileData({
    required this.displayName,
    this.bio,
    this.skills = const [],
    this.profileImageUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'displayName': displayName,
      'bio': bio,
      'skills': skills,
      'profileImageUrl': profileImageUrl,
    };
  }
}

/// Abstract interface for user profile management
abstract class UserRepository {
  /// Creates a new user profile
  Future<UserProfile> createProfile(String userId, UserProfileData data);

  /// Gets a user profile by user ID
  Future<UserProfile?> getProfile(String userId);

  /// Updates an existing user profile
  Future<UserProfile> updateProfile(String userId, UserProfileData data);

  /// Verifies a student by uploading student ID document
  Future<void> verifyStudent(String userId, String studentIdPath);

  /// Gets ratings for a specific user
  Future<List<Rating>> getUserRatings(String userId);

  /// Updates user's role preferences
  Future<void> updateUserRoles(String userId, List<UserRole> availableRoles);

  /// Switches user's primary role
  Future<void> switchPrimaryRole(String userId, UserRole newPrimaryRole);
}

/// Rating model for user reviews
class Rating {
  final String id;
  final String fromUserId;
  final String toUserId;
  final String taskId;
  final double rating;
  final String? comment;
  final DateTime createdAt;

  const Rating({
    required this.id,
    required this.fromUserId,
    required this.toUserId,
    required this.taskId,
    required this.rating,
    this.comment,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fromUserId': fromUserId,
      'toUserId': toUserId,
      'taskId': taskId,
      'rating': rating,
      'comment': comment,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      id: json['id'] as String,
      fromUserId: json['fromUserId'] as String,
      toUserId: json['toUserId'] as String,
      taskId: json['taskId'] as String,
      rating: (json['rating'] as num).toDouble(),
      comment: json['comment'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}
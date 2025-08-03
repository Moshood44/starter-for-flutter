import 'contact_info.dart';

class UserProfile {
  final String userId;
  final String displayName;
  final String? profileImageUrl;
  final String? bio;
  final List<String> skills;
  final double rating;
  final int completedTasks;
  final bool isStudentVerified;
  final ContactInfo contactInfo;
  final DateTime? lastUpdated;

  const UserProfile({
    required this.userId,
    required this.displayName,
    this.profileImageUrl,
    this.bio,
    this.skills = const [],
    this.rating = 0.0,
    this.completedTasks = 0,
    this.isStudentVerified = false,
    this.contactInfo = const ContactInfo(),
    this.lastUpdated,
  });

  // JSON serialization
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'displayName': displayName,
      'profileImageUrl': profileImageUrl,
      'bio': bio,
      'skills': skills,
      'rating': rating,
      'completedTasks': completedTasks,
      'isStudentVerified': isStudentVerified,
      'contactInfo': contactInfo.toJson(),
      'lastUpdated': lastUpdated?.toIso8601String(),
    };
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      userId: json['userId'] as String,
      displayName: json['displayName'] as String,
      profileImageUrl: json['profileImageUrl'] as String?,
      bio: json['bio'] as String?,
      skills: (json['skills'] as List<dynamic>?)
          ?.map((skill) => skill as String)
          .toList() ?? [],
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      completedTasks: json['completedTasks'] as int? ?? 0,
      isStudentVerified: json['isStudentVerified'] as bool? ?? false,
      contactInfo: json['contactInfo'] != null
          ? ContactInfo.fromJson(json['contactInfo'] as Map<String, dynamic>)
          : const ContactInfo(),
      lastUpdated: json['lastUpdated'] != null
          ? DateTime.parse(json['lastUpdated'] as String)
          : null,
    );
  }

  // Validation
  bool get isValid {
    return userId.isNotEmpty && 
           displayName.isNotEmpty &&
           rating >= 0.0 && 
           rating <= 5.0 &&
           completedTasks >= 0;
  }

  bool get isProfileComplete {
    return displayName.isNotEmpty &&
           bio != null &&
           bio!.isNotEmpty &&
           contactInfo.hasAnyContact;
  }

  String get ratingDisplay {
    return rating.toStringAsFixed(1);
  }

  UserProfile copyWith({
    String? userId,
    String? displayName,
    String? profileImageUrl,
    String? bio,
    List<String>? skills,
    double? rating,
    int? completedTasks,
    bool? isStudentVerified,
    ContactInfo? contactInfo,
    DateTime? lastUpdated,
  }) {
    return UserProfile(
      userId: userId ?? this.userId,
      displayName: displayName ?? this.displayName,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      bio: bio ?? this.bio,
      skills: skills ?? this.skills,
      rating: rating ?? this.rating,
      completedTasks: completedTasks ?? this.completedTasks,
      isStudentVerified: isStudentVerified ?? this.isStudentVerified,
      contactInfo: contactInfo ?? this.contactInfo,
      lastUpdated: lastUpdated ?? DateTime.now(),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserProfile &&
        other.userId == userId &&
        other.displayName == displayName &&
        other.profileImageUrl == profileImageUrl &&
        other.bio == bio &&
        other.skills.length == skills.length &&
        other.skills.every((skill) => skills.contains(skill)) &&
        other.rating == rating &&
        other.completedTasks == completedTasks &&
        other.isStudentVerified == isStudentVerified &&
        other.contactInfo == contactInfo;
  }

  @override
  int get hashCode {
    return Object.hash(
      userId,
      displayName,
      profileImageUrl,
      bio,
      skills,
      rating,
      completedTasks,
      isStudentVerified,
      contactInfo,
    );
  }

  @override
  String toString() {
    return 'UserProfile(userId: $userId, displayName: $displayName, rating: $rating, completedTasks: $completedTasks)';
  }
}
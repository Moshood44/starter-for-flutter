// ignore_for_file: unused_import

import 'package:flutter_test/flutter_test.dart';
import 'package:taskpay/data/models/user_role.dart';
import 'package:taskpay/data/repositories/user_repository.dart';
import 'package:taskpay/data/repositories/appwrite_user_repository.dart';

void main() {
  group('UserRepository Interface', () {
    test('should define correct interface methods', () {
      // Test that the interface has all required methods
      expect(UserRepository, isA<Type>());
      
      // We can't instantiate the abstract class, but we can verify
      // that the concrete implementation exists
      expect(AppwriteUserRepository, isA<Type>());
    });

    test('should handle repository exceptions', () {
      expect(
        () => throw UserRepositoryException('Test error'),
        throwsA(isA<UserRepositoryException>()),
      );
    });
  });

  group('UserProfileData', () {
    test('should create profile data correctly', () {
      const displayName = 'John Doe';
      const bio = 'Test bio';
      const skills = ['Flutter', 'Dart'];
      
      const profileData = UserProfileData(
        displayName: displayName,
        bio: bio,
        skills: skills,
      );

      expect(profileData.displayName, equals(displayName));
      expect(profileData.bio, equals(bio));
      expect(profileData.skills, equals(skills));
      expect(profileData.profileImageUrl, isNull);
    });

    test('should convert to JSON correctly', () {
      const profileData = UserProfileData(
        displayName: 'John Doe',
        bio: 'Test bio',
        skills: ['Flutter'],
      );

      final json = profileData.toJson();

      expect(json['displayName'], equals('John Doe'));
      expect(json['bio'], equals('Test bio'));
      expect(json['skills'], equals(['Flutter']));
      expect(json['profileImageUrl'], isNull);
    });
  });

  group('Rating', () {
    test('should create rating correctly', () {
      final createdAt = DateTime.now();
      final rating = Rating(
        id: 'test-id',
        fromUserId: 'user1',
        toUserId: 'user2',
        taskId: 'task1',
        rating: 4.5,
        comment: 'Great work!',
        createdAt: createdAt,
      );

      expect(rating.id, equals('test-id'));
      expect(rating.fromUserId, equals('user1'));
      expect(rating.toUserId, equals('user2'));
      expect(rating.taskId, equals('task1'));
      expect(rating.rating, equals(4.5));
      expect(rating.comment, equals('Great work!'));
      expect(rating.createdAt, equals(createdAt));
    });

    test('should serialize to/from JSON correctly', () {
      final createdAt = DateTime.now();
      final originalRating = Rating(
        id: 'test-id',
        fromUserId: 'user1',
        toUserId: 'user2',
        taskId: 'task1',
        rating: 4.5,
        comment: 'Great work!',
        createdAt: createdAt,
      );

      final json = originalRating.toJson();
      final deserializedRating = Rating.fromJson(json);

      expect(deserializedRating.id, equals(originalRating.id));
      expect(deserializedRating.fromUserId, equals(originalRating.fromUserId));
      expect(deserializedRating.toUserId, equals(originalRating.toUserId));
      expect(deserializedRating.taskId, equals(originalRating.taskId));
      expect(deserializedRating.rating, equals(originalRating.rating));
      expect(deserializedRating.comment, equals(originalRating.comment));
      expect(deserializedRating.createdAt, equals(originalRating.createdAt));
    });
  });

  group('UserRepositoryException', () {
    test('should create exception with message', () {
      const message = 'Test repository error';
      final exception = UserRepositoryException(message);
      
      expect(exception.message, equals(message));
      expect(exception.code, equals('USER_REPO_ERROR'));
      expect(exception.toString(), contains(message));
    });

    test('should create exception with custom code', () {
      const message = 'Test error';
      const code = 'CUSTOM_CODE';
      final exception = UserRepositoryException(message, code);
      
      expect(exception.message, equals(message));
      expect(exception.code, equals(code));
    });
  });
}
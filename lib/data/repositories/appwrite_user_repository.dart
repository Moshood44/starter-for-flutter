// ignore_for_file: unused_field

import 'package:appwrite/appwrite.dart';
import 'package:taskpay/data/models/user_profile.dart';
import 'package:taskpay/data/models/user_role.dart';
import 'package:taskpay/data/models/contact_info.dart';
import 'package:taskpay/data/repository/appwrite_repository.dart';
import 'package:taskpay/data/repositories/user_repository.dart';

/// Appwrite implementation of UserRepository
class AppwriteUserRepository implements UserRepository {
  static const String _profilesCollectionId = 'user_profiles';
  static const String _ratingsCollectionId = 'ratings';
  static const String _usersCollectionId = 'users';
  static const String _databaseId = 'taskpay_db';
  static const String _bucketId = 'profile_images';

  final AppwriteRepository _repository;
  final Databases _databases;
  final Storage _storage;

  AppwriteUserRepository._internal(this._repository)
      : _databases = _repository.databases,
        _storage = Storage(_repository.client);

  static AppwriteUserRepository? _instance;

  /// Factory constructor that returns singleton instance
  factory AppwriteUserRepository() {
    _instance ??= AppwriteUserRepository._internal(AppwriteRepository());
    return _instance!;
  }

  @override
  Future<UserProfile> createProfile(String userId, UserProfileData data) async {
    try {
      final profileDoc = await _databases.createDocument(
        databaseId: _databaseId,
        collectionId: _profilesCollectionId,
        documentId: userId,
        data: {
          'userId': userId,
          'displayName': data.displayName,
          'bio': data.bio,
          'skills': data.skills,
          'profileImageUrl': data.profileImageUrl,
          'rating': 0.0,
          'completedTasks': 0,
          'isStudentVerified': false,
          'contactInfo': const ContactInfo().toJson(),
          'lastUpdated': DateTime.now().toIso8601String(),
        },
      );

      return UserProfile.fromJson(profileDoc.data);
    } on AppwriteException catch (e) {
      throw _handleAppwriteException(e);
    }
  }

  @override
  Future<UserProfile?> getProfile(String userId) async {
    try {
      final profileDoc = await _databases.getDocument(
        databaseId: _databaseId,
        collectionId: _profilesCollectionId,
        documentId: userId,
      );

      return UserProfile.fromJson(profileDoc.data);
    } on AppwriteException catch (e) {
      if (e.code == 404) {
        return null; // Profile doesn't exist
      }
      throw _handleAppwriteException(e);
    }
  }

  @override
  Future<UserProfile> updateProfile(String userId, UserProfileData data) async {
    try {
      final updateData = <String, dynamic>{
        'displayName': data.displayName,
        'bio': data.bio,
        'skills': data.skills,
        'lastUpdated': DateTime.now().toIso8601String(),
      };

      if (data.profileImageUrl != null) {
        updateData['profileImageUrl'] = data.profileImageUrl;
      }

      final profileDoc = await _databases.updateDocument(
        databaseId: _databaseId,
        collectionId: _profilesCollectionId,
        documentId: userId,
        data: updateData,
      );

      return UserProfile.fromJson(profileDoc.data);
    } on AppwriteException catch (e) {
      throw _handleAppwriteException(e);
    }
  }

  @override
  Future<void> verifyStudent(String userId, String studentIdPath) async {
    try {
      // Upload student ID document
      final file = await _storage.createFile(
        bucketId: _bucketId,
        fileId: ID.unique(),
        file: InputFile.fromPath(path: studentIdPath),
      );

      // Update profile to mark as student verified
      await _databases.updateDocument(
        databaseId: _databaseId,
        collectionId: _profilesCollectionId,
        documentId: userId,
        data: {
          'isStudentVerified': true,
          'studentIdDocumentId': file.$id,
          'lastUpdated': DateTime.now().toIso8601String(),
        },
      );
    } on AppwriteException catch (e) {
      throw _handleAppwriteException(e);
    }
  }

  @override
  Future<List<Rating>> getUserRatings(String userId) async {
    try {
      final ratingsQuery = await _databases.listDocuments(
        databaseId: _databaseId,
        collectionId: _ratingsCollectionId,
        queries: [
          Query.equal('toUserId', userId),
          Query.orderDesc('createdAt'),
        ],
      );

      return ratingsQuery.documents
          .map((doc) => Rating.fromJson(doc.data))
          .toList();
    } on AppwriteException catch (e) {
      throw _handleAppwriteException(e);
    }
  }

  @override
  Future<void> updateUserRoles(String userId, List<UserRole> availableRoles) async {
    try {
      await _databases.updateDocument(
        databaseId: _databaseId,
        collectionId: _usersCollectionId,
        documentId: userId,
        data: {
          'availableRoles': availableRoles.map((role) => role.name).toList(),
        },
      );
    } on AppwriteException catch (e) {
      throw _handleAppwriteException(e);
    }
  }

  @override
  Future<void> switchPrimaryRole(String userId, UserRole newPrimaryRole) async {
    try {
      // First, get the current user to check if the role is available
      final userDoc = await _databases.getDocument(
        databaseId: _databaseId,
        collectionId: _usersCollectionId,
        documentId: userId,
      );

      final availableRoles = (userDoc.data['availableRoles'] as List<dynamic>)
          .map((role) => UserRole.fromString(role as String))
          .toList();

      if (!availableRoles.contains(newPrimaryRole)) {
        throw UserRepositoryException('User does not have access to this role');
      }

      // Update the primary role
      await _databases.updateDocument(
        databaseId: _databaseId,
        collectionId: _usersCollectionId,
        documentId: userId,
        data: {
          'primaryRole': newPrimaryRole.name,
        },
      );
    } on AppwriteException catch (e) {
      throw _handleAppwriteException(e);
    }
  }

  /// Upload profile image and return the URL
  Future<String> uploadProfileImage(String userId, String imagePath) async {
    try {
      final file = await _storage.createFile(
        bucketId: _bucketId,
        fileId: ID.unique(),
        file: InputFile.fromPath(path: imagePath),
      );

      // Get the file URL
      final fileUrl = _storage.getFileView(
        bucketId: _bucketId,
        fileId: file.$id,
      );

      return fileUrl.toString();
    } on AppwriteException catch (e) {
      throw _handleAppwriteException(e);
    }
  }

  /// Handle Appwrite exceptions and convert to custom exceptions
  Exception _handleAppwriteException(AppwriteException e) {
    switch (e.code) {
      case 400:
        return UserRepositoryException('Invalid request. Please check your input.');
      case 401:
        return UserRepositoryException('Unauthorized. Please sign in again.');
      case 404:
        return UserRepositoryException('User profile not found.');
      case 409:
        return UserRepositoryException('Profile already exists.');
      default:
        return UserRepositoryException(e.message ?? 'Profile operation failed');
    }
  }
}

/// Custom exception for user repository errors
class UserRepositoryException implements Exception {
  final String message;
  final String code;

  UserRepositoryException(this.message, [this.code = 'USER_REPO_ERROR']);

  @override
  String toString() => 'UserRepositoryException: $message';
}
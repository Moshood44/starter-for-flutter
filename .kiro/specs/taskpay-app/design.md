# TaskPay Design Document

## Overview

TaskPay is a Flutter-based mobile application that connects task posters with student taskers through a secure, real-time platform. The application follows a clean architecture pattern with clear separation between presentation, business logic, and data layers. The system leverages Appwrite for backend services and Paystack for payment processing, ensuring scalability and security.

## Architecture

### High-Level Architecture

The application follows a layered architecture pattern:

```
┌─────────────────────────────────────┐
│           Presentation Layer        │
│  (UI Widgets, Screens, Controllers) │
├─────────────────────────────────────┤
│           Business Logic Layer      │
│     (Services, Use Cases, BLoC)     │
├─────────────────────────────────────┤
│             Data Layer              │
│   (Repositories, Models, APIs)      │
├─────────────────────────────────────┤
│           External Services         │
│      (Appwrite, Paystack)           │
└─────────────────────────────────────┘
```

### Core Architectural Patterns

1. **Repository Pattern**: Abstracts data access logic and provides a clean API for business logic
2. **Singleton Pattern**: Used for shared services like AppwriteRepository and PaymentService
3. **BLoC Pattern**: Manages application state and business logic with reactive programming
4. **Provider Pattern**: Handles dependency injection and state management
5. **Factory Pattern**: Creates different types of users, tasks, and payment methods

## Components and Interfaces

### Authentication System

**AuthenticationService**
```dart
abstract class AuthenticationService {
  Future<User> signUp(String email, String password, UserRole role);
  Future<User> signIn(String email, String password);
  Future<void> signOut();
  Future<User?> getCurrentUser();
  Future<void> resetPassword(String email);
  Stream<User?> get authStateChanges;
}
```

**UserRepository**
```dart
abstract class UserRepository {
  Future<UserProfile> createProfile(String userId, UserProfileData data);
  Future<UserProfile> getProfile(String userId);
  Future<UserProfile> updateProfile(String userId, UserProfileData data);
  Future<void> verifyStudent(String userId, String studentIdPath);
  Future<List<Rating>> getUserRatings(String userId);
}
```

### Task Management System

**TaskRepository**
```dart
abstract class TaskRepository {
  Future<Task> createTask(TaskData taskData);
  Future<List<Task>> getAvailableTasks(TaskFilters filters);
  Future<Task> getTaskById(String taskId);
  Future<Task> updateTaskStatus(String taskId, TaskStatus status);
  Future<void> deleteTask(String taskId);
  Stream<List<Task>> watchTasksByUser(String userId);
}
```

**BiddingService**
```dart
abstract class BiddingService {
  Future<Bid> submitBid(String taskId, String taskerId, double amount, String message);
  Future<List<Bid>> getTaskBids(String taskId);
  Future<void> acceptBid(String bidId);
  Future<void> rejectBid(String bidId);
}
```

### Payment System

**PaymentService**
```dart
abstract class PaymentService {
  Future<PaymentResult> initializePayment(String taskId, double amount);
  Future<void> processEscrowPayment(String transactionId);
  Future<void> releaseEscrowFunds(String taskId);
  Future<WalletBalance> getWalletBalance(String userId);
  Future<void> requestWithdrawal(String userId, double amount, BankDetails bankDetails);
}
```

**PaystackIntegration**
```dart
class PaystackIntegration {
  Future<String> generateAccessCode(double amount, String email);
  Future<bool> verifyTransaction(String reference);
  Future<void> processWithdrawal(WithdrawalRequest request);
}
```

### Communication System

**ChatService**
```dart
abstract class ChatService {
  Future<ChatRoom> createChatRoom(String taskId, String posterId, String taskerId);
  Future<void> sendMessage(String chatRoomId, String senderId, String message);
  Stream<List<Message>> watchMessages(String chatRoomId);
  Future<void> markMessagesAsRead(String chatRoomId, String userId);
}
```

**NotificationService**
```dart
abstract class NotificationService {
  Future<void> sendTaskNotification(String userId, TaskNotificationData data);
  Future<void> sendPaymentNotification(String userId, PaymentNotificationData data);
  Future<void> sendChatNotification(String userId, ChatNotificationData data);
  Future<void> registerForPushNotifications(String userId, String fcmToken);
}
```

## Data Models

### User Models

```dart
class User {
  final String id;
  final String email;
  final UserRole primaryRole;
  final List<UserRole> availableRoles;
  final DateTime createdAt;
  final bool isVerified;
}

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
}

enum UserRole { poster, tasker }
```

### Task Models

```dart
class Task {
  final String id;
  final String posterId;
  final String title;
  final String description;
  final TaskCategory category;
  final Location location;
  final double budget;
  final DateTime deadline;
  final TaskStatus status;
  final List<String> attachmentUrls;
  final DateTime createdAt;
  final String? assignedTaskerId;
}

class Bid {
  final String id;
  final String taskId;
  final String taskerId;
  final double proposedAmount;
  final String message;
  final BidStatus status;
  final DateTime createdAt;
}

enum TaskStatus { pending, assigned, inProgress, completed, paid, disputed }
enum TaskCategory { academics, foodAndDrink, errands, delivery, other }
```

### Payment Models

```dart
class Payment {
  final String id;
  final String taskId;
  final String posterId;
  final String taskerId;
  final double amount;
  final PaymentStatus status;
  final String? transactionReference;
  final DateTime createdAt;
  final DateTime? completedAt;
}

class Wallet {
  final String userId;
  final double balance;
  final List<Transaction> transactions;
  final DateTime lastUpdated;
}

enum PaymentStatus { pending, processing, completed, failed, refunded }
```

## Error Handling

### Error Types

```dart
abstract class TaskPayException implements Exception {
  final String message;
  final String code;
  TaskPayException(this.message, this.code);
}

class AuthenticationException extends TaskPayException {
  AuthenticationException(String message) : super(message, 'AUTH_ERROR');
}

class PaymentException extends TaskPayException {
  PaymentException(String message) : super(message, 'PAYMENT_ERROR');
}

class NetworkException extends TaskPayException {
  NetworkException(String message) : super(message, 'NETWORK_ERROR');
}
```

### Error Handling Strategy

1. **Network Errors**: Implement retry logic with exponential backoff
2. **Authentication Errors**: Redirect to login screen and clear local session
3. **Payment Errors**: Show user-friendly messages and provide alternative payment methods
4. **Validation Errors**: Display inline validation messages with clear guidance
5. **Server Errors**: Log errors for debugging and show generic error messages to users

## Testing Strategy

### Unit Testing

- **Models**: Test data validation, serialization, and business logic
- **Services**: Mock external dependencies and test business logic
- **Repositories**: Test data transformation and caching logic
- **Utilities**: Test helper functions and extensions

### Integration Testing

- **Authentication Flow**: Test complete sign-up and sign-in processes
- **Task Management**: Test task creation, bidding, and assignment workflows
- **Payment Processing**: Test payment initialization and completion (using test environment)
- **Real-time Features**: Test chat and notification delivery

### Widget Testing

- **Authentication Screens**: Test form validation and user interactions
- **Task Screens**: Test task display, filtering, and creation forms
- **Payment Screens**: Test payment flow and error handling
- **Profile Screens**: Test profile editing and verification processes

### End-to-End Testing

- **Complete User Journeys**: Test full workflows from task posting to payment completion
- **Cross-Platform Testing**: Ensure consistent behavior across iOS and Android
- **Performance Testing**: Test app performance under various network conditions
- **Accessibility Testing**: Ensure app is accessible to users with disabilities

## Security Considerations

### Data Protection

1. **Encryption**: All sensitive data encrypted at rest and in transit
2. **Authentication**: Secure token-based authentication with refresh tokens
3. **Authorization**: Role-based access control for different user types
4. **Input Validation**: Server-side validation for all user inputs
5. **File Upload Security**: Validate file types and scan for malicious content

### Payment Security

1. **PCI Compliance**: Use Paystack's secure payment processing
2. **Escrow System**: Hold funds securely until task completion
3. **Transaction Verification**: Verify all transactions using webhooks
4. **Fraud Detection**: Monitor for suspicious payment patterns
5. **Secure API Keys**: Store payment API keys securely on server-side

### Privacy Protection

1. **Data Minimization**: Collect only necessary user information
2. **Consent Management**: Clear consent for data collection and usage
3. **Data Retention**: Implement data retention and deletion policies
4. **User Control**: Allow users to view, edit, and delete their data
5. **Third-party Integration**: Ensure third-party services comply with privacy standards

## Performance Optimization

### App Performance

1. **Lazy Loading**: Load content on-demand to reduce initial load time
2. **Image Optimization**: Compress and cache images for faster loading
3. **Database Indexing**: Optimize database queries with proper indexing
4. **Caching Strategy**: Implement multi-level caching for frequently accessed data
5. **Background Processing**: Handle heavy operations in background threads

### Real-time Features

1. **Connection Management**: Efficiently manage WebSocket connections
2. **Message Batching**: Batch multiple updates to reduce network calls
3. **Offline Support**: Cache critical data for offline functionality
4. **Sync Strategy**: Implement conflict resolution for offline-online sync
5. **Resource Management**: Properly dispose of streams and subscriptions

## Scalability Considerations

### Backend Scalability

1. **Microservices Architecture**: Use Appwrite Functions for modular backend logic
2. **Database Sharding**: Plan for horizontal scaling of user and task data
3. **CDN Integration**: Use content delivery networks for static assets
4. **Load Balancing**: Distribute traffic across multiple server instances
5. **Monitoring**: Implement comprehensive monitoring and alerting

### Frontend Scalability

1. **Code Splitting**: Organize code into feature-based modules
2. **State Management**: Use efficient state management patterns
3. **Memory Management**: Properly dispose of resources and avoid memory leaks
4. **Build Optimization**: Optimize build process for faster deployment
5. **Feature Flags**: Implement feature toggles for gradual rollouts
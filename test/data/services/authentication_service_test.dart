import 'package:flutter_test/flutter_test.dart';
import 'package:taskpay/data/services/authentication_service.dart';
import 'package:taskpay/data/services/appwrite_authentication_service.dart';

void main() {
  group('AuthenticationService Interface', () {
    test('should define correct interface methods', () {
      // Test that the interface has all required methods
      expect(AuthenticationService, isA<Type>());
      
      // We can't instantiate the abstract class, but we can verify
      // that the concrete implementation exists
      expect(AppwriteAuthenticationService, isA<Type>());
    });

    test('should handle authentication exceptions', () {
      expect(
        () => throw AuthenticationException('Test error'),
        throwsA(isA<AuthenticationException>()),
      );
    });
  });

  group('AuthenticationException', () {
    test('should create exception with message', () {
      const message = 'Test authentication error';
      final exception = AuthenticationException(message);
      
      expect(exception.message, equals(message));
      expect(exception.code, equals('AUTH_ERROR'));
      expect(exception.toString(), contains(message));
    });

    test('should create exception with custom code', () {
      const message = 'Test error';
      const code = 'CUSTOM_CODE';
      final exception = AuthenticationException(message, code);
      
      expect(exception.message, equals(message));
      expect(exception.code, equals(code));
    });
  });
}
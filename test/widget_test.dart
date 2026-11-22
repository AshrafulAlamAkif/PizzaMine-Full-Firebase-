
import 'package:flutter_test/flutter_test.dart';
import 'package:pizzamine/features/auth/auth_model.dart';

void main() {
  group('AppUser Model Tests', () {
    test('should create user with correct information', () {
      const user = AppUser(
        id: 'user123',
        email: 'test@example.com',
        displayName: 'Test User',
      );

      expect(user.id, 'user123');
      expect(user.email, 'test@example.com');
      expect(user.displayName, 'Test User');
    });

    test('should allow optional display name', () {
      const user = AppUser(
        id: 'user123',
        email: 'test@example.com',
      );

      expect(user.displayName, isNull);
    });
  });
}
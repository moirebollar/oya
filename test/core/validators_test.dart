import 'package:flutter_test/flutter_test.dart';
import 'package:oya/core/utils/validators.dart';

void main() {
  group('Validators.email', () {
    test('accepts valid email addresses', () {
      expect(Validators.email('user@example.com'), isNull);
      expect(Validators.email('user+tag@sub.domain.org'), isNull);
      expect(Validators.email('a@b.co'), isNull);
    });

    test('rejects empty email', () {
      expect(Validators.email(''), isNotNull);
      expect(Validators.email(null), isNotNull);
    });

    test('rejects email without @ symbol', () {
      expect(Validators.email('notanemail'), isNotNull);
    });

    test('rejects email without domain', () {
      expect(Validators.email('user@'), isNotNull);
    });
  });

  group('Validators.password', () {
    test('accepts password of 8+ characters', () {
      expect(Validators.password('password123'), isNull);
      expect(Validators.password('12345678'), isNull);
    });

    test('rejects password shorter than 8 characters', () {
      expect(Validators.password('1234567'), isNotNull);
      expect(Validators.password(''), isNotNull);
      expect(Validators.password(null), isNotNull);
    });
  });

  group('Validators.required', () {
    test('accepts non-empty strings', () {
      expect(Validators.required('hello'), isNull);
      expect(Validators.required('  x  '), isNull);
    });

    test('rejects empty or null strings', () {
      expect(Validators.required(''), isNotNull);
      expect(Validators.required('   '), isNotNull);
      expect(Validators.required(null), isNotNull);
    });
  });
}

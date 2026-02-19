import 'package:flutter_test/flutter_test.dart';

void main() {
  test('placeholder — run integration tests with Firebase Emulator', () {
    // Widget smoke tests require a running Firebase emulator.
    // Run: firebase emulators:start --only auth,firestore
    // Then: flutter test integration_test/
    expect(true, isTrue);
  });
}

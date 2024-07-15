// ignore_for_file: prefer_const_constructors
import 'package:sns_client/sns_client.dart';
import 'package:test/test.dart';

void main() {
  group('SnsClient', () {
    test('can be instantiated', () {
      expect(SnsClient(), isNotNull);
    });
  });
}

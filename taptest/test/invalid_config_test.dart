import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:taptest/src/private/validate_config.dart';
import 'package:taptest/taptest.dart';

void main() {
  test('no theme modes', () async {
    expect(
      () => validateConfig(
        Config(
          themeModes: [],
          builder: (params) => MaterialApp(),
        ),
      ),
      throwsA(isA<ArgumentError>()),
    );
  });

  test('no locales', () async {
    expect(
      () => validateConfig(
        Config(
          locales: [],
          builder: (params) => MaterialApp(),
        ),
      ),
      throwsA(isA<ArgumentError>()),
    );
  });
}

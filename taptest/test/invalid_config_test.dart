import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:taptest/src/private/validate_config.dart';
import 'package:taptest/taptest.dart';

void main() {
  test('no variants', () async {
    expect(
      () => validateConfig(
        Config(
          variants: [],
          builder: (params) => MaterialApp(),
        ),
      ),
      throwsA(isA<ArgumentError>()),
    );
  });
}

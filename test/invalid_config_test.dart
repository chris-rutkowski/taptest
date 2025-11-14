import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:taptest/src/private/validate_config.dart';
import 'package:taptest/taptest.dart';

void main() {
  test('no variants', () async {
    await expectLater(
      () => validateConfig(
        Config(
          variants: [],
          builder: (context, _) => MaterialApp(),
        ),
      ),
      throwsA(isA<ArgumentError>()),
    );
  });
}

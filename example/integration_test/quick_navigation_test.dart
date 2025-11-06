import 'package:example/features/dummy_screen/presentation/dummy_keys.dart';
import 'package:example/features/welcome/presentation/welcome_keys.dart';
import 'package:flutter/material.dart';
import 'package:taptest/taptest.dart';

import '_utils/default_integration_tap_tester_config.dart';

void main() {
  final noSpanishConfig = defaultIntegrationTapTesterConfig.copyWith(
    variants: defaultIntegrationTapTesterConfig.variants.where((e) => e.locale != const Locale('es')).toList(),
  );

  tapTest('quick navigation', noSpanishConfig, (tt) async {
    for (var i = 0; i < 10; i++) {
      await tt.info('On Welcome screen ${i + 1}/10');
      await tt.exists(WelcomeKeys.screen);
      await tt.tap(WelcomeKeys.dummyButton);

      await tt.info('On Dummy screen');
      await tt.exists(DummyKeys.screen);
      await tt.pop();
    }
  });
}

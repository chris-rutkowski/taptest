import 'package:example/features/welcome/presentation/welcome_keys.dart';
import 'package:flutter/material.dart';
import 'package:taptest/taptest.dart';

import '_utils/default_tap_tester_config.dart';

void main() {
  final config = defaultTapTesterConfig.copyWith(
    suite: 'no_variations_test',
  );

  tapTest('flow', config, (tester) async {
    await tester.exists(WelcomeKeys.screen);
    await tester.snapshot('initial', variations: false);
    await tester.changeThemeMode(ThemeMode.dark);
    await tester.snapshot('dark', variations: false);
    await tester.changeLocale(const Locale('es'));
    await tester.snapshot('dark_spanish', variations: false);

    // should cycle all languages and locale…
    await tester.snapshot('all');
    // …but end up in dark spanish
    await tester.snapshot('dark_spanish_again', variations: false);
  });
}

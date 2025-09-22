import 'package:example/features/limitations/presentation/limitations_keys.dart';
import 'package:example/features/welcome/presentation/welcome_keys.dart';
import 'package:flutter/material.dart';
import 'package:taptest/taptest.dart';

import '_utils/default_tap_tester_config.dart';

void main() {
  final config = defaultTapTesterConfig.copyWith(
    suite: 'limitations',
  );

  tapTest('overall', config, (tester) async {
    await tester.info('On Welcome screen');
    await tester.exists(WelcomeKeys.screen);
    await tester.tap(WelcomeKeys.limitationsButton, sync: SyncType.settled);

    await tester.info('On Limitations screen');
    await tester.exists(LimitationsKeys.screen);
    await tester.snapshot('screen', locales: [Locale('en')], themeModes: [ThemeMode.light]);
  });
}

import 'package:example/features/limitations/presentation/limitations_keys.dart';
import 'package:example/features/welcome/presentation/welcome_keys.dart';
import 'package:taptest/taptest.dart';

import '_utils/default_tap_tester_config.dart';

void main() {
  final config = defaultTapTesterConfig.copyWith();

  tapTest('limitations', config, (tt) async {
    await tt.info('On Welcome screen');
    await tt.exists(WelcomeKeys.screen);
    await tt.tap(WelcomeKeys.limitationsButton);

    await tt.info('On Limitations screen');
    await tt.exists(LimitationsKeys.screen);
    await tt.snapshot('screen');
  });
}

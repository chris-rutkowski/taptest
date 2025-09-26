import 'package:example/features/dummy_screen/presentation/dummy_keys.dart';
import 'package:example/features/welcome/presentation/welcome_keys.dart';
import 'package:taptest/taptest.dart';

import '_utils/default_integration_tap_tester_config.dart';

void main() {
  tapTest('quick navigation', defaultIntegrationTapTesterConfig, (tester) async {
    for (var i = 0; i < 10; i++) {
      await tester.info('On Welcome screen ${i + 1}/10');
      await tester.exists(WelcomeKeys.screen);
      await tester.tap(WelcomeKeys.dummyButton, sync: SyncType.settled);

      await tester.info('On Dummy screen');
      await tester.exists(DummyKeys.screen);
      await tester.pop();
    }
  });
}

import 'package:example/features/disappearing_widget_screen.dart/disappearing_keys.dart';
import 'package:example/features/welcome/presentation/welcome_keys.dart';
import 'package:taptest/taptest.dart';

import '../_utils/default_tap_tester_config.dart';

void main() {
  tapTest('Disappearing Widget will disappear', defaultTapTesterConfig, (tester) async {
    await tester.info('On Welcome screen');
    await tester.exists(WelcomeKeys.screen);
    await tester.tap(WelcomeKeys.disappearingButton, sync: SyncType.settled);

    await tester.info('On Disappearing Widget screen');
    await tester.exists(DisappearingKeys.screen);
    await tester.exists(DisappearingKeys.disappearingWidget);
    await tester.snapshot('before');
    await tester.wait(Duration(seconds: 2));
    await tester.absent(DisappearingKeys.disappearingWidget);
    await tester.snapshot('after 2 seconds');
  });
}

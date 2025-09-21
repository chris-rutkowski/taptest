import 'package:example/features/welcome/presentation/welcome_keys.dart';
import 'package:taptest/taptest.dart';

import '../test/_utils/default_tap_tester_config.dart';

void main() {
  final config = defaultTapTesterConfig.copyWith(
    integration: true,
    httpRequestHandlers: [
      // const TodoHandler(
      //   todos: [
      //     TodoDto(id: 1, text: 'From test 1', completed: false),
      //     TodoDto(id: 2, text: 'From test 2', completed: true),
      //     TodoDto(id: 3, text: 'From test 3', completed: false),
      //     TodoDto(id: 3, text: 'From test 4', completed: false),
      //   ],
      // ),
    ],
    suite: 'http_integration',
  );

  tapTest('tap on the floating action button, verify counter', config, (
    tester,
  ) async {
    await tester.info('On Welcome screen');
    await tester.exists(WelcomeKeys.screen);
    await tester.tap(WelcomeKeys.httpButton, sync: SyncType.settled);

    // await tester.info('On Http screen');
    // await tester.exists(HttpKeys.screen);
    // await tester.exists(HttpKeys.cell(0), timeout: const Duration(seconds: 2));
    // await tester.snapshot('http_screen');

    // await Future.delayed(const Duration(seconds: 5));

    // await tester.pumpWidget(ProviderScope(child: const ExampleApp()));
    // final button = find.byKey(WelcomeKeys.httpButton);
    // await tester.tap(button);
    // await tester.pumpAndSettle();
    // expect(find.byKey(HttpKeys.screen), findsOneWidget);

    // await Future.delayed(const Duration(seconds: 2));
    // await tester.pumpAndSettle();

    // expect(find.byKey(HttpKeys.cell(0)), findsOneWidget);
  });
}

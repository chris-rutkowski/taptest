import 'package:example/features/http_screen/http_keys.dart';
import 'package:example/features/welcome/presentation/welcome_keys.dart';
import 'package:taptest/taptest.dart';

import '_utils/default_integration_tap_tester_config.dart';

void main() {
  final config = defaultIntegrationTapTesterConfig.copyWith(
    httpRequestHandlers: () => [
      // const TodoHandler(
      //   todos: [
      //     TodoDto(id: 1, text: 'From test 1', completed: false),
      //     TodoDto(id: 2, text: 'From test 2', completed: true),
      //     TodoDto(id: 3, text: 'From test 3', completed: false),
      //     TodoDto(id: 3, text: 'From test 4', completed: false),
      //   ],
      // ),
    ],
  );

  tapTest('tap on the floating action button, verify counter', config, (tt) async {
    await tt.info('On Welcome screen');
    await tt.exists(WelcomeKeys.screen);
    await tt.tap(WelcomeKeys.httpButton);

    await tt.info('On Http screen');
    await tt.exists(HttpKeys.screen);
    await tt.exists(HttpKeys.cell(0), timeout: const Duration(seconds: 3));
    await tt.snapshot('http_screen');

    // await tt.pumpWidget(ProviderScope(child: const ExampleApp()));
    // final button = find.byKey(WelcomeKeys.httpButton);
    // await tt.tap(button);
    // await tt.pumpAndSettle();
    // expect(find.byKey(HttpKeys.screen), findsOneWidget);

    // await Future.delayed(const Duration(seconds: 2));
    // await tt.pumpAndSettle();

    // expect(find.byKey(HttpKeys.cell(0)), findsOneWidget);
  });
}

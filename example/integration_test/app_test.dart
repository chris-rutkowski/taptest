import 'package:example/example_app.dart';
import 'package:example/features/http_screen/http_keys.dart';
import 'package:example/features/welcome/presentation/welcome_keys.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  group('end-to-end test', () {
    testWidgets('tap on the floating action button, verify counter', (
      tester,
    ) async {
      IntegrationTestWidgetsFlutterBinding.ensureInitialized();

      await tester.pumpWidget(ProviderScope(child: const ExampleApp()));
      final button = find.byKey(WelcomeKeys.httpButton);
      await tester.tap(button);
      await tester.pumpAndSettle();
      expect(find.byKey(HttpKeys.screen), findsOneWidget);

      await Future.delayed(const Duration(seconds: 1));

      expect(find.byKey(HttpKeys.cell(0)), findsOneWidget);
    });
  });
}

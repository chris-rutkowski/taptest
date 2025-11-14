import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_riverpod/core/setup_firebase.dart';
import 'package:firebase_riverpod/demo_app.dart';
import 'package:firebase_riverpod/features/auth/auth_keys.dart';
import 'package:firebase_riverpod/features/dashboard/presentation/dashboard_keys.dart';
import 'package:firebase_riverpod/features/misc/about_keys.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taptest/taptest.dart';

Config createConfig({String? initialRoute}) {
  final config = Config(
    initialRoute: initialRoute,
    variants: Variant.lightAndDarkVariants,
    builder: (params) async {
      await setupFirebase();

      return ProviderScope(
        child: DemoApp(params: params),
      );
    },
  );

  return config;
}

void main() {
  tapTest('E2E', createConfig(), (tt) async {
    await tt.exists(RegisterKeys.screen);
    await tt.snapshot('register_screen');

    await tt.info("Let's promptly view About screen and go back");
    await tt.tap(RegisterKeys.aboutTile);
    await tt.exists(AboutKeys.screen);
    await tt.snapshot('about_screen');
    await tt.pop();

    await tt.info("Let's register without filling the confirm password field");
    await tt.exists(RegisterKeys.screen);
    await tt.type(RegisterKeys.emailField, 'test@example.com');
    await tt.type(RegisterKeys.passwordField, 'password123');
    await tt.tap(RegisterKeys.registerButton);
    await tt.exists(RegisterKeys.errorDialog);
    await tt.expectText(RegisterKeys.errorDialogMessage, 'Please fill the registration form.');
    await tt.tap(RegisterKeys.errorDialogOKButton);

    await tt.info("Let's fill the confirm password field with non-matching passwords");
    await tt.type(RegisterKeys.confirmPasswordField, 'wrong-confirmation', submit: true);
    await tt.exists(RegisterKeys.errorDialog);
    await tt.expectText(RegisterKeys.errorDialogMessage, 'Passwords do not match.');
    await tt.tap(RegisterKeys.errorDialogOKButton);

    await tt.info("Let's correct the confirm password and hit keyboard submit button");
    await tt.tap(RegisterKeys.confirmPasswordField); // shouldn't be required but glitches otherwise
    await tt.type(RegisterKeys.confirmPasswordField, 'password123', submit: true);
    // await tt.tap(RegisterKeys.registerButton);

    await tt.info("We should be on Dashboard Screen without any memos");
    await tt.exists(DashboardKeys.screen);
    await tt.expectText(DashboardKeys.email, 'test@example.com');
    await tt.exists(DashboardKeys.noMemosTile);
    await tt.absent(DashboardKeys.memoTile(0));
    await tt.snapshot('dashboard_empty');

    await tt.info("Let's add one memo, it should appear in the list and clears the input field");
    await tt.type(DashboardKeys.newMemoField, 'Buy milk', submit: true);
    await tt.expectText([DashboardKeys.memoTile(0), DashboardKeys.memoText], 'Buy milk');
    await tt.expectText(DashboardKeys.newMemoField, ''); // submitting should clear the field

    await tt.info("Let's add another memo, it should appear on the top of the list as they are sorted alphabetically");
    await tt.tap(DashboardKeys.newMemoField); // shouldn't be required but glitches otherwise
    await tt.type(DashboardKeys.newMemoField, 'Answer mail', submit: true);
    await tt.expectText([DashboardKeys.memoTile(0), DashboardKeys.memoText], 'Answer mail');
    await tt.expectText([DashboardKeys.memoTile(1), DashboardKeys.memoText], 'Buy milk');

    await tt.info("Let's add memo that will display in the end of the list alphabetically");
    await tt.tap(DashboardKeys.newMemoField); // shouldn't be required but glitches otherwise
    await tt.type(DashboardKeys.newMemoField, 'Call mom', submit: true);
    await tt.expectText([DashboardKeys.memoTile(0), DashboardKeys.memoText], 'Answer mail');
    await tt.expectText([DashboardKeys.memoTile(1), DashboardKeys.memoText], 'Buy milk');
    await tt.expectText([DashboardKeys.memoTile(2), DashboardKeys.memoText], 'Call mom');
    await tt.snapshot('dashboard_3_memos');

    await tt.info("Let's delete the middle memo and verify the other two remaining");
    await tt.tap([DashboardKeys.memoTile(1), DashboardKeys.deleteMemoButton]);
    await tt.expectText([DashboardKeys.memoTile(0), DashboardKeys.memoText], 'Answer mail');
    await tt.expectText([DashboardKeys.memoTile(1), DashboardKeys.memoText], 'Call mom');

    // Let's delete current user before we change variant (dark theme) and re-register
    await FirebaseAuth.instance.currentUser?.delete();

    await tt.info("Let's logout and verify we are back on Register screen");
    await tt.tap(DashboardKeys.logoutButton);
    await tt.exists(RegisterKeys.screen);
  });

  tapTest(
    'Deeplink and routing overall',
    createConfig(initialRoute: '/about'),
    (tt) async {
      // app starts with About screen
      await tt.exists(AboutKeys.screen);
      await tt.pop();

      // leave About, should go to Register
      await tt.info('On Register Screen');
      await tt.exists(RegisterKeys.screen);

      // use deeplink to About
      await tt.go('/about');
      await tt.exists(AboutKeys.screen);
      await tt.pop();

      // let's register as About is only accessible when logged out
      await tt.type(RegisterKeys.emailField, 'test@example.com');
      await tt.type(RegisterKeys.passwordField, 'password123');
      await tt.type(RegisterKeys.confirmPasswordField, 'password123');
      await tt.tap(RegisterKeys.registerButton);
      await tt.exists(DashboardKeys.screen);

      // once registered, let's attempt to deeplink to About - should be rejected
      await tt.go('/about');
      await tt.absent(AboutKeys.screen);
      await tt.exists(DashboardKeys.screen);

      // Let's delete current user before we change variant (dark theme) and re-register
      await FirebaseAuth.instance.currentUser?.delete();

      // let's logout
      await tt.tap(DashboardKeys.logoutButton);
      await tt.exists(RegisterKeys.screen);

      // once logged out, deeplink to About should work again
      await tt.go('/about');
      await tt.exists(AboutKeys.screen);
    },
  );
}

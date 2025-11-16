import 'package:firebase_riverpod/features/auth/auth_keys.dart';
import 'package:firebase_riverpod/features/auth/data_domain/app_user.dart';
import 'package:firebase_riverpod/features/dashboard/presentation/dashboard_keys.dart';
import 'package:firebase_riverpod/features/misc/about_keys.dart';
import 'package:taptest/taptest.dart';

import 'mocks/mock_auth_repository.dart';
import 'utils/create_config.dart';

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
    await tt.type(RegisterKeys.confirmPasswordField, 'password123', submit: true);

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
    await tt.type(DashboardKeys.newMemoField, 'Answer mail', submit: true);
    await tt.expectText([DashboardKeys.memoTile(0), DashboardKeys.memoText], 'Answer mail');
    await tt.expectText([DashboardKeys.memoTile(1), DashboardKeys.memoText], 'Buy milk');

    await tt.info("Let's add memo that will display in the end of the list alphabetically");
    await tt.type(DashboardKeys.newMemoField, 'Call mom', submit: true);
    await tt.expectText([DashboardKeys.memoTile(0), DashboardKeys.memoText], 'Answer mail');
    await tt.expectText([DashboardKeys.memoTile(1), DashboardKeys.memoText], 'Buy milk');
    await tt.expectText([DashboardKeys.memoTile(2), DashboardKeys.memoText], 'Call mom');
    await tt.snapshot('dashboard_3_memos');

    await tt.info("Let's delete the middle memo and verify the other two remaining");
    await tt.tap([DashboardKeys.memoTile(1), DashboardKeys.deleteMemoButton]);
    await tt.expectText([DashboardKeys.memoTile(0), DashboardKeys.memoText], 'Answer mail');
    await tt.expectText([DashboardKeys.memoTile(1), DashboardKeys.memoText], 'Call mom');

    await tt.info("Let's logout and verify we are back on Register screen");
    await tt.tap(DashboardKeys.logoutButton);
    await tt.exists(RegisterKeys.screen);
  });

  tapTest(
    'Logged in user will immediately see Dashboard',
    createConfig(
      user: AppUser(id: '1', email: 'existing@example.com'),
    ),
    (tt) async {
      await tt.exists(DashboardKeys.screen);
    },
  );

  tapTest(
    'Login existing user',
    createConfig(
      allUsers: [
        AppUserWithPassword(
          user: AppUser(id: '1', email: 'existing@example.com'),
          password: 'password123',
        ),
      ],
    ),
    (tt) async {
      await tt.exists(RegisterKeys.screen);
      await tt.tap(RegisterKeys.loginInsteadTile);

      await tt.info('On Login Screen');
      await tt.exists(LoginKeys.screen);
      await tt.type(LoginKeys.emailField, 'existing@example.com');
      await tt.tap(LoginKeys.loginButton);
      await tt.exists(LoginKeys.errorDialog);
      await tt.expectText(LoginKeys.errorDialogMessage, 'Please fill the login form.');
      await tt.tap(LoginKeys.errorDialogOKButton);
      await tt.type(LoginKeys.passwordField, 'wrong-password');
      await tt.tap(LoginKeys.loginButton);
      await tt.exists(LoginKeys.errorDialog);
      await tt.expectText(LoginKeys.errorDialogMessage, 'Login failed.');
      await tt.tap(LoginKeys.errorDialogOKButton);
      await tt.type(LoginKeys.passwordField, 'password123', submit: true);

      await tt.info('On Dashboard Screen');
      await tt.exists(DashboardKeys.screen);
    },
  );

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

      // let's logout
      await tt.tap(DashboardKeys.logoutButton);
      await tt.exists(RegisterKeys.screen);

      // once logged out, deeplink to About should work again
      await tt.go('/about');
      await tt.exists(AboutKeys.screen);
    },
  );
}

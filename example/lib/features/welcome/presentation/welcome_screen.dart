import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/app_localizations.dart';
import 'welcome_keys.dart';

final class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: WelcomeKeys.screen,
      appBar: AppBar(
        title: const Text('Welcome screen'),
      ),
      body: ListView(
        children: [
          Center(
            child: Text(AppLocalizations.of(context)!.helloWorld),
          ),
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(AppLocalizations.of(context)!.internationalisation),
                SizedBox(width: 8),
                Text(
                  AppLocalizations.of(context)!.countryFlagEmoji,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ],
            ),
          ),
          ListTile(
            title: const Text('Menu'),
            onTap: () {
              GoRouter.of(context).go('/menu');
            },
          ),
          ListTile(
            key: WelcomeKeys.loginButton,
            title: const Text('Login'),
            onTap: () {
              GoRouter.of(context).go('/login');
            },
          ),

          ListTile(
            key: WelcomeKeys.registerButton,
            title: const Text('Register'),
            onTap: () {
              GoRouter.of(context).go('/registration');
            },
          ),

          ListTile(
            key: WelcomeKeys.longButton,
            title: const Text('Long'),
            onTap: () {
              GoRouter.of(context).go('/long');
            },
          ),

          ListTile(
            title: const Text('Diagnostics'),
            onTap: () {
              GoRouter.of(context).go('/diagnostics');
            },
          ),
          ListTile(
            key: WelcomeKeys.httpButton,
            title: const Text('HTTP'),
            onTap: () {
              GoRouter.of(context).go('/http');
            },
          ),
          ListTile(
            key: WelcomeKeys.dummyButton,
            title: const Text('Dummy'),
            onTap: () {
              GoRouter.of(context).go('/dummy');
            },
          ),
        ],
      ),
    );
  }
}

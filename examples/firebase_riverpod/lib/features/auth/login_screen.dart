import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'auth_keys.dart';
import 'data_domain/auth_repository_provider.dart';

final class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

final class _LoginScreenState extends ConsumerState<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void onLoginPressed() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      displayError('Please fill the login form.');
      return;
    }

    final authRepository = ref.read(authRepositoryProvider);

    try {
      await authRepository.login(
        email: emailController.text,
        password: passwordController.text,
      );

      // No need for any navigator/router call
      // Router is responsible to redirect user into the member area
    } catch (_) {
      if (!mounted) return;
      displayError('Login failed.');
    }
  }

  void displayError(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        key: LoginKeys.errorDialog,
        title: const Text('Error'),
        content: Text(message, key: LoginKeys.errorDialogMessage),
        actions: [
          TextButton(
            key: LoginKeys.errorDialogOKButton,
            onPressed: () => Navigator.of(context).pop(), // Close the dialog
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: LoginKeys.screen,
      appBar: AppBar(
        title: const Text('Login'),
        actions: [
          TextButton(
            key: LoginKeys.loginButton,
            onPressed: () => onLoginPressed(),
            child: const Text('Login'),
          ),
        ],
      ),
      body: ListView(
        children: [
          ListTile(
            title: TextField(
              key: LoginKeys.emailField,
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
            ),
          ),
          ListTile(
            title: TextField(
              key: LoginKeys.passwordField,
              controller: passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
              ),
              obscureText: true,
              onSubmitted: (_) => onLoginPressed(),
            ),
          ),
        ],
      ),
    );
  }
}

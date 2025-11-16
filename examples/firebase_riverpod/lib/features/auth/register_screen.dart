import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'auth_keys.dart';
import 'data_domain/auth_repository_provider.dart';

final class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

final class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();

    super.dispose();
  }

  void onRegisterPressed() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty || confirmPasswordController.text.isEmpty) {
      displayError('Please fill the registration form.');
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      displayError('Passwords do not match.');
      return;
    }

    final authRepository = ref.read(authRepositoryProvider);
    try {
      await authRepository.register(
        email: emailController.text,
        password: passwordController.text,
      );

      // No need for any navigator/router call
      // Router is responsible to redirect user into the member area
    } catch (_) {
      if (!mounted) return;
      displayError('Registration failed.');
    }
  }

  void displayError(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        key: RegisterKeys.errorDialog,
        title: const Text('Error'),
        content: Text(message, key: RegisterKeys.errorDialogMessage),
        actions: [
          TextButton(
            key: RegisterKeys.errorDialogOKButton,
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
      key: RegisterKeys.screen,
      appBar: AppBar(
        title: const Text('Register'),
        actions: [
          TextButton(
            key: RegisterKeys.registerButton,
            onPressed: () => onRegisterPressed(),
            child: const Text('Register'),
          ),
        ],
      ),
      body: ListView(
        children: [
          ListTile(
            title: TextField(
              key: RegisterKeys.emailField,
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
            ),
          ),
          ListTile(
            title: TextField(
              key: RegisterKeys.passwordField,
              controller: passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
              ),
              obscureText: true,
            ),
          ),
          ListTile(
            title: TextField(
              key: RegisterKeys.confirmPasswordField,
              controller: confirmPasswordController,
              decoration: const InputDecoration(
                labelText: 'Confirm password',
              ),
              obscureText: true,
              onSubmitted: (_) => onRegisterPressed(),
            ),
          ),
          ListTile(
            key: RegisterKeys.loginInsteadTile,
            title: Text('Existing user? Login instead'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => GoRouter.of(context).go('/login'),
          ),
          ListTile(
            key: RegisterKeys.aboutTile,
            title: Text('About'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => GoRouter.of(context).go('/about'),
          ),
        ],
      ),
    );
  }
}

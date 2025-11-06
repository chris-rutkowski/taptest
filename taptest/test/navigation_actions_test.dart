import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:taptest/taptest.dart';

void main() {
  final config = Config(
    builder: (params) => _NavApp(initialRoute: params.initialRoute),
  );

  tapTest('flow', config, (tt) async {
    // Ensure the app displays the expected screen (good general practice)
    await tt.exists(_Keys.homeScreen);

    // Navigate to edit screen by pressing button and go back
    await tt.tap(_Keys.editButton);
    await tt.exists(_Keys.editScreen);
    await tt.pop();
    await tt.exists(_Keys.homeScreen);

    // Navigate to edit screen by deeplink route
    await tt.go('/edit');
    await tt.exists(_Keys.editScreen);

    // Makes unsaved changes
    await tt.tap(_Keys.unsavedChangesCheckbox);

    // Attempt to go back, cancel the confirm exit dialog
    await tt.pop();
    await tt.exists(_Keys.confirmExitDialog);
    await tt.tap(_Keys.dialogCancelButton);
    await tt.absent(_Keys.confirmExitDialog);
    await tt.exists(_Keys.editScreen);

    // Confirm exit dialog and go back to home screen
    await tt.pop();
    await tt.tap(_Keys.dialogConfirmButton);
    await tt.absent(_Keys.editScreen);
    await tt.exists(_Keys.homeScreen);
  });

  tapTest('initial route', config.copyWith(initialRoute: '/edit'), (tt) async {
    // starts immediately on edit screen
    await tt.exists(_Keys.editScreen);

    // can pop to home screen
    await tt.pop();
    await tt.exists(_Keys.homeScreen);
  });
}

// --- Below is the app being tested with the test(s) above ---

abstract class _Keys {
  static const homeScreen = ValueKey('homeScreen');
  static const editButton = ValueKey('editButton');
  static const editScreen = ValueKey('editScreen');
  static const unsavedChangesCheckbox = ValueKey('unsavedChangesCheckbox');
  static const confirmExitDialog = ValueKey('confirmExitDialog');
  static const dialogCancelButton = ValueKey('dialogCancelButton');
  static const dialogConfirmButton = ValueKey('dialogConfirmButton');
}

final class _NavApp extends StatelessWidget {
  final String? initialRoute;

  const _NavApp({
    this.initialRoute,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: GoRouter(
        initialLocation: initialRoute,
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const _HomeScreen(),
            routes: [
              GoRoute(
                path: '/edit',
                builder: (context, state) => const _EditScreen(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

final class _HomeScreen extends StatelessWidget {
  const _HomeScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _Keys.homeScreen,
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            key: _Keys.editButton,
            icon: const Icon(Icons.edit),
            onPressed: () => context.go('/edit'),
          ),
        ],
      ),
    );
  }
}

final class _EditScreen extends StatefulWidget {
  const _EditScreen();

  @override
  State<_EditScreen> createState() => _EditScreenState();
}

final class _EditScreenState extends State<_EditScreen> {
  var hasUnsavedChanges = false;

  Future<void> _onPopInvoked(bool didPop) async {
    if (!hasUnsavedChanges || didPop) return;

    final navigator = Navigator.of(context);

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        key: _Keys.confirmExitDialog,
        title: const Text('Confirm Exit'),
        actions: [
          TextButton(
            key: _Keys.dialogCancelButton,
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            key: _Keys.dialogConfirmButton,
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      navigator.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      key: _Keys.editScreen,
      canPop: !hasUnsavedChanges,
      onPopInvokedWithResult: (didPop, _) => _onPopInvoked(didPop),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Edit'),
        ),
        body: ListView(
          children: [
            CheckboxListTile(
              key: _Keys.unsavedChangesCheckbox,
              title: const Text('Has unsaved changes'),
              value: hasUnsavedChanges,
              onChanged: (value) {
                setState(() => hasUnsavedChanges = value ?? false);
              },
            ),
          ],
        ),
      ),
    );
  }
}

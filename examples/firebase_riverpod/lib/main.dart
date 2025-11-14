import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/setup_firebase.dart';
import 'demo_app.dart';

// Start the Firebase emulator before running the app:
// firebase emulators:start

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupFirebase();

  runApp(
    ProviderScope(
      child: const DemoApp(),
    ),
  );
}

import 'package:flutter/material.dart';
import 'package:taptest/taptest.dart';
import 'package:taptest_runtime/taptest_runtime.dart';

void main() {
  final config = Config(
    builder: (context, _) => MaterialApp(
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: TapTestRuntime.of(context)?.themeMode,
      home: _Screen(),
    ),
  );

  tapTest('change theme mode', config, (tt) async {
    // Ensure the app displays the expected screen (good general practice)
    await tt.exists(_Keys.screen);

    await tt.expectText(_Keys.brightnessLabel, 'light');
    await tt.changeThemeMode(ThemeMode.dark);
    await tt.expectText(_Keys.brightnessLabel, 'dark');
    await tt.changeThemeMode(ThemeMode.light);
    await tt.expectText(_Keys.brightnessLabel, 'light');
  });
}

// --- Below is the app being tested with the test(s) above ---

abstract class _Keys {
  static const screen = ValueKey('Screen');
  static const brightnessLabel = ValueKey('BrightnessLabel');
}

final class _Screen extends StatelessWidget {
  const _Screen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _Keys.screen,
      body: Center(
        child: Text(
          Theme.of(context).brightness.name,
          key: _Keys.brightnessLabel,
        ),
      ),
    );
  }
}

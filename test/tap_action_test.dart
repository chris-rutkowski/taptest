import 'package:flutter/material.dart';
import 'package:taptest/taptest.dart';

void main() {
  final config = Config(
    builder: (themeMode, locale) => const MaterialApp(
      home: _Screen(
        key: _Keys.screen,
      ),
      debugShowCheckedModeBanner: false,
    ),
  );

  tapTest('tap', config, (tester) async {
    // Ensure the app displays the expected screen (good general practice)
    await tester.exists(_Keys.screen);

    // Verify initial state
    await tester.text(_Keys.statusLabel, 'Idle');

    // Single tap on tap area
    await tester.tap(_Keys.tapArea);
    // Since this GestureDetector handles both single and double taps, there's a slight delay
    // before the single tap is confirmed. You could wait about 41ms:
    // await tester.wait(Duration(milliseconds: 41));
    // However, TapTester.text has a built-in retry mechanism with a 5-second timeout
    await tester.text(_Keys.statusLabel, 'Single tapped');

    // Double tap on tap area
    await tester.tap(_Keys.tapArea, count: 2);
    await tester.text(_Keys.statusLabel, 'Double tapped');

    // Tap the button
    await tester.tap(_Keys.button);
    await tester.text(_Keys.statusLabel, 'Button tapped');

    // Clear the GestureDetector's internal timer to avoid test interference
    await tester.wait(Duration(milliseconds: 40));
  });
}

// --- Below is the app being tested with the test(s) above ---

abstract class _Keys {
  static const screen = ValueKey('screen');
  static const statusLabel = ValueKey('statusLabel');
  static const button = ValueKey('button');
  static const tapArea = ValueKey('tapArea');
}

final class _Screen extends StatefulWidget {
  const _Screen({super.key});

  @override
  State<_Screen> createState() => _ScreenState();
}

final class _ScreenState extends State<_Screen> {
  var status = 'Idle';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Text(status, key: _Keys.statusLabel),
          ElevatedButton(
            key: _Keys.button,
            onPressed: () {
              setState(() => status = 'Button tapped');
            },
            child: const Text('Button'),
          ),
          GestureDetector(
            key: _Keys.tapArea,
            onTap: () {
              setState(() => status = 'Single tapped');
            },
            onDoubleTap: () {
              setState(() => status = 'Double tapped');
            },
            child: const Text('Tap area'),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:taptest/src/private/tap_test_failure.dart';
import 'package:taptest/taptest.dart';

void main() {
  final config = Config(
    builder: (params) => const MaterialApp(
      home: _Screen(
        key: _Keys.screen,
      ),
    ),
  );

  const String objectReplacementCharacter = '\uFFFC';

  tapTest('expect text', config, (tester) async {
    // Ensure the app displays the expected screen (good general practice)
    await tester.exists(_Keys.screen);

    // Verify `Text` widget
    await tester.expectText(_Keys.simpleText, 'Simple text');

    // Verify `RichText` widget
    await tester.expectText(_Keys.richText, 'This is rich text');

    // Verify `RichText` widget containing non-text Span
    await tester.expectText(_Keys.richTextWithWidget, 'This is ${objectReplacementCharacter}rich text');

    // `_Keys.screen` doesn't represent a textual widget, so this will throw an exception
    expect(
      () => tester.expectText(_Keys.screen, 'That will throw an exception'),
      throwsA(
        isA<TapTestFailure>().having((e) => e.retriable, '', false),
      ),
    );
  });
}

// --- Below is the app being tested with the test(s) above ---

abstract class _Keys {
  static const screen = ValueKey('screen');
  static const simpleText = ValueKey('simpleText');
  static const richText = ValueKey('richText');
  static const richTextWithWidget = ValueKey('richTextWithWidget');
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
          Text('Simple text', key: _Keys.simpleText),
          RichText(
            key: _Keys.richText,
            text: TextSpan(
              children: [
                const TextSpan(text: 'This '),
                TextSpan(text: 'is '),
                TextSpan(
                  text: 'rich text',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          RichText(
            key: _Keys.richTextWithWidget,
            text: TextSpan(
              children: [
                const TextSpan(text: 'This '),
                TextSpan(text: 'is '),
                WidgetSpan(child: Icon(Icons.star)),
                TextSpan(
                  text: 'rich text',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

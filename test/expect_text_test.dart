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

  tapTest('expect text', config, (tt) async {
    // Ensure the app displays the expected screen (good general practice)
    await tt.exists(_Keys.screen);

    // Verify `Text` widget
    await tt.expectText(_Keys.simpleText, 'Simple text');

    // Verify `RichText` widget
    await tt.expectText(_Keys.richText, 'This is rich text');

    // Verify `RichText` widget containing non-text Span
    await tt.expectText(_Keys.richTextWithWidget, 'This is ${objectReplacementCharacter}rich text');

    // `_Keys.screen` doesn't represent a textual widget, so this will throw an exception
    expect(
      () => tt.expectText(_Keys.screen, 'That will throw an exception'),
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

class _Screen extends StatelessWidget {
  const _Screen({super.key});

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

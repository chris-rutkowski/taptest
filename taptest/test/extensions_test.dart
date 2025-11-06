import 'package:flutter/material.dart';
import 'package:taptest/taptest.dart';

void main() {
  final config = Config(
    extensions: [
      _RemoteText('Initial text'),
    ],
    builder: (params) => MaterialApp(
      home: _Screen(
        key: _Keys.screen,
        remoteText: params.extension<_RemoteText>()!,
      ),
    ),
  );

  tapTest('extensions', config, (tt) async {
    // Ensure the app displays the expected screen (good general practice)
    await tt.exists(_Keys.screen);

    // Verify initial state
    await tt.expectText(_Keys.remoteTextLabel, 'Initial text');

    // Update and verify
    await tt.updateRemoteText('Updated text');
    await tt.expectText(_Keys.remoteTextLabel, 'Updated text');
  });
}

extension _TapTesterRemoteTextExtension on TapTester {
  Future<void> updateRemoteText(String newValue) async {
    final remoteText = config.extension<_RemoteText>();
    remoteText.update(newValue);
    await widgetTester.pump();
  }
}

// --- Below is the app being tested with the test(s) above ---

abstract class _Keys {
  static const screen = ValueKey('screen');
  static const remoteTextLabel = ValueKey('remoteTextLabel');
}

final class _RemoteText extends ValueNotifier<String> {
  _RemoteText(super.value);

  void update(String newValue) {
    value = newValue;
  }
}

final class _Screen extends StatelessWidget {
  final _RemoteText remoteText;

  const _Screen({
    super.key,
    required this.remoteText,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Remote Text Screen'),
      ),
      body: Center(
        child: ValueListenableBuilder(
          valueListenable: remoteText,
          builder: (context, value, _) {
            return Text(
              value,
              key: _Keys.remoteTextLabel,
            );
          },
        ),
      ),
    );
  }
}

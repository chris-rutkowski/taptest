import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:taptest/taptest.dart';

void main() {
  final config = Config(
    builder: (context, _) => const MaterialApp(
      home: _Screen(),
    ),
  );

  tapTest('Disappearing - wait', config, (tt) async {
    await tt.exists(_Keys.screen);
    await tt.exists(_Keys.widget);
    await tt.wait(const Duration(seconds: 2));
    await tt.absent(_Keys.widget, timeout: Duration.zero);
  });

  tapTest('Disappearing - absent timeout', config, (tt) async {
    await tt.exists(_Keys.screen);
    await tt.exists(_Keys.widget);
    await tt.absent(_Keys.widget, timeout: Duration(seconds: 3));
  });

  tapTest('Disappearing - wait too short', config, (tt) async {
    await tt.exists(_Keys.screen);
    await tt.exists(_Keys.widget);
    await tt.wait(const Duration(seconds: 1));

    await expectLater(
      () => tt.absent(_Keys.widget, timeout: Duration.zero),
      throwsA(
        isA<TestFailure>(),
      ),
    );

    // depletes the pending timer
    await tt.wait(const Duration(seconds: 1));
  });

  tapTest('Disappearing - absent timeout too short', config, (tt) async {
    await tt.exists(_Keys.screen);
    await tt.exists(_Keys.widget);

    await expectLater(
      () => tt.absent(_Keys.widget, timeout: Duration(seconds: 1)),
      throwsA(
        isA<TestFailure>(),
      ),
    );

    // depletes the pending timer
    await tt.wait(const Duration(seconds: 1));
  });
}

// --- Below is the app being tested with the test(s) above ---

abstract class _Keys {
  static const screen = ValueKey('Screen');
  static const widget = ValueKey('Widget');
}

final class _Screen extends StatefulWidget {
  const _Screen();

  @override
  State<_Screen> createState() => _ScreenState();
}

final class _ScreenState extends State<_Screen> {
  var visible = true;

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() => visible = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _Keys.screen,
      appBar: AppBar(title: const Text('Disappearing')),
      body: visible
          ? Center(
              child: Text(
                'Widget',
                key: _Keys.widget,
              ),
            )
          : null,
    );
  }
}

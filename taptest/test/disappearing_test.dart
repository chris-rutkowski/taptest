import 'package:flutter/material.dart';
import 'package:taptest/taptest.dart';

void main() {
  final config = Config(
    builder: (params) => const MaterialApp(
      home: _Screen(),
    ),
  );

  tapTest('Disappearing', config, (tester) async {
    await tester.exists(_Keys.screen);
    await tester.exists(_Keys.widget);
    await tester.wait(const Duration(seconds: 2));
    await tester.absent(_Keys.widget);
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

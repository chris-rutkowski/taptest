import 'package:flutter/material.dart';
import 'package:taptest/taptest.dart';

void main() {
  final config = Config(
    timeDilation: 1,
    builder: (params) => MaterialApp(
      home: AnimationScreen(),
    ),
  );

  tapTest('Animation', config, (tester) async {
    await tester.exists(_Keys.screen);
    await tester.expectText(_Keys.valueLabel, 'Value: 0.00');

    await tester.tap(_Keys.startButton, sync: SyncType.skip);
    await tester.expectText(_Keys.valueLabel, 'Value: 0.00');

    await tester.wait(const Duration(milliseconds: 50));
    await tester.expectText(_Keys.valueLabel, 'Value: 0.05');

    await tester.wait(const Duration(milliseconds: 100));
    await tester.expectText(_Keys.valueLabel, 'Value: 0.15');

    await tester.settle();
    await tester.expectText(_Keys.valueLabel, 'Value: 1.00');
  });
}

abstract class _Keys {
  static const screen = ValueKey('Screen');
  static const startButton = ValueKey('StartButton');
  static const valueLabel = ValueKey('ValueLabel');
}

final class AnimationScreen extends StatefulWidget {
  const AnimationScreen({super.key});

  @override
  State<AnimationScreen> createState() => _AnimationScreenState();
}

final class _AnimationScreenState extends State<AnimationScreen> with SingleTickerProviderStateMixin {
  late final AnimationController controller;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _Keys.screen,
      appBar: AppBar(
        title: const Text('Animation'),
        actions: [
          IconButton(
            key: _Keys.startButton,
            onPressed: () => controller.forward(from: 0),
            icon: const Icon(Icons.play_arrow),
          ),
        ],
      ),
      body: Center(
        child: AnimatedBuilder(
          animation: controller,
          builder: (context, _) {
            return Text(
              'Value: ${controller.value.toStringAsFixed(2)}',
              key: _Keys.valueLabel,
            );
          },
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import 'dummy_keys.dart';

final class DummyScreen extends StatelessWidget {
  const DummyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: DummyKeys.screen,
      appBar: AppBar(
        title: const Text('Dummy screen'),
      ),
      body: Center(
        child: Text(
          'Dummy',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import 'limitations_keys.dart';

final class LimitationsScreen extends StatelessWidget {
  const LimitationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: LimitationsKeys.screen,
      appBar: AppBar(
        title: const Text('Limitations'),
      ),
      body: ListTile(
        title: const Text('Emojis display as tofu boxes during widget tests'),
        subtitle: const Text('smiley: 😊, UK Flag: 🇬🇧'),
      ),
    );
  }
}

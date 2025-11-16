import 'package:flutter/material.dart';

import 'about_keys.dart';

final class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: AboutKeys.screen,
      appBar: AppBar(
        title: const Text('About'),
      ),
      body: const Center(
        child: Text('This is the About Screen'),
      ),
    );
  }
}

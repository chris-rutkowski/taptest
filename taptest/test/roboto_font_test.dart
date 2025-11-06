import 'package:flutter/material.dart';
import 'package:taptest/taptest.dart';

void main() {
  const key = ValueKey('screen');

  final config = Config(
    builder: (params) => MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        key: key,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: FontWeight.values
                .map(
                  (weight) => Text(
                    'Roboto-${weight.toString().split('.').last}',
                    style: TextStyle(fontWeight: weight),
                  ),
                )
                .toList(),
          ),
        ),
      ),
    ),
  );

  tapTest('Roboto font', config, (tt) async {
    // Ensure the app displays the expected screen (good general practice)
    await tt.exists(key);

    // Verify fonts via snapshot
    await tt.snapshot('screen');
  });
}

import 'package:example/example_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

void main() {
  // timeDilation = 5;
  usePathUrlStrategy();

  runApp(
    const ProviderScope(
      child: ExampleApp(),
    ),
  );
}

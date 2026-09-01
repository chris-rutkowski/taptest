import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:material_ui/material_ui.dart';

import 'example_app.dart';

void main() {
  // timeDilation = 5;
  usePathUrlStrategy();

  runApp(
    const ProviderScope(
      child: ExampleApp(),
    ),
  );
}

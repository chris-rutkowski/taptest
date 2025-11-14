import 'dart:io';

import 'package:example/example_app.dart';
import 'package:example/widgets/common_keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taptest/taptest.dart';

final defaultIntegrationTapTesterConfig = Config(
  snapshot: SnapshotConfig(
    isEnabled: () {
      if (Platform.isAndroid) {
        return false;
      }

      return true;
    },
    deferredKeys: [
      CommonKeys.loadingNetworkImage,
    ],
  ),
  variants: [
    const Variant(name: 'en_light'),
    const Variant(name: 'en_dark', themeMode: ThemeMode.dark),
    const Variant(name: 'en_us_light', locale: Locale('en', 'US')),
    const Variant(name: 'en_us_dark', locale: Locale('en', 'US'), themeMode: ThemeMode.dark),
    const Variant(name: 'es_light', locale: Locale('es')),
    const Variant(name: 'es_dark', locale: Locale('es'), themeMode: ThemeMode.dark),
  ],
  builder: (context, _) {
    SharedPreferences.setMockInitialValues({});

    final providerContainer = ProviderContainer(
      overrides: [
        // ...overrides,
        // analyticsProvider.overrideWithValue(_analytics),
      ],
    );

    return UncontrolledProviderScope(
      container: providerContainer,
      child: const ExampleApp(),
    );
  },
);

import 'dart:io';

import 'package:example/example_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taptest/taptest.dart';

final defaultTapTesterConfig = Config(
  variants: [
    // en, light and dark
    const Variant(),
    const Variant(themeMode: ThemeMode.dark),
    // en-US, light and dark
    const Variant(locale: Locale('en', 'US')),
    const Variant(locale: Locale('en', 'US'), themeMode: ThemeMode.dark),
    // es, light and dark
    const Variant(locale: Locale('es')),
    const Variant(locale: Locale('es'), themeMode: ThemeMode.dark),
  ],
  customFonts: [
    CustomFont(familyName: 'NotoSans', file: 'assets/fonts/noto_sans.ttf'),
  ],
  snapshot: SnapshotConfig(
    isEnabled: () {
      if (Platform.isAndroid) {
        return false;
      }

      return true;
    },
  ),
  builder: (params) {
    SharedPreferences.setMockInitialValues({});
    // StubableNetworkImage.stubBuilder = defaultWidgetQRStubBuilder;

    final providerContainer = ProviderContainer(
      overrides: [
        // ...overrides,
        // analyticsProvider.overrideWithValue(_analytics),
      ],
    );

    return UncontrolledProviderScope(
      container: providerContainer,
      child: ListenableBuilder(
        listenable: Listenable.merge([params.themeMode, params.locale]),
        builder: (context, child) {
          return ExampleApp(
            themeMode: params.themeMode.value,
            locale: params.locale.value,
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  },
);

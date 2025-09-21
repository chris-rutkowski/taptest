import 'package:example/example_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taptest/taptest.dart';

final defaultTapTesterConfig = Config(
  screenSize: const Size(390, 844),
  customFonts: [
    CustomFont(familyName: 'NotoSans', file: 'assets/fonts/noto_sans.ttf'),
  ],
  locales: [
    const Locale('en'),
    const Locale('en', 'US'),
    const Locale('es'),
  ],
  builder: (themeMode, locale) {
    SharedPreferences.setMockInitialValues({});

    final providerContainer = ProviderContainer(
      overrides: [
        // ...overrides,
        // analyticsProvider.overrideWithValue(_analytics),
      ],
    );

    return UncontrolledProviderScope(
      container: providerContainer,
      child: ListenableBuilder(
        listenable: Listenable.merge([themeMode, locale]),
        builder: (context, child) {
          return ExampleApp(
            themeMode: themeMode.value,
            locale: locale.value,
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  },
);

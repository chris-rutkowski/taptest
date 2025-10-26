import 'package:flutter/material.dart';
import 'package:taptest_runtime/taptest_runtime.dart';

import '../networking/mock_http_request_handler.dart';
import 'custom_font.dart';
import 'snapshot_config.dart';

final class Config {
  final String? suite;
  final String? initialRoute; // TODO: consider '/'
  final double pixelDensity;
  final Size screenSize;
  final Iterable<CustomFont> customFonts;
  final SnapshotConfig snapshot;
  final List<ThemeMode> themeModes;
  final List<Locale> locales;
  final Iterable<MockHttpRequestHandler> httpRequestHandlers;
  final Iterable<ImageProvider> precachedImages;
  final Widget Function(RuntimeParams params) builder;

  Config({
    this.suite,
    this.initialRoute,
    this.pixelDensity = 2.0,
    this.screenSize = const Size(393, 852),
    this.customFonts = const [],
    this.snapshot = const SnapshotConfig(),
    this.themeModes = const [ThemeMode.light, ThemeMode.dark],
    this.locales = const [Locale('en'), Locale('en', 'US'), Locale('en', 'GB')],
    this.httpRequestHandlers = const [],
    this.precachedImages = const [],
    required this.builder,
  }) : assert(themeModes.isNotEmpty, 'themeModes must contain at least one ThemeMode'),
       assert(locales.isNotEmpty, 'locales must contain at least one Locale');

  Config copyWith({
    String? suite,
    String? initialRoute,
    double? pixelDensity,
    Size? screenSize,
    double? screenHeight,
    Iterable<CustomFont>? customFonts,
    SnapshotConfig? snapshot,
    List<ThemeMode>? themeModes,
    List<Locale>? locales,
    Iterable<MockHttpRequestHandler>? httpRequestHandlers,
    Iterable<ImageProvider>? precachedImages,
    Widget Function(RuntimeParams params)? builder,
  }) {
    assert((themeModes ?? this.themeModes).isNotEmpty, 'themeModes must contain at least one ThemeMode');
    assert((locales ?? this.locales).isNotEmpty, 'locales must contain at least one Locale');

    return Config(
      suite: suite ?? this.suite,
      initialRoute: initialRoute ?? this.initialRoute,
      pixelDensity: pixelDensity ?? this.pixelDensity,
      screenSize: (screenSize ?? this.screenSize).copyWith(
        height: screenHeight,
      ),
      customFonts: customFonts ?? this.customFonts,
      snapshot: snapshot ?? this.snapshot,
      themeModes: themeModes ?? this.themeModes,
      locales: locales ?? this.locales,
      httpRequestHandlers: httpRequestHandlers ?? this.httpRequestHandlers,
      precachedImages: precachedImages ?? this.precachedImages,
      builder: builder ?? this.builder,
    );
  }
}

extension on Size {
  Size copyWith({double? height}) {
    return Size(width, height ?? this.height);
  }
}

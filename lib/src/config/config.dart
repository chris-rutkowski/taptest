import 'package:flutter/material.dart';
import 'package:taptest_runtime/taptest_runtime.dart';

import '../logger/console_tap_tester_logger.dart';
import '../logger/tap_tester_logger.dart';
import '../networking/mock_http_request_handler.dart';
import 'custom_font.dart';
import 'snapshot_config.dart';
import 'variant.dart';

Iterable<MockHttpRequestHandler> _emptyHttpRequestHandlers() => [];
typedef TapTestBuilder = Widget Function(BuildContext context, TapTestRuntimeData runtime);

final class Config {
  final TapTesterLoggerFactory loggerFactory;
  final double timeDilation;
  final List<Variant> variants;
  final String? initialRoute;
  final double pixelDensity;
  final Iterable<CustomFont> customFonts;
  final SnapshotConfig snapshot;
  final Iterable<MockHttpRequestHandler> Function() httpRequestHandlers;
  final Iterable<ImageProvider> precachedImages;
  final Iterable<dynamic> extensions;
  final TapTestBuilder builder;

  const Config({
    this.loggerFactory = defaultLoggerFactory,
    this.timeDilation = 0.01,
    this.variants = const [Variant(name: Variant.defaultLightName)],
    this.initialRoute,
    this.pixelDensity = 2.0,
    this.customFonts = const [],
    this.snapshot = const SnapshotConfig(),
    this.httpRequestHandlers = _emptyHttpRequestHandlers,
    this.precachedImages = const [],
    this.extensions = const [],
    required this.builder,
  });

  T extension<T>() => extensions.whereType<T>().first;

  Config copyWith({
    TapTesterLoggerFactory? loggerFactory,
    double? timeDilation,
    List<Variant>? variants,
    String? initialRoute,
    double? pixelDensity,
    Iterable<CustomFont>? customFonts,
    SnapshotConfig? snapshot,
    List<ThemeMode>? themeModes,
    List<Locale>? locales,
    Iterable<MockHttpRequestHandler> Function()? httpRequestHandlers,
    Iterable<ImageProvider>? precachedImages,
    Iterable<dynamic>? extensions,
    TapTestBuilder? builder,
  }) {
    return Config(
      loggerFactory: loggerFactory ?? this.loggerFactory,
      timeDilation: timeDilation ?? this.timeDilation,
      variants: variants ?? this.variants,
      initialRoute: initialRoute ?? this.initialRoute,
      pixelDensity: pixelDensity ?? this.pixelDensity,
      customFonts: customFonts ?? this.customFonts,
      snapshot: snapshot ?? this.snapshot,
      httpRequestHandlers: httpRequestHandlers ?? this.httpRequestHandlers,
      precachedImages: precachedImages ?? this.precachedImages,
      extensions: extensions ?? this.extensions,
      builder: builder ?? this.builder,
    );
  }
}

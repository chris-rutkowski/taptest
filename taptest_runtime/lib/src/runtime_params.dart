import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Runtime parameters provided by TapTest to adjust your app during testing.
final class RuntimeParams {
  /// Change notifier providing requested theme mode.
  final ValueListenable<ThemeMode> themeMode;

  /// Change notifier providing requested locale.
  final ValueListenable<Locale> locale;

  /// Initial route to start the app with.
  final String? initialRoute;

  /// Additional extensions provided by TapTester.
  final Iterable<dynamic> extensions;

  /// Retrieves the first extension of type [T], or null if none found.
  T? extension<T>() => extensions.whereType<T>().firstOrNull;

  /// Creates a new instance of [RuntimeParams].
  const RuntimeParams({
    required this.themeMode,
    required this.locale,
    required this.initialRoute,
    required this.extensions,
  });
}

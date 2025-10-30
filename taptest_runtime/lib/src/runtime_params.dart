import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

final class RuntimeParams {
  final ValueListenable<ThemeMode> themeMode;
  final ValueListenable<Locale> locale;
  final String? initialRoute; // todo maybe '/'
  final Iterable<dynamic> extensions;

  T? extension<T>() => extensions.whereType<T>().firstOrNull;

  const RuntimeParams({
    required this.themeMode,
    required this.locale,
    required this.initialRoute,
    required this.extensions,
  });
}

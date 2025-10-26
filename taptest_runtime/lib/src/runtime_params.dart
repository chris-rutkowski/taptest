import 'package:flutter/material.dart';

final class RuntimeParams {
  final ThemeMode themeMode;
  final Locale locale;
  final String? initialRoute; // todo maybe '/'

  const RuntimeParams({
    required this.themeMode,
    required this.locale,
    required this.initialRoute,
  });
}

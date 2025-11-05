import 'package:flutter/material.dart';

final class Variant {
  final Size screenSize;
  final Locale locale;
  final ThemeMode themeMode;

  const Variant({
    this.screenSize = const Size(393, 852),
    this.locale = const Locale('en'),
    this.themeMode = ThemeMode.light,
  });

  Variant copyWith({
    Size? screenSize,
    Locale? locale,
    ThemeMode? themeMode,
  }) {
    return Variant(
      screenSize: screenSize ?? this.screenSize,
      locale: locale ?? this.locale,
      themeMode: themeMode ?? this.themeMode,
    );
  }
}

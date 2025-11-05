import 'package:flutter/material.dart';

final class Variant {
  static const defaultLightName = 'light';
  static const defaultDarkName = 'dark';

  final String? name;
  final Size screenSize;
  final Locale locale;
  final ThemeMode themeMode;

  const Variant({
    this.name,
    this.screenSize = const Size(393, 852),
    this.locale = const Locale('en'),
    this.themeMode = ThemeMode.light,
  });

  Variant copyWith({
    String? Function()? name,
    Size? screenSize,
    Locale? locale,
    ThemeMode? themeMode,
  }) {
    return Variant(
      name: name != null ? name() : this.name,
      screenSize: screenSize ?? this.screenSize,
      locale: locale ?? this.locale,
      themeMode: themeMode ?? this.themeMode,
    );
  }

  static List<Variant> get lightAndDarkVariants {
    return [
      const Variant(
        name: Variant.defaultLightName,
        themeMode: ThemeMode.light,
      ),
      const Variant(
        name: Variant.defaultDarkName,
        themeMode: ThemeMode.dark,
      ),
    ];
  }
}

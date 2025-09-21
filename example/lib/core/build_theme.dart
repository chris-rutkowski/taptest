import 'package:flutter/material.dart';

ThemeData buildTheme(BuildContext context, Brightness brightness) {
  final base = brightness == Brightness.light ? ThemeData.light() : ThemeData.dark();
  final textColor = brightness == Brightness.light ? Colors.black : Colors.white;

  return base.copyWith(
    textTheme: TextTheme(
      headlineSmall: TextStyle(
        fontSize: 24,
        fontFamily: 'NotoSans',
        color: textColor,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        fontFamily: 'NotoSans',
        color: textColor,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontFamily: 'NotoSans',
        color: textColor,
      ),
    ),
    appBarTheme: ThemeData.light().appBarTheme.copyWith(
      titleTextStyle: TextStyle(
        fontSize: 22,
        fontFamily: 'NotoSans',
        color: textColor,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      hintStyle: TextStyle(
        fontFamily: 'NotoSans',
        color: textColor,
      ),
    ),
    // splashFactory: InkRipple.splashFactory,
    splashFactory: base.platform == TargetPlatform.iOS ? NoSplash.splashFactory : InkRipple.splashFactory,
  );
}

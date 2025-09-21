import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/build_theme.dart';
import 'core/router/router.dart';
import 'l10n/app_localizations.dart';

final class ExampleApp extends ConsumerWidget {
  final ThemeMode? themeMode;
  final Locale? locale;
  final bool debugShowCheckedModeBanner;

  const ExampleApp({
    super.key,
    this.themeMode,
    this.locale,
    this.debugShowCheckedModeBanner = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTextHeightBehavior(
      textHeightBehavior: const TextHeightBehavior(
        applyHeightToFirstAscent: false,
        applyHeightToLastDescent: false,
      ),
      child: MaterialApp.router(
        debugShowCheckedModeBanner: debugShowCheckedModeBanner,
        title: 'Taptest Example app',
        locale: locale,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: buildTheme(context, Brightness.light),
        darkTheme: buildTheme(context, Brightness.dark),
        themeMode: themeMode ?? ThemeMode.system,
        routerConfig: ref.read(routerProvider),
      ),
    );
  }
}

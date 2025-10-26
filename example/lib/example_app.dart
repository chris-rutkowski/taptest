import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/build_theme.dart';
import 'core/router/router.dart';
import 'l10n/app_localizations.dart';
import 'package:taptest_runtime/taptest_runtime.dart';

final class ExampleApp extends ConsumerWidget {
  final RuntimeParams? params;
  final bool debugShowCheckedModeBanner;

  const ExampleApp({
    super.key,
    this.params,
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
        locale: params?.locale,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: buildTheme(context, Brightness.light),
        darkTheme: buildTheme(context, Brightness.dark),
        themeMode: params?.themeMode ?? ThemeMode.system,
        routerConfig: ref.read(routerProvider),
      ),
    );
  }
}

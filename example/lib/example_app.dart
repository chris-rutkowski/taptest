import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taptest_runtime/taptest_runtime.dart';

import 'core/build_theme.dart';
import 'core/router/router.dart';
import 'l10n/app_localizations.dart';

final class ExampleApp extends ConsumerWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTextHeightBehavior(
      textHeightBehavior: const TextHeightBehavior(
        applyHeightToFirstAscent: false,
        applyHeightToLastDescent: false,
      ),
      child: MaterialApp.router(
        debugShowCheckedModeBanner: TapTestRuntime.of(context) != null,
        title: 'Taptest Example app',
        locale: TapTestRuntime.of(context)?.locale,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: buildTheme(context, Brightness.light),
        darkTheme: buildTheme(context, Brightness.dark),
        themeMode: TapTestRuntime.of(context)?.themeMode,
        routerConfig: ref.read(routerProvider),
      ),
    );
  }
}

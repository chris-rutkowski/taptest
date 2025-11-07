import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:meta/meta.dart';
import 'package:taptest_runtime/taptest_runtime.dart';

import 'config/config.dart';
import 'config/variant.dart';
import 'logger/tap_tester_log_type.dart';
import 'logger/tap_tester_logger.dart';
import 'networking/mockable_http_overrides.dart';
import 'private/app_wrapper.dart';
import 'private/load_custom_fonts.dart';
import 'private/load_material_icons_font.dart';
import 'private/load_roboto_font.dart';
import 'private/snapshot_comparator.dart';
import 'private/tap_test_failure.dart';
import 'private/test_type.dart';
import 'private/validate_config.dart';
import 'sync_type.dart';
import 'tap_key.dart';

part 'tap_tester_actions/absent.dart';
part 'tap_tester_actions/change_locale.dart';
part 'tap_tester_actions/change_theme_mode.dart';
part 'tap_tester_actions/exists.dart';
part 'tap_tester_actions/expect_text.dart';
part 'tap_tester_actions/go.dart';
part 'tap_tester_actions/info.dart';
part 'tap_tester_actions/pop.dart';
part 'tap_tester_actions/scroll_to.dart';
part 'tap_tester_actions/settle.dart';
part 'tap_tester_actions/snapshot.dart';
part 'tap_tester_actions/tap.dart';
part 'tap_tester_actions/type.dart';
part 'tap_tester_actions/wait.dart';

const _singleFrameDuration = Duration(milliseconds: 17);

typedef TapTesterCallback = Future<void> Function(TapTester tt);

@isTest
void tapTest(String description, Config config, TapTesterCallback callback, {bool? skip}) {
  testWidgets(description, (widgetTester) async {
    validateConfig(config);

    timeDilation = config.timeDilation;

    try {
      final logger = config.loggerFactory();

      for (final (index, variant) in config.variants.indexed) {
        if (index > 0) {
          logger.log(
            TapTesterLogType.info,
            'Changing variant to screenSize=${variant.screenSize}, locale=${variant.locale}, themeMode=${variant.themeMode}',
          );
        }

        final tt = await TapTester._bootstrap(widgetTester, description, logger, config, variant);
        await callback(tt);
      }
    } catch (e) {
      rethrow;
    } finally {
      timeDilation = 1;
    }
  }, skip: skip);
}

final class TapTester {
  final TapTesterLogger logger;
  final TestType testType;
  final WidgetTester widgetTester;
  final String description;
  final Config config;
  final Variant variant;
  final ValueNotifier<ThemeMode> _themeModeNotifier;
  final ValueNotifier<Locale> _localeNotifier;

  const TapTester._(
    this.logger,
    this.testType,
    this.widgetTester,
    this.description,
    this.config,
    this.variant,
    this._themeModeNotifier,
    this._localeNotifier,
  );

  static Future<TapTester> _bootstrap(
    WidgetTester widgetTester,
    String description,
    TapTesterLogger logger,
    Config config,
    Variant variant,
  ) async {
    final testType = getTestType();

    if (testType == TestType.integration) {
      IntegrationTestWidgetsFlutterBinding.ensureInitialized();
    } else {
      widgetTester.view.devicePixelRatio = config.pixelDensity;
      widgetTester.view.physicalSize = variant.screenSize * config.pixelDensity;
    }

    HttpOverrides.global = MockableHttpOverrides(
      testType: testType,
      handlers: config.httpRequestHandlers,
    );

    if (testType == TestType.widget) {
      await loadCustomFonts(config.customFonts);
      await loadMaterialIconsFont();
      await loadRobotoFont();
    }

    final themeModeNotifier = ValueNotifier<ThemeMode>(variant.themeMode);
    final localeNotifier = ValueNotifier<Locale>(variant.locale);

    if (config.precachedImages.isNotEmpty) {
      await widgetTester.runAsync(() {
        return Future.wait(
          config.precachedImages.map(
            (e) => precacheImage(e, widgetTester.binding.rootElement!),
          ),
        );
      });
    }

    await widgetTester.pumpWidget(
      AppWrapper(
        key: UniqueKey(),
        child: config.builder(
          RuntimeParams(
            themeMode: themeModeNotifier,
            locale: localeNotifier,
            initialRoute: config.initialRoute,
            extensions: config.extensions,
          ),
        ),
      ),
    );

    await widgetTester.pumpAndSettle();

    return TapTester._(
      logger,
      testType,
      widgetTester,
      description,
      config,
      variant,
      themeModeNotifier,
      localeNotifier,
    );
  }

  Finder _finder(TapKey keyOrKeys) {
    if (keyOrKeys is Key) {
      return find.byKey(keyOrKeys);
    }

    if (keyOrKeys is List<Key>) {
      var current = find.byKey(keyOrKeys.first);

      for (var i = 1; i < keyOrKeys.length; i++) {
        current = find.descendant(of: current, matching: find.byKey(keyOrKeys[i]));
      }

      return current;
    }

    throw ArgumentError();
  }

  Future _sync(SyncType sync) {
    switch (sync) {
      case SyncType.instant:
        return widgetTester.pump();
      case SyncType.settled:
        return widgetTester.pumpAndSettle();
      case SyncType.skip:
        return Future.value();
    }
  }

  String _formatKey(TapKey keyOrKeys) {
    if (keyOrKeys is Key) {
      return keyOrKeys.formatted;
    }

    if (keyOrKeys is List<Key>) {
      return keyOrKeys.map((key) => key.formatted).join('>');
    }

    throw ArgumentError();
  }

  Future<T> _expectWithTimeout<T>(
    Future<T> Function() expectation,
    String message,
    Duration timeout, {
    Duration retryDelay = _singleFrameDuration,
  }) async {
    var remaining = timeout;
    var firstCheck = true;

    while (true) {
      if (firstCheck) {
        logger.log(TapTesterLogType.stepInProgress, message);
      } else {
        logger.log(
          TapTesterLogType.stepInProgress,
          '$message (${remaining.inMilliseconds}ms remaining)',
        );
      }

      try {
        return await expectation();
      } catch (e) {
        remaining -= retryDelay;

        if (e is TapTestFailure && !e.retriable) {
          rethrow;
        }

        if (timeout <= Duration.zero || remaining.isNegative) {
          rethrow;
        }

        await widgetTester.pump(retryDelay);
        firstCheck = false;
      }
    }
  }
}

extension _KeyFormat on Key {
  String get formatted {
    final raw = toString();
    if (raw.length > 5) {
      return raw.substring(3, raw.length - 3);
    }
    return raw;
  }
}

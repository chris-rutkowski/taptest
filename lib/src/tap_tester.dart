import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:meta/meta.dart';

import 'config/config.dart';
import 'networking/mockable_http_overrides.dart';
import 'private/app_wrapper.dart';
import 'private/list_extensions.dart';
import 'private/load_custom_fonts.dart';
import 'private/load_material_icons_font.dart';
import 'private/make_test_description.dart';
import 'private/snapshot_comparator.dart';
import 'private/test_type.dart';
import 'sync_type.dart';
import 'tap_key.dart';

part 'tap_tester_actions/absent.dart';
part 'tap_tester_actions/exists.dart';
part 'tap_tester_actions/info.dart';
part 'tap_tester_actions/pop.dart';
part 'tap_tester_actions/scroll_to.dart';
part 'tap_tester_actions/snapshot.dart';
part 'tap_tester_actions/tap.dart';
part 'tap_tester_actions/text.dart';
part 'tap_tester_actions/type.dart';
part 'tap_tester_actions/wait.dart';

const _singleFrameDuration = Duration(milliseconds: 17);

typedef TapTesterCallback = Future<void> Function(TapTester tester);

@isTest
void tapTest(String name, Config config, TapTesterCallback callback) {
  final description = makeTestDescription(name, config);

  testWidgets(description, (widgetTester) async {
    timeDilation = 0.01;

    final tester = await TapTester._bootstrap(widgetTester, name, false, config);

    try {
      await callback(tester);
    } catch (e) {
      // TODO: consider snapshot on failure
      rethrow;
    } finally {
      timeDilation = 1;
    }
  });
}

final class TapTester {
  final TestType testType;
  final WidgetTester widgetTester;
  final String name;
  final Config config;
  final ValueNotifier<ThemeMode> _themeModeNotifier;
  final ValueNotifier<Locale> _localeNotifier;

  const TapTester._(
    this.testType,
    this.widgetTester,
    this.name,
    this.config,
    this._themeModeNotifier,
    this._localeNotifier,
  );

  static Future<TapTester> _bootstrap(WidgetTester widgetTester, String name, bool integration, Config config) async {
    final testType = getTestType();

    if (testType == TestType.integration) {
      IntegrationTestWidgetsFlutterBinding.ensureInitialized();
    } else {
      widgetTester.view.devicePixelRatio = config.pixelDensity;
      widgetTester.view.physicalSize = config.screenSize * config.pixelDensity;
    }

    HttpOverrides.global = MockableHttpOverrides(
      testType: testType,
      handlers: config.httpRequestHandlers,
    );

    if (testType == TestType.widget) {
      await loadCustomFonts(config.customFonts);
      await loadMaterialIconsFont();
    }

    final themeModeNotifier = ValueNotifier<ThemeMode>(config.themeModes.first);
    final localeNotifier = ValueNotifier<Locale>(config.locales.first);

    await widgetTester.pumpWidget(
      AppWrapper(
        child: config.builder(
          themeModeNotifier,
          localeNotifier,
        ),
      ),
    );

    if (config.precachedImages.isNotEmpty) {
      await widgetTester.runAsync(() async {
        final finder = find.byType(AppWrapper);

        for (final image in config.precachedImages) {
          await precacheImage(image, widgetTester.element(finder));
        }
      });
    }

    await widgetTester.pumpAndSettle();

    return TapTester._(
      testType,
      widgetTester,
      name,
      config,
      themeModeNotifier,
      localeNotifier,
    );
  }

  void _print(String message, _PrintType type, {bool overwrite = false}) {
    if (overwrite) {
      // ignore: avoid_print
      print('\x1B[1A\x1B[K${type.emoji} $message');
    } else {
      // ignore: avoid_print
      print('${type.emoji} $message');
    }
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
    final end = DateTime.now().add(timeout);
    final totalSeconds = timeout.inMilliseconds / 1000.0;

    var firstCheck = true;

    while (true) {
      final elapsed = timeout - end.difference(DateTime.now());
      final elapsedSeconds = (elapsed.inMilliseconds / 1000);

      if (firstCheck) {
        _print(message, _PrintType.inProgress);
      } else {
        _print(
          '$message ${elapsedSeconds.toStringAsFixed(2)}s/${totalSeconds.toStringAsFixed(2)}s',
          _PrintType.inProgress,
          overwrite: true,
        );
      }

      try {
        return await expectation();
      } catch (e) {
        await widgetTester.pump(retryDelay);
        firstCheck = false;

        if (DateTime.now().isAfter(end)) {
          rethrow;
        }
      }
    }
  }
}

enum _PrintType {
  info,
  inProgress,
  success,
  ignore,
}

extension _PrintTypeExtension on _PrintType {
  String get emoji {
    switch (this) {
      case _PrintType.info:
        return '💡';
      case _PrintType.inProgress:
        return '➡️';
      case _PrintType.success:
        return '✅';
      case _PrintType.ignore:
        return '🚫';
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

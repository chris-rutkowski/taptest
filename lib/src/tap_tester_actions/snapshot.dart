part of '../tap_tester.dart';

const _defaultSuiteName = 'default';
const _headlessName = 'headless';

extension TapTesterSnapshot on TapTester {
  Future<void> snapshot(
    final String name, {
    dynamic key,
    List<ThemeMode>? themeModes,
    List<Locale>? locales,
    double? acceptableDifference,
  }) async {
    if (!config.snapshot.isEnabled()) {
      _print('Skipping snapshot $name', _PrintType.ignore);
      return;
    }

    final previousGoldenFileComparator = goldenFileComparator;
    addTearDown(() => goldenFileComparator = previousGoldenFileComparator);

    ComparisonResult? worstResult;

    if (testType == TestType.widget) {
      goldenFileComparator = SnapshotComparator(
        Uri.parse('${(goldenFileComparator as LocalFileComparator).basedir}/dummy_file.dart'),
        acceptableDifference ?? config.snapshot.acceptableDifference,
        (result) {
          if (worstResult == null || result.diffPercent > worstResult!.diffPercent) {
            worstResult = result;
          }
        },
      );
    }

    _print('Checking snapshot $name', _PrintType.inProgress);

    assert(
      locales == null || locales.every((e) => config.locales.contains(e)),
      'All provided locales must be in config.locales',
    );
    assert(
      themeModes == null || themeModes.every((e) => config.themeModes.contains(e)),
      'All provided themeModes must be in config.themeModes',
    );

    final startingThemeMode = _themeModeNotifier.value;
    final startingLocale = _localeNotifier.value;

    final themeModesToUse = themeModes ?? config.themeModes;
    final localesToUse = locales ?? config.locales;

    final deviceName = await _getDeviceName();

    await themeModesToUse.cycle(
      from: themeModesToUse.first,
      callback: (theme) async {
        var shouldPumpAndSettle = false;

        if (_themeModeNotifier.value != theme) {
          _themeModeNotifier.value = theme;
          shouldPumpAndSettle = true;
        }

        await localesToUse.cycle(
          from: localesToUse.first,
          callback: (locale) async {
            if (_localeNotifier.value != locale) {
              _localeNotifier.value = locale;
              shouldPumpAndSettle = true;
            }

            if (shouldPumpAndSettle) {
              await widgetTester.pumpAndSettle();
            }

            final finder = key == null ? find.byType(AppWrapper) : _finder(key);

            Future<void> take() => expectLater(
              finder,
              matchesGoldenFile(
                _makeSnapshotPath(
                  template: config.snapshot.path,
                  suite: config.suite ?? _defaultSuiteName,
                  name: name,
                  theme: theme,
                  locale: locale,
                  device: deviceName,
                ),
              ),
            );

            try {
              await take();
            } catch (e) {
              if (e.toString().contains('!renderObject.debugNeedsPaint')) {
                await widgetTester.pumpAndSettle();
                await take();
              } else {
                rethrow;
              }
            }
          },
        );
      },
    );

    await _revertIfNeeded(themeMode: startingThemeMode, locale: startingLocale);
    if (worstResult != null && worstResult!.diffPercent > 0) {
      _print(
        'Snapshot matches $name - ${((1 - worstResult!.diffPercent) * 100).toStringAsFixed(2)}%',
        _PrintType.success,
        overwrite: true,
      );
    } else {
      _print('Snapshot matches $name', _PrintType.success, overwrite: true);
    }
  }

  Future<void> _revertIfNeeded({required ThemeMode themeMode, required Locale locale}) async {
    var shouldPumpAndSettle = false;

    if (_themeModeNotifier.value != themeMode) {
      _themeModeNotifier.value = themeMode;
      shouldPumpAndSettle = true;
    }

    if (_localeNotifier.value != locale) {
      _localeNotifier.value = locale;
      shouldPumpAndSettle = true;
    }

    if (shouldPumpAndSettle) {
      await widgetTester.pumpAndSettle();
    }
  }

  String _makeSnapshotPath({
    required String template,
    required String suite,
    required String name,
    required ThemeMode theme,
    required Locale locale,
    required String device,
  }) {
    String safe(String input) => input.replaceAll(RegExp(r'[\\/ ]'), '_');

    return template
        .replaceAll('[suite]', safe(suite))
        .replaceAll('[test]', safe(this.name)) // test name
        .replaceAll('[name]', safe(name)) // snapshot name
        .replaceAll('[theme]', safe(theme.name))
        .replaceAll('[locale]', safe(locale.toString()))
        .replaceAll('[device]', safe(device))
        .replaceAll('[platform]', safe(_getPlatform()));
  }

  String _getPlatform() {
    if (testType == TestType.widget) {
      return _headlessName;
    }

    return Platform.operatingSystem;
  }

  Future<String> _getDeviceName() async {
    if (testType == TestType.widget) {
      return _headlessName;
    }

    final deviceInfo = DeviceInfoPlugin();

    if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      return iosInfo.name;
    }

    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      return androidInfo.model;
    }

    // Fallback for other platforms
    return Platform.operatingSystem;
  }
}

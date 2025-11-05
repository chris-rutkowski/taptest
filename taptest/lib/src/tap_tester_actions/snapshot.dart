part of '../tap_tester.dart';

const _headlessName = 'headless';

extension TapTesterSnapshot on TapTester {
  Future<void> snapshot(
    final String name, {
    TapKey key,
    double? acceptableDifference,
  }) async {
    if (!config.snapshot.isEnabled()) {
      logger.log(TapTesterLogType.info, 'Skipping snapshot $name');
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

    logger.log(TapTesterLogType.stepInProgress, 'Checking snapshot $name');

    final deviceName = await _getDeviceName();
    await widgetTester.pumpAndSettle();

    await _waitForDeferredToDisappear();

    final finder = key == null ? find.byType(AppWrapper) : _finder(key);

    Future<void> take() => expectLater(
      finder,
      matchesGoldenFile(
        _makeSnapshotPath(
          template: config.snapshot.path,
          name: name,
          theme: _themeModeNotifier.value,
          locale: _localeNotifier.value,
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

    if (worstResult != null && worstResult!.diffPercent > 0) {
      logger.log(
        TapTesterLogType.stepSuccessful,
        'Snapshot matches $name - ${((1 - worstResult!.diffPercent) * 100).toStringAsFixed(2)}%',
      );
    } else {
      logger.log(TapTesterLogType.stepSuccessful, 'Snapshot matches $name');
    }
  }

  String _makeSnapshotPath({
    required String template,
    required String name,
    required ThemeMode theme,
    required Locale locale,
    required String device,
  }) {
    String safe(String? input) {
      if (input == null || input.trim().isEmpty) return '';

      return input.trim().replaceAll(RegExp(r'[\\/ ]'), '_');
    }

    return template
        .replaceAll('[test]', safe(description)) // test's description
        .replaceAll('[name]', safe(name)) // snapshot name
        .replaceAll('[variant]', safe(variant.name))
        .replaceAll('[theme]', safe(theme.name))
        .replaceAll('[locale]', safe(locale.toString()))
        .replaceAll('[device]', safe(device))
        .replaceAll('[size]', safe('${variant.screenSize.width.toInt()}x${variant.screenSize.height.toInt()}'))
        .replaceAll('[platform]', safe(_getPlatform()))
        .replaceAll(RegExp(r'/+'), '/'); // Replace multiple slashes with single slash;
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

  Future<void> _waitForDeferredToDisappear() async {
    for (final key in config.snapshot.deferredKeys) {
      await absent(key);
    }
  }
}

part of '../tap_tester.dart';

extension TapTesterChangeThemeMode on TapTester {
  Future<void> changeThemeMode(
    ThemeMode mode, {
    SyncType sync = SyncType.instant,
  }) async {
    assert(
      config.themeModes.contains(mode),
      'Provided themeMode `$mode` must be in config.themes',
    );

    _print('Changing theme to $mode', _PrintType.inProgress);

    _themeModeNotifier.value = mode;
    await _sync(sync);

    _print('Theme changed to $mode', _PrintType.success, overwrite: true);
  }
}

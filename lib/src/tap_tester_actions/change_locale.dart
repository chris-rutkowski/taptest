part of '../tap_tester.dart';

extension TapTesterChangeLocale on TapTester {
  Future<void> changeLocale(
    Locale locale, {
    SyncType sync = SyncType.instant,
  }) async {
    assert(
      config.locales.contains(locale),
      'Provided locale `$locale` must be in config.locales',
    );

    _print('Changing locale to $locale', _PrintType.inProgress);

    _localeNotifier.value = locale;
    await _sync(sync);

    _print('Locale changed to $locale', _PrintType.success, overwrite: true);
  }
}

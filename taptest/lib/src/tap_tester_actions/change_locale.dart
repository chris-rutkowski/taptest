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

    logger.log(TapTesterLogType.stepInProgress, 'Changing locale to $locale');

    _localeNotifier.value = locale;
    await _sync(sync);

    logger.log(TapTesterLogType.stepSuccessful, 'Locale changed to $locale');
  }
}

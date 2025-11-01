import 'tap_tester_log_type.dart';
import 'tap_tester_logger.dart';

TapTesterLogger defaultLoggerFactory() => ConsoleTapTesterLogger();

final class ConsoleTapTesterLogger implements TapTesterLogger {
  final bool overwriteStepInProgress;
  TapTesterLogType? _lastLogType;

  ConsoleTapTesterLogger({
    this.overwriteStepInProgress = true,
  });

  @override
  void log(TapTesterLogType type, String message) {
    if (_lastLogType == TapTesterLogType.stepInProgress && overwriteStepInProgress) {
      // ignore: avoid_print
      print('\x1B[1A\x1B[K${type.emoji} $message');
    } else {
      // ignore: avoid_print
      print('${type.emoji} $message');
    }

    _lastLogType = type;
  }
}

extension on TapTesterLogType {
  String get emoji {
    switch (this) {
      case TapTesterLogType.info:
        return '💡';
      case TapTesterLogType.stepInProgress:
        return '➡️';
      case TapTesterLogType.stepSuccessful:
        return '✅';
      case TapTesterLogType.stepIgnored:
        return '🚫';
      case TapTesterLogType.warning:
        return '⚠️';
    }
  }
}

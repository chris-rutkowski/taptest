import 'tap_tester_log_type.dart';

typedef TapTesterLoggerFactory = TapTesterLogger Function();

abstract class TapTesterLogger {
  void log(TapTesterLogType type, String message);
}

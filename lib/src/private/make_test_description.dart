import '../config/config.dart';

String makeTestDescription(String name, Config config) {
  if (config.suite != null) {
    return '${config.suite}: $name';
  }

  return name;
}

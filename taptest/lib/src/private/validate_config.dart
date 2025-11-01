import '../config/config.dart';

void validateConfig(Config config) {
  if (config.themeModes.isEmpty) {
    throw ArgumentError('themeModes must contain at least one ThemeMode');
  }

  if (config.locales.isEmpty) {
    throw ArgumentError('locales must contain at least one Locale');
  }
}

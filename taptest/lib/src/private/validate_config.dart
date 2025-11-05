import '../config/config.dart';

void validateConfig(Config config) {
  if (config.variants.isEmpty) {
    throw ArgumentError('variants must contain at least one Variant');
  }
}

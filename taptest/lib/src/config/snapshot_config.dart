import '../tap_key.dart';

/// Snapshot configuration
final class SnapshotConfig {
  /// Path where snapshots will be saved.
  ///
  /// Available placeholders in [path]:
  /// - [test]: Test's description
  /// - [name]: Snapshot name
  /// - [variant]: Variant name
  /// - [theme]: Theme mode (light/dark)
  /// - [locale]: Locale (e.g., en, en_US)
  /// - [device]: Device model (e.g., iPhone_16_Pro, Pixel_9_Pro, headless for unit tests)
  /// - [platform]: Platform (e.g., ios, android)
  /// - [size]: Screen size (e.g., 393x852)
  final String path;
  final bool Function() isEnabled;
  final double acceptableDifference;

  /// Widgets identified by these keys must disappear before the snapshot is taken (e.g. placeholders for network images).
  final Iterable<TapKey> deferredKeys;

  const SnapshotConfig({
    this.path = 'snapshots/[test]/[variant]/[name].png',
    this.isEnabled = _true,
    this.acceptableDifference = 0.0002,
    this.deferredKeys = const [],
  });

  static bool _true() => true;

  SnapshotConfig copyWith({
    String? path,
    bool Function()? isEnabled,
    double? acceptableDifference,
  }) {
    return SnapshotConfig(
      path: path ?? this.path,
      isEnabled: isEnabled ?? this.isEnabled,
      acceptableDifference: acceptableDifference ?? this.acceptableDifference,
    );
  }
}

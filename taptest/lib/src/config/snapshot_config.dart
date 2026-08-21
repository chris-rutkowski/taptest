import '../tap_key.dart';

/// Snapshot configuration
final class SnapshotConfig {
  /// Path where snapshots will be saved.
  ///
  /// Available placeholders in [path]:
  /// - [suite]: Test suite name
  /// - [description]: Test's description
  /// - [name]: Snapshot name
  /// - [theme]: Theme mode (light/dark)
  /// - [locale]: Locale (e.g., en, en_US)
  /// - [device]: Device model (e.g., iPhone_16_Pro, Pixel_9_Pro, headless for unit tests)
  /// - [platform]: Platform (e.g., ios, android)
  final String path;
  final bool Function() isEnabled;

  /// Pixel-difference slack as a fraction of the image (`0.0`–`1.0`).
  ///
  /// `0` (default) uses Flutter's stock golden comparator: any differing
  /// pixel fails, and `--update-goldens` writes immediately. Values above
  /// `0` allow that fraction of pixels to differ and skip rewriting goldens
  /// already within the band.
  final double acceptableDifference;

  /// Widgets identified by these keys must disappear before the snapshot is taken (e.g. placeholders for network images).
  final Iterable<TapKey> deferredKeys;

  const SnapshotConfig({
    this.path = 'goldens/[suite]/[test]/[name]-[theme]-[locale]-[platform].png',
    this.isEnabled = _true,
    this.acceptableDifference = 0,
    this.deferredKeys = const [],
  });

  static bool _true() => true;

  SnapshotConfig copyWith({
    String? path,
    bool Function()? isEnabled,
    double? acceptableDifference,
    Iterable<TapKey>? deferredKeys,
  }) {
    return SnapshotConfig(
      path: path ?? this.path,
      isEnabled: isEnabled ?? this.isEnabled,
      acceptableDifference: acceptableDifference ?? this.acceptableDifference,
      deferredKeys: deferredKeys ?? this.deferredKeys,
    );
  }
}

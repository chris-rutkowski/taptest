/// Snapshot configuration
final class SnapshotConfig {
  /// Path where snapshots will be saved.
  ///
  /// Available placeholders in [path]:
  /// - [suite]: Test suite name
  /// - [test]: Test name
  /// - [name]: Snapshot name
  /// - [theme]: Theme mode (light/dark)
  /// - [locale]: Locale (e.g., en_US)
  /// - [device]: Device model (e.g., iPhone_16_Pro, Pixel_9_Pro, 390x844 for unit tests)
  /// - [platform]: Platform (e.g., ios, android)
  final String path;
  final bool Function() isEnabled;

  const SnapshotConfig({
    this.path = 'goldens/[suite]/[test]/[name]-[theme]-[locale]-[platform].png',
    this.isEnabled = _true,
  });

  static bool _true() => true;

  SnapshotConfig copyWith({
    String? path,
    bool Function()? isEnabled,
  }) {
    return SnapshotConfig(
      path: path ?? this.path,
      isEnabled: isEnabled ?? this.isEnabled,
    );
  }
}

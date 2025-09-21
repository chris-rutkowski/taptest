final class SnapshotConfig {
  final String path;
  final bool Function() isEnabled;

  const SnapshotConfig({
    this.path = 'goldens/[suite]/[test]/[name]-[theme]-[locale].png',
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

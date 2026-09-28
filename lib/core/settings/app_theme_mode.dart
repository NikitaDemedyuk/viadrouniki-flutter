enum AppThemeMode {
  system,
  light,
  dark;

  static AppThemeMode fromCode(String code) => values.firstWhere(
    (mode) => mode.code == code,
    orElse: () => AppThemeMode.system,
  );
}

extension AppThemeModeCode on AppThemeMode {
  /// The persisted value, spelled out rather than `name` so renaming a
  /// value doesn't silently reset a saved setting.
  String get code => switch (this) {
    AppThemeMode.system => 'system',
    AppThemeMode.light => 'light',
    AppThemeMode.dark => 'dark',
  };
}

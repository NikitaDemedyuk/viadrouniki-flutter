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
  String get code => switch (this) {
    AppThemeMode.system => 'system',
    AppThemeMode.light => 'light',
    AppThemeMode.dark => 'dark',
  };
}

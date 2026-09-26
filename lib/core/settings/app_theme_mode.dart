enum AppThemeMode {
  system,
  light,
  dark;

  static AppThemeMode fromName(String name) => values.firstWhere(
    (mode) => mode.name == name,
    orElse: () => AppThemeMode.system,
  );
}

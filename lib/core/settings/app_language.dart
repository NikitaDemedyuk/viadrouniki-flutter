enum AppLanguage {
  ru,
  be;

  static AppLanguage fromCode(String code) => values.firstWhere(
    (language) => language.code == code,
    orElse: () => AppLanguage.ru,
  );
}

extension AppLanguageCode on AppLanguage {
  /// The persisted value, spelled out rather than `name` so renaming a
  /// value doesn't silently reset a saved setting.
  String get code => switch (this) {
    AppLanguage.ru => 'ru',
    AppLanguage.be => 'be',
  };
}

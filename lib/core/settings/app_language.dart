// Keep this to exactly ru/be. A device locale outside that pair isn't a
// safe fallback: Flutter would silently pick whichever supported locale
// sorts first (be), not ru, and the API just returns Russian for any other
// locale value.
enum AppLanguage {
  ru,
  be;

  static AppLanguage fromCode(String code) => values.firstWhere(
    (language) => language.code == code,
    orElse: () => AppLanguage.ru,
  );
}

extension AppLanguageCode on AppLanguage {
  String get code => switch (this) {
    AppLanguage.ru => 'ru',
    AppLanguage.be => 'be',
  };
}

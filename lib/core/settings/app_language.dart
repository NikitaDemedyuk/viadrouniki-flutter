/// The only two locales the API and l10n support — never the device's.
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

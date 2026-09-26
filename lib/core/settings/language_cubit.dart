import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:viadrouniki/core/settings/app_language.dart';

class LanguageCubit extends Cubit<AppLanguage> {
  new(this._preferences)
    : super(
        AppLanguage.fromCode(
          _preferences.getString(_languageKey) ?? AppLanguage.ru.code,
        ),
      );

  static const _languageKey = 'language';

  final SharedPreferences _preferences;

  Future<void> setLanguage(AppLanguage language) async {
    if (language == state) return;
    await _preferences.setString(_languageKey, language.code);
    emit(language);
  }
}

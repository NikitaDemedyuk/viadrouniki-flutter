import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:viadrouniki/core/settings/app_theme_mode.dart';

class ThemeCubit extends Cubit<AppThemeMode> {
  new(this._preferences)
    : super(
        AppThemeMode.fromCode(
          _preferences.getString(_themeModeKey) ?? AppThemeMode.system.code,
        ),
      );

  static const _themeModeKey = 'theme_mode';

  final SharedPreferences _preferences;

  Future<void> setThemeMode(AppThemeMode mode) async {
    if (mode == state) return;
    await _preferences.setString(_themeModeKey, mode.code);
    emit(mode);
  }
}

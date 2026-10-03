import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:viadrouniki/core/network/api_client.dart';
import 'package:viadrouniki/core/settings/app_language.dart';
import 'package:viadrouniki/core/settings/language_cubit.dart';
import 'package:viadrouniki/core/settings/theme_cubit.dart';

final GetIt getIt = GetIt.instance;

Future<void> configureDependencies() async {
  final preferences = await SharedPreferences.getInstance();
  final languageCubit = LanguageCubit(preferences);
  getIt
    ..registerSingleton<SharedPreferences>(preferences)
    ..registerSingleton<LanguageCubit>(languageCubit)
    ..registerSingleton<ApiClient>(
      ApiClient(locale: () => languageCubit.state.code),
    )
    ..registerSingleton<ThemeCubit>(ThemeCubit(preferences));
}

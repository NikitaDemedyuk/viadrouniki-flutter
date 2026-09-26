import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:viadrouniki/core/settings/language_cubit.dart';
import 'package:viadrouniki/core/settings/theme_cubit.dart';

final GetIt getIt = GetIt.instance;

Future<void> configureDependencies() async {
  final preferences = await SharedPreferences.getInstance();
  getIt
    ..registerSingleton<SharedPreferences>(preferences)
    ..registerSingleton<LanguageCubit>(LanguageCubit(preferences))
    ..registerSingleton<ThemeCubit>(ThemeCubit(preferences));
}

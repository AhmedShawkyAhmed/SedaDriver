import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:seda_driver/src/constants/constants_variables.dart';
import 'package:seda_driver/src/constants/shared_preference_keys.dart';
import 'package:seda_driver/src/presentation/styles/app_colors.dart';
import 'package:seda_driver/src/services/cache_helper.dart';

part 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(AppInitial());

  static AppCubit get(BuildContext context) => BlocProvider.of(context);

  final _network = InternetConnectionChecker();

  late ThemeMode _themeMode;
  Locale _locale = const Locale('en');

  Locale get locale => _locale;

  ThemeMode get themeMode => _themeMode;

  ThemeData get darkTheme => _darkTheme;

  ThemeData get lightTheme => _lightTheme;

  startNetworkStream() {
    _network.onStatusChange.listen((event) {
      if (event == InternetConnectionStatus.connected) {
        emit(AppInternetConnectedState());
      } else {
        emit(AppInternetDisconnectedState());
      }
    });
  }

  Future<bool> checkNetworkState() async {
    final state =
        (await _network.connectionStatus) == InternetConnectionStatus.connected;
    return state;
  }

  final _lightTheme = ThemeData(
    brightness: Brightness.light,
    appBarTheme: const AppBarTheme(
      elevation: 0.0,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
      ),
      backgroundColor: AppColors.white,
      iconTheme: IconThemeData(
        color: AppColors.darkGrey,
      ),
    ),
  );

  final _darkTheme = ThemeData(
    brightness: Brightness.dark,
    appBarTheme: const AppBarTheme(
      elevation: 0.0,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
      ),
      backgroundColor: AppColors.darkGrey,
      iconTheme: IconThemeData(
        color: AppColors.lightGrey,
      ),
    ),
  );

  initAppCubit() {
    initLocale();
    initDarkTheme();
  }

  Future initLocale() async {
    final lang = CacheHelper.getDataFromSharedPreference(
            key: SharedPreferenceKeys.appLanguage) ??
        'en';
    _locale = Locale(lang);
    emit(AppLanguageUpdateState());
  }

  Future changeAppLanguage(Locale locale) async {
    _locale = locale;
    CacheHelper.saveDataSharedPreference(
      key: SharedPreferenceKeys.appLanguage,
      value: _locale.languageCode,
    );
    emit(AppLanguageUpdateState());
  }

  Future initDarkTheme() async {
    final isDarkTheme = CacheHelper.getDataFromSharedPreference(
          key: SharedPreferenceKeys.isDarkTheme,
        ) ??
        false;
    _themeMode = isDarkTheme ? ThemeMode.dark : ThemeMode.light;
    isDark = isDarkTheme;
    await CacheHelper.saveDataSharedPreference(
      key: SharedPreferenceKeys.isDarkTheme,
      value: isDarkTheme,
    );
    emit(AppThemeUpdateState());
  }

  Future toggleTheme() async {
    _themeMode = isDark ? ThemeMode.light : ThemeMode.dark;
    await CacheHelper.saveDataSharedPreference(
      key: SharedPreferenceKeys.isDarkTheme,
      value: _themeMode == ThemeMode.dark,
    );
    isDark = _themeMode == ThemeMode.dark;
    emit(AppThemeUpdateState());
  }
}

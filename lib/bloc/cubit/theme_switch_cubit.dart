import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeSwitchCubit extends Cubit<ThemeMode> {
  ThemeSwitchCubit() : super(ThemeMode.light);

  void setInitialTheme() async {
    bool hasThemeDark = await isDark();
    emit(hasThemeDark ? ThemeMode.dark : ThemeMode.light);
  }

  void themeSwitching() async {
    bool hasThemeDark = state == ThemeMode.dark;
    emit(hasThemeDark ? ThemeMode.light : ThemeMode.dark);
    await setTheme(!hasThemeDark);
  }
}

Future<bool> isDark() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  return sharedPreferences.getBool('is_dark') ?? false;
}

Future<void> setTheme(bool isDark) async {
  final sharedPreferences = await SharedPreferences.getInstance();
  sharedPreferences.setBool('is_dark', isDark);
}

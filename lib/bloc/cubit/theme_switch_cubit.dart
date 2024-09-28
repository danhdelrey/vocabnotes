import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeSwitchCubit extends Cubit<ThemeData> {
  ThemeSwitchCubit() : super(ThemeData.light());

  void setInitialTheme() async {
    bool hasThemeDark = await isDark();
    emit(hasThemeDark ? ThemeData.dark() : ThemeData.light());
  }

  void themeSwitching() async {
    bool hasThemeDark = state == ThemeData.dark();
    emit(hasThemeDark ? ThemeData.light() : ThemeData.dark());
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

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme_switch_state.dart';

class ThemeSwitchCubit extends Cubit<ThemeData> {
  ThemeSwitchCubit() : super(ThemeData.light());

  

}

Future<bool> isDark() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  return sharedPreferences.getBool('is_dark') ?? false;
}

Future<void> setTheme(bool isDark) async {
  final sharedPreferences = await SharedPreferences.getInstance();
  sharedPreferences.setBool('is_dark',isDark);
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:vocabnotes/app/routes.dart';
import 'package:vocabnotes/app/theme.dart';
import 'package:vocabnotes/bloc/theme_switch_cubit/theme_switch_cubit.dart';

Future<void> main() async {
  await dotenv.load();
  runApp(
    BlocProvider(
      create: (context) => ThemeSwitchCubit()..setInitialTheme(),
      child: BlocBuilder<ThemeSwitchCubit, ThemeMode>(
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: theme,
            routes: routes,
            darkTheme: darkTheme,
            themeMode: state,
          );
        },
      ),
    ),
  );
}

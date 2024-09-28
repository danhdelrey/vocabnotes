import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vocabnotes/app/routes.dart';
import 'package:vocabnotes/app/theme.dart';
import 'package:vocabnotes/bloc/cubit/theme_switch_cubit.dart';
import 'package:vocabnotes/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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

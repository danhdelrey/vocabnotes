import 'package:flutter/material.dart';

var kColorScheme = ColorScheme.fromSeed(seedColor: const Color(0xFF02b3a4));
var kDarkColorScheme = ColorScheme.fromSeed(
  seedColor: const Color(0xFF02b3a4),
  brightness: Brightness.dark,
);

final theme = ThemeData().copyWith(
  colorScheme: kColorScheme,
  appBarTheme: appBarTheme,
  textTheme: textTheme,
);

final darkTheme = ThemeData.dark().copyWith(
  colorScheme: kDarkColorScheme,
  appBarTheme: appBarDarkTheme,
  textTheme: textThemeDark,
);

var appBarTheme = const AppBarTheme().copyWith(
  centerTitle: true,
  elevation: 0,
  backgroundColor: ThemeData().scaffoldBackgroundColor,
  surfaceTintColor: ThemeData().scaffoldBackgroundColor,
);
var appBarDarkTheme = const AppBarTheme().copyWith(
  centerTitle: true,
  elevation: 0,
  backgroundColor: ThemeData.dark().scaffoldBackgroundColor,
  surfaceTintColor: ThemeData.dark().scaffoldBackgroundColor,
);


var textTheme = const TextTheme().copyWith(
  bodyLarge: const TextStyle()
      .copyWith(fontFamily: 'LTSaeada', color: kColorScheme.onSurface),
  bodyMedium: const TextStyle()
      .copyWith(fontFamily: 'LTSaeada', color: kColorScheme.onSurface),
  bodySmall: const TextStyle()
      .copyWith(fontFamily: 'LTSaeada', color: kColorScheme.onSurface),
  displayLarge: const TextStyle()
      .copyWith(fontFamily: 'LTSaeada', color: kColorScheme.onSurface),
  displayMedium: const TextStyle()
      .copyWith(fontFamily: 'LTSaeada', color: kColorScheme.onSurface),
  displaySmall: const TextStyle()
      .copyWith(fontFamily: 'LTSaeada', color: kColorScheme.onSurface),
  headlineLarge: const TextStyle()
      .copyWith(fontFamily: 'LTSaeada', color: kColorScheme.onSurface),
  headlineMedium: const TextStyle()
      .copyWith(fontFamily: 'LTSaeada', color: kColorScheme.onSurface),
  headlineSmall: const TextStyle()
      .copyWith(fontFamily: 'LTSaeada', color: kColorScheme.onSurface),
  labelLarge: const TextStyle()
      .copyWith(fontFamily: 'LTSaeada', color: kColorScheme.onSurface),
  labelMedium: const TextStyle()
      .copyWith(fontFamily: 'LTSaeada', color: kColorScheme.onSurface),
  labelSmall: const TextStyle()
      .copyWith(fontFamily: 'LTSaeada', color: kColorScheme.onSurface),
  titleLarge: const TextStyle()
      .copyWith(fontFamily: 'LTSaeada', color: kColorScheme.onSurface),
  titleMedium: const TextStyle()
      .copyWith(fontFamily: 'LTSaeada', color: kColorScheme.onSurface),
  titleSmall: const TextStyle()
      .copyWith(fontFamily: 'LTSaeada', color: kColorScheme.onSurface),
);

var textThemeDark = const TextTheme().copyWith(
  bodyLarge: const TextStyle().copyWith(fontFamily: 'LTSaeada'),
  bodyMedium: const TextStyle().copyWith(fontFamily: 'LTSaeada'),
  bodySmall: const TextStyle().copyWith(fontFamily: 'LTSaeada'),
  displayLarge: const TextStyle().copyWith(fontFamily: 'LTSaeada'),
  displayMedium: const TextStyle().copyWith(fontFamily: 'LTSaeada'),
  displaySmall: const TextStyle().copyWith(fontFamily: 'LTSaeada'),
  headlineLarge: const TextStyle().copyWith(fontFamily: 'LTSaeada'),
  headlineMedium: const TextStyle().copyWith(fontFamily: 'LTSaeada'),
  headlineSmall: const TextStyle().copyWith(fontFamily: 'LTSaeada'),
  labelLarge: const TextStyle().copyWith(fontFamily: 'LTSaeada'),
  labelMedium: const TextStyle().copyWith(fontFamily: 'LTSaeada'),
  labelSmall: const TextStyle().copyWith(fontFamily: 'LTSaeada'),
  titleLarge: const TextStyle().copyWith(fontFamily: 'LTSaeada'),
  titleMedium: const TextStyle().copyWith(fontFamily: 'LTSaeada'),
  titleSmall: const TextStyle().copyWith(fontFamily: 'LTSaeada'),
);

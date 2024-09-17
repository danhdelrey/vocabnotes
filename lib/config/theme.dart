import 'package:flutter/material.dart';

var kColorScheme = ColorScheme.fromSeed(seedColor: const Color(0xFF02b3a4));

final theme = ThemeData().copyWith(
  colorScheme: kColorScheme,
  appBarTheme: appBarTheme,
  textTheme: textTheme,
);

var appBarTheme = const AppBarTheme().copyWith(
  centerTitle: true,
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

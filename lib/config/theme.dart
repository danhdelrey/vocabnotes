import 'package:flutter/material.dart';

var kColorScheme = ColorScheme.fromSeed(seedColor: const Color(0xFF02b3a4));

final theme = ThemeData().copyWith(
  colorScheme: kColorScheme,
  appBarTheme: appBarTheme,
);

var appBarTheme = const AppBarTheme().copyWith(
  centerTitle: true,
);

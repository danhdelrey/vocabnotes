import 'package:flutter/material.dart';
import 'package:vocabnotes/app/routes.dart';
import 'package:vocabnotes/app/theme.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme,
      routes: routes,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
    ),
  );
}

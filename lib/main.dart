import 'package:flutter/material.dart';
import 'package:vocabnotes/config/routes.dart';
import 'package:vocabnotes/config/theme.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme,
      routes: routes,
    ),
  );
}

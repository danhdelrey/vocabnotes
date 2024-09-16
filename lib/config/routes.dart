import 'package:flutter/material.dart';
import 'package:vocabnotes/common/screens/splash_screen.dart';
import 'package:vocabnotes/common/widgets/bottom_navigation.dart';
import 'package:vocabnotes/features/library/presentation/screens/word_information_screen.dart';

final routes = {
  AppRoute.splash.routeName: (context) => const SplashScreen(),
  AppRoute.lookup.routeName: (context) => const BottomNavigation(),
  AppRoute.wordInformation.routeName: (context) =>
      const WordInformationScreen(),
};

enum AppRoute {
  splash,
  lookup,
  wordInformation,
}

extension AppRouteExtension on AppRoute {
  String get routeName {
    switch (this) {
      case AppRoute.splash:
        return '/';
      case AppRoute.lookup:
        return '/lookup';
      case AppRoute.wordInformation:
        return '/library/word_information';
    }
  }
}

void navigateTo(
    {required AppRoute appRoute,
    required context,
    data,
    required bool replacement}) {
  if (replacement) {
    Navigator.pushReplacementNamed(context, appRoute.routeName,
        arguments: data);
  } else {
    Navigator.pushNamed(context, appRoute.routeName, arguments: data);
  }
}

import 'package:flutter/material.dart';
import 'package:vocabnotes/common/screens/splash_screen.dart';
import 'package:vocabnotes/common/widgets/bottom_navigation.dart';
import 'package:vocabnotes/features/library/presentation/screens/library_word_information_screen.dart';
import 'package:vocabnotes/features/lookup/presentation/screens/lookup_word_information_screen.dart';
import 'package:vocabnotes/features/short_stories/presentation/screens/short_stories_screen.dart';

final routes = {
  AppRoute.splash.routeName: (context) => const SplashScreen(),
  AppRoute.lookup.routeName: (context) => const BottomNavigation(),
  AppRoute.lookupWordInformation.routeName: (context) =>
      const LookupWordInformationScreen(),
  AppRoute.libraryWordInformation.routeName: (context) =>
      const LibraryWordInformationScreen(),
  AppRoute.shortStories.routeName: (context) => const ShortStoriesScreen(),
};

enum AppRoute {
  splash,
  lookup,
  lookupWordInformation,
  libraryWordInformation,
  shortStories
}

extension AppRouteExtension on AppRoute {
  String get routeName {
    switch (this) {
      case AppRoute.splash:
        return '/';
      case AppRoute.lookup:
        return '/lookup';
      case AppRoute.lookupWordInformation:
        return '/lookup/lookup_word_information';
      case AppRoute.libraryWordInformation:
        return '/library/library_word_information';

      default:
        return '/learning/short_stories';
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

import 'package:flutter/material.dart';
import 'package:vocabnotes/common/widgets/bottom_navigation.dart';
import 'package:vocabnotes/features/library/presentation/screens/library_word_information_screen.dart';
import 'package:vocabnotes/features/lookup/presentation/screens/lookup_word_information_screen.dart';
import 'package:vocabnotes/features/multiple_choice/presentation/screens/multiple_choice_screen.dart';
import 'package:vocabnotes/features/short_stories/presentation/screens/short_stories_screen.dart';
import 'package:vocabnotes/features/short_stories/presentation/screens/short_stories_setting_screen.dart';

final routes = {
  AppRoute.lookup.routeName: (context) => const BottomNavigation(),
  AppRoute.lookupWordInformation.routeName: (context) =>
      const LookupWordInformationScreen(),
  AppRoute.libraryWordInformation.routeName: (context) =>
      const LibraryWordInformationScreen(),
  AppRoute.shortStories.routeName: (context) => const ShortStoriesScreen(),
  AppRoute.shortStoriesSetting.routeName: (context) =>
      const ShortStoriesSettingScreen(),
  AppRoute.multipleChoice.routeName: (context) => const MultipleChoiceScreen(),
};

enum AppRoute {
  lookup,
  lookupWordInformation,
  libraryWordInformation,
  shortStories,
  shortStoriesSetting,
  multipleChoice
}

extension AppRouteExtension on AppRoute {
  String get routeName {
    switch (this) {
      case AppRoute.lookup:
        return '/';
      case AppRoute.lookupWordInformation:
        return '/lookup/lookup_word_information';
      case AppRoute.libraryWordInformation:
        return '/library/library_word_information';
      case AppRoute.shortStories:
        return '/learning/short_stories';
      case AppRoute.shortStoriesSetting:
        return '/learning/short_stories_setting';
      case AppRoute.multipleChoice:
        return '/learning/multiple_choice';
      default:
        return '';
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

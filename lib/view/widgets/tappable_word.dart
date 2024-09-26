import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vocabnotes/app/routes.dart';
import 'package:vocabnotes/app/theme.dart';
import 'package:vocabnotes/bloc/word_information/word_information_bloc.dart';
import 'package:vocabnotes/view/screens/lookup_screen.dart';

class TappableWord extends StatelessWidget {
  const TappableWord({
    super.key,
    required this.word,
  });

  final String word;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2),
      child: InkWell(
        onTap: () {
          navigateTo(
            appRoute: AppRoute.lookupWordInformation,
            context: context,
            replacement: false,
            data: word,
          );
        },
        borderRadius: BorderRadius.circular(7),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondaryContainer,
            borderRadius: BorderRadius.circular(7),
          ),
          padding: const EdgeInsets.all(4),
          child: Text(
            word,
            style: const TextStyle().copyWith(
              color: Theme.of(context).colorScheme.onSecondaryContainer,
            ),
          ),
        ),
      ),
    );
  }
}

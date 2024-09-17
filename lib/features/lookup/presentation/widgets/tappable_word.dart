import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vocabnotes/config/routes.dart';
import 'package:vocabnotes/config/theme.dart';
import 'package:vocabnotes/features/lookup/presentation/blocs/word_information_bloc/word_information_bloc.dart';
import 'package:vocabnotes/features/lookup/presentation/screens/lookup_screen.dart';

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
              borderRadius: BorderRadius.circular(7),
              border: Border.all(color: kColorScheme.outlineVariant)),
          padding: const EdgeInsets.all(4),
          child: Text(word),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:vocabnotes/features/lookup/presentation/blocs/translate_definitions/translate_definitions_bloc.dart';

class WordTitle extends StatelessWidget {
  const WordTitle({
    super.key,
    required this.word,
    required this.phonetic,
  });

  final String word;
  final String? phonetic;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TranslateDefinitionsBloc(),
      child: Builder(builder: (context) {
        return BlocBuilder<TranslateDefinitionsBloc, TranslateDefinitionsState>(
          builder: (context, state) {
            if (state is TranslateDefinitionsInitial) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      context.read<TranslateDefinitionsBloc>().add(
                          TranslateDefinitionsPressed(
                              definition: word, example: null));
                    },
                    borderRadius: BorderRadius.circular(4),
                    child: Text(
                      word,
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                    ),
                  ),
                  if (phonetic != null)
                    Text(phonetic!,
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              fontFamily: "Roboto",
                            )),
                ],
              );
            } else if (state is TranslateDefinitionsInProgress) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Skeletonizer(
                    child: Text(
                      word,
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                    ),
                  ),
                  if (phonetic != null)
                    Text(phonetic!,
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              fontFamily: "Roboto",
                            )),
                ],
              );
            } else if (state is TranslateDefinitionsSuccess) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    word,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                  Text(
                    state.translatedDefinition,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: const Color(0xffff66b3),
                          fontWeight: FontWeight.bold,
                          fontFamily: "Roboto",
                        ),
                  ),
                  if (phonetic != null)
                    Text(phonetic!,
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              fontFamily: "Roboto",
                            )),
                ],
              );
            } else {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    word,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                  if (phonetic != null)
                    Text(phonetic!,
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              fontFamily: "Roboto",
                            )),
                ],
              );
            }
          },
        );
      }),
    );
  }
}

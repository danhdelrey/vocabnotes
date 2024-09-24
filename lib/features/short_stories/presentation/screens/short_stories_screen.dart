import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:vocabnotes/config/routes.dart';
import 'package:vocabnotes/config/theme.dart';
import 'package:vocabnotes/features/short_stories/presentation/short_stories_bloc/short_stories_bloc.dart';

class ShortStoriesScreen extends StatelessWidget {
  const ShortStoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ShortStoriesBloc()..add(GenerateShortStory()),
      child: Builder(builder: (context) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Short stories'),
            actions: [
              IconButton(
                  onPressed: () {
                    navigateTo(
                        appRoute: AppRoute.shortStoriesSetting,
                        context: context,
                        replacement: false);
                  },
                  icon: const Icon(HugeIcons.strokeRoundedEdit02))
            ],
          ),
          body: Stack(
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 25, right: 25, top: 30, bottom: 90),
                  child: SingleChildScrollView(
                    child: BlocBuilder<ShortStoriesBloc, ShortStoriesState>(
                      builder: (context, state) {
                        if (state is ShortStoriesGenerating) {
                          return Skeletonizer(
                            child: Column(
                              children: [
                                Text(
                                  'Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur',
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                Text(
                                  'Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(fontFamily: 'Roboto'),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  'Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur',
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                Text(
                                  'Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(fontFamily: 'Roboto'),
                                ),
                              ],
                            ),
                          );
                        } else if (state is ShortStoriesGeneratedSuccess) {
                          return Column(
                            children: [
                              ...state.shortStory.map(
                                (data) => _buildSentenceAndTranslation(
                                    context: context,
                                    sentence: data['sentence'],
                                    translation: data['translation'],
                                    wordListFromLibrary: state.wordList),
                              )
                            ],
                          );
                        } else if (state is ShortStoriesGeneratedFailure) {
                          return const Text('Something went wrong.');
                        } else {
                          return Container();
                        }
                      },
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: BlocBuilder<ShortStoriesBloc, ShortStoriesState>(
                    builder: (context, state) {
                      if (state is ShortStoriesGeneratedSuccess ||
                          state is ShortStoriesGeneratedFailure) {
                        return FilledButton.icon(
                          onPressed: () {
                            context
                                .read<ShortStoriesBloc>()
                                .add(GenerateShortStory());
                          },
                          label: const Text('Generate'),
                          icon: const Icon(HugeIcons.strokeRoundedReload),
                        );
                      } else {
                        return FilledButton.icon(
                          onPressed: null,
                          label: const Text('Generate'),
                          icon: const Icon(HugeIcons.strokeRoundedReload),
                        );
                      }
                    },
                  ),
                ),
              )
            ],
          ),
        );
      }),
    );
  }

  Column _buildSentenceAndTranslation(
      {required BuildContext context,
      required String sentence,
      required String translation,
      required List<String> wordListFromLibrary}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            children: [
              ...sentence.split(" ").map(
                    (word) => WidgetSpan(
                      child: InkWell(
                        borderRadius: BorderRadius.circular(4),
                        onTap: () {
                          wordListFromLibrary.contains(
                                  word.replaceAll(RegExp(r'[^a-zA-Z0-9]'), ''))
                              ? navigateTo(
                                  appRoute: AppRoute.libraryWordInformation,
                                  context: context,
                                  replacement: false,
                                  data: {
                                      'word': word.replaceAll(
                                          RegExp(r'[^a-zA-Z0-9]'), ''),
                                      'firstMeaning': ' '
                                    })
                              : navigateTo(
                                  appRoute: AppRoute.lookupWordInformation,
                                  context: context,
                                  replacement: false,
                                  data: word.replaceAll(
                                      RegExp(r'[^a-zA-Z0-9]'), ''));
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 4, right: 4),
                          child: wordListFromLibrary.contains(
                                  word.replaceAll(RegExp(r'[^a-zA-Z0-9]'), ''))
                              ? Text(
                                  word,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .tertiary,
                                      ),
                                )
                              : Text(
                                  word,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                ),
                        ),
                      ),
                    ),
                  )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 4, right: 4),
          child: Text(
            translation,
            style: GoogleFonts.inter(),
          ),
        ),
        const SizedBox(
          height: 15,
        )
      ],
    );
  }
}

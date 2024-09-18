import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:vocabnotes/config/routes.dart';
import 'package:vocabnotes/config/theme.dart';
import 'package:vocabnotes/features/short_stories/presentation/bloc/short_stories_bloc.dart';

class ShortStoriesScreen extends StatelessWidget {
  const ShortStoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ShortStoriesBloc(),
      child: Builder(builder: (context) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: ThemeData().scaffoldBackgroundColor,
            elevation: 0,
            surfaceTintColor: ThemeData().scaffoldBackgroundColor,
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
                          return const Center(
                            child: CircularProgressIndicator(),
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
                          return const Text('Something went wrong');
                        } else
                          return Container();
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
                      if (state is ShortStoriesGeneratedSuccess) {
                        return FilledButton.icon(
                          onPressed: () {
                            context.read<ShortStoriesBloc>().add(
                                  const GenerateShortStory(
                                      numberOfWordsInUse: 5,
                                      genre: 'happy',
                                      level: 'C2',
                                      length: '100 words'),
                                );
                          },
                          label: const Text('Generate'),
                          icon: const Icon(HugeIcons.strokeRoundedReload),
                        );
                      } else {
                        return Container();
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
      children: [
        RichText(
          text: TextSpan(
            children: [
              ...sentence.split(" ").map(
                    (word) => WidgetSpan(
                      child: InkWell(
                        borderRadius: BorderRadius.circular(4),
                        onTap: () {
                          navigateTo(
                              appRoute: AppRoute.lookupWordInformation,
                              context: context,
                              replacement: false,
                              data:
                                  word.replaceAll(RegExp(r'[^a-zA-Z0-9]'), ''));
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
                                        color: kColorScheme.primary,
                                      ),
                                )
                              : Text(
                                  word,
                                  style: Theme.of(context).textTheme.titleLarge,
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
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(fontFamily: 'Roboto'),
          ),
        ),
        const SizedBox(
          height: 15,
        )
      ],
    );
  }
}

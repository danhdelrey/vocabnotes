import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:vocabnotes/app/routes.dart';
import 'package:vocabnotes/bloc/multiple_choice/multiple_choice_bloc.dart';

class MultipleChoiceScreen extends StatelessWidget {
  const MultipleChoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String word = '';
    List<Map<String, String>> choices = [];

    return BlocProvider(
      create: (context) => MultipleChoiceBloc()..add(GetQuestionsEvent()),
      child: Builder(builder: (context) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Multiple choice'),
          ),
          body: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: BlocListener<MultipleChoiceBloc, MultipleChoiceState>(
                  listener: (context, state) {
                    if (state is QuestionsLoaded) {
                      word = state.word;
                      choices = state.choices;
                    }
                  },
                  child: BlocBuilder<MultipleChoiceBloc, MultipleChoiceState>(
                    builder: (context, state) {
                      if (state is QuestionsLoading) {
                        return const CircularProgressIndicator();
                      } else if (state is QuestionsLoaded) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              state.word,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            _buildChoices(
                                context: context,
                                correctAnswer: state.word,
                                choices: state.choices)
                          ],
                        );
                      } else if (state is CorrectAnswer) {
                        return Column(
                          children: [
                            const HugeIcon(
                              icon: HugeIcons.strokeRoundedCheckmarkCircle02,
                              size: 50,
                              color: null, // color will be set by Theme below
                            ),
                            Text(
                              'Correct!',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontSize: 40,
                                  ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ...choices.map(
                                  (choice) => Padding(
                                    padding: const EdgeInsets.only(bottom: 5),
                                    child: ListTile(
                                      titleTextStyle:
                                          DefaultTextStyle.of(context)
                                              .style
                                              .copyWith(
                                                fontWeight: FontWeight.bold,
                                              ),
                                      shape: choice['word'] == word
                                          ? RoundedRectangleBorder(
                                              side: BorderSide(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                                width: 2,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            )
                                          : null,
                                      onTap: () {
                                        navigateTo(
                                            appRoute:
                                                AppRoute.libraryWordInformation,
                                            context: context,
                                            replacement: false,
                                            data: {
                                              'word': choice['word']!,
                                              'firstMeaning':
                                                  choice['definition']!
                                            });
                                      },
                                      title: Text(choice['word']!),
                                      subtitle: Text(choice['definition']!),
                                      trailing: const HugeIcon(
                                          icon: HugeIcons
                                              .strokeRoundedArrowRight01),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            FilledButton.icon(
                              onPressed: () {
                                context
                                    .read<MultipleChoiceBloc>()
                                    .add(GetQuestionsEvent());
                              },
                              label: const Text('Continue'),
                              iconAlignment: IconAlignment.end,
                              icon: const HugeIcon(
                                  icon: HugeIcons
                                      .strokeRoundedCircleArrowRight01),
                            )
                          ],
                        );
                      } else if (state is IncorrectAnswer) {
                        return Column(
                          children: [
                            const HugeIcon(
                              icon: HugeIcons.strokeRoundedCancelCircle,
                              size: 50,
                              color: null, // color will be set by Theme below
                            ),
                            Text(
                              'Incorrect',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                    color: Theme.of(context).colorScheme.error,
                                    fontSize: 40,
                                  ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ...choices.map(
                                  (choice) => Padding(
                                    padding: const EdgeInsets.only(bottom: 5),
                                    child: ListTile(
                                      titleTextStyle:
                                          DefaultTextStyle.of(context)
                                              .style
                                              .copyWith(
                                                fontWeight: FontWeight.bold,
                                              ),
                                      shape: choice['word'] == word
                                          ? RoundedRectangleBorder(
                                              side: BorderSide(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                                width: 2,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            )
                                          : choice['word'] == state.chosen
                                              ? RoundedRectangleBorder(
                                                  side: BorderSide(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .error,
                                                    width: 2,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                )
                                              : null,
                                      onTap: () {
                                        navigateTo(
                                            appRoute:
                                                AppRoute.libraryWordInformation,
                                            context: context,
                                            replacement: false,
                                            data: {
                                              'word': choice['word']!,
                                              'firstMeaning':
                                                  choice['definition']!
                                            });
                                      },
                                      title: Text(choice['word']!),
                                      subtitle: Text(choice['definition']!),
                                      trailing: const HugeIcon(
                                          icon: HugeIcons
                                              .strokeRoundedArrowRight01),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            FilledButton.icon(
                              onPressed: () {
                                context
                                    .read<MultipleChoiceBloc>()
                                    .add(GetQuestionsEvent());
                              },
                              label: const Text('Continue'),
                              iconAlignment: IconAlignment.end,
                              icon: const HugeIcon(
                                  icon: HugeIcons
                                      .strokeRoundedCircleArrowRight01),
                            )
                          ],
                        );
                      } else if (state is QuestionsFailure) {
                        return const Text('The library is empty!');
                      } else {
                        return Container();
                      }
                    },
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  _buildChoices(
      {required BuildContext context,
      required correctAnswer,
      required List<Map<String, String>> choices}) {
    return Column(
      children: [
        ...choices.map((choices) => Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: InkWell(
                onTap: () {
                  context.read<MultipleChoiceBloc>().add(ChooseAnswerEvent(
                      answer: choices['word']!, correctAnswer: correctAnswer));
                },
                borderRadius: BorderRadius.circular(5),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Theme.of(context).colorScheme.outlineVariant,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(choices['definition']!),
                  ),
                ),
              ),
            ))
      ],
    );
  }
}

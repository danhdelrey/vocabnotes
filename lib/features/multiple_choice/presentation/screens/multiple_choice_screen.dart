import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:vocabnotes/features/multiple_choice/presentation/bloc/multiple_choice_bloc.dart';

class MultipleChoiceScreen extends StatelessWidget {
  const MultipleChoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String word;
    String correctAnswer;
    List<Map<String, String>> choices;

    return BlocProvider(
      create: (context) => MultipleChoiceBloc()..add(GetQuestionsEvent()),
      child: Builder(builder: (context) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: ThemeData().scaffoldBackgroundColor,
            elevation: 0,
            surfaceTintColor: ThemeData().scaffoldBackgroundColor,
            title: const Text('Multiple choice'),
          ),
          body: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(left: 15, right: 15, top: 40),
                child: BlocListener<MultipleChoiceBloc, MultipleChoiceState>(
                  listener: (context, state) {
                    if (state is QuestionsLoaded) {
                      word = state.word;
                      correctAnswer = state.correctAnswer;
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
                            _buildChoice(
                                context: context,
                                definition: state.a,
                                state: state),
                            _buildChoice(
                                context: context,
                                definition: state.b,
                                state: state),
                            _buildChoice(
                                context: context,
                                definition: state.c,
                                state: state),
                            _buildChoice(
                                context: context,
                                definition: state.d,
                                state: state),
                          ],
                        );
                      } else if (state is CorrectAnswer) {
                        return Column(
                          children: [
                            Icon(
                              HugeIcons.strokeRoundedCheckmarkCircle02,
                              size: 50,
                              color: Theme.of(context).colorScheme.primary,
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
                            _buildAnswers(context: context),
                            FilledButton.icon(
                              onPressed: () {
                                context
                                    .read<MultipleChoiceBloc>()
                                    .add(GetQuestionsEvent());
                              },
                              label: const Text('Continue'),
                              iconAlignment: IconAlignment.end,
                              icon: const Icon(
                                  HugeIcons.strokeRoundedCircleArrowRight01),
                            )
                          ],
                        );
                      } else if (state is IncorrectAnswer) {
                        return Column(
                          children: [
                            Icon(
                              HugeIcons.strokeRoundedCancelCircle,
                              size: 50,
                              color: Theme.of(context).colorScheme.error,
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
                              height: 30,
                            ),
                            FilledButton.icon(
                              onPressed: () {
                                context
                                    .read<MultipleChoiceBloc>()
                                    .add(GetQuestionsEvent());
                              },
                              label: const Text('Continue'),
                              iconAlignment: IconAlignment.end,
                              icon: const Icon(
                                  HugeIcons.strokeRoundedCircleArrowRight01),
                            )
                          ],
                        );
                      } else if (state is QuestionsFailure) {
                        return const Text(
                            'Library must have at least 4 words to start!');
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

  Column _buildAnswers(
      {required context,
      required word,
      required correctAnswer,
      List<Map<String,String>> choices}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...choices.map(
          (choice) => ListTile(
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: Theme.of(context).colorScheme.primary,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(5),
          ),
          onTap: () {},
          title: Text(choice['word']!),
          subtitle: Text(choice['definition']!),
          trailing: const Icon(HugeIcons.strokeRoundedArrowRight01),
        ),
        )
      ],
    );
  }

  _buildChoice(
      {required BuildContext context,
      required String definition,
      required QuestionsLoaded state}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: InkWell(
        onTap: () {
          context.read<MultipleChoiceBloc>().add(ChooseAnswerEvent(
              answer: definition, correctAnswer: state.correctAnswer));
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
            child: Text(definition),
          ),
        ),
      ),
    );
  }
}

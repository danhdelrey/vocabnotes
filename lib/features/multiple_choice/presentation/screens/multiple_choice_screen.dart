import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:vocabnotes/features/multiple_choice/presentation/bloc/multiple_choice_bloc.dart';

class MultipleChoiceScreen extends StatelessWidget {
  const MultipleChoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                                    color:
                                        Theme.of(context).colorScheme.primary),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            'Choose the correct definition:',
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                          const SizedBox(
                            height: 10,
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
                    } else {
                      return const Text('something went wrong');
                    }
                  },
                ),
              ),
            ),
          ),
        );
      }),
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

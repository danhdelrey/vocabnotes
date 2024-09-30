import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:vocabnotes/app/routes.dart';
import 'package:vocabnotes/bloc/writing_check_cubit/writing_check_cubit.dart';
import 'package:vocabnotes/bloc/writing_cubit/writing_cubit.dart';

class WritingScreen extends StatefulWidget {
  const WritingScreen({super.key});

  @override
  State<WritingScreen> createState() => _WritingScreenState();
}

class _WritingScreenState extends State<WritingScreen> {
  late TextEditingController _textEditingController;
  final FocusNode _focusNode = FocusNode();
  List<String> wordList = [];

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _textEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => WritingCubit(),
        ),
        BlocProvider(
          create: (context) => WritingCheckCubit()..generateWords(),
        ),
      ],
      child: Builder(builder: (context) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Writing'),
            actions: [
              IconButton(
                  onPressed: () {
                    navigateTo(
                        appRoute: AppRoute.writingSetting,
                        context: context,
                        replacement: false);
                  },
                  icon: const Icon(HugeIcons.strokeRoundedEdit02))
            ],
          ),
          body: SingleChildScrollView(
            child: BlocBuilder<WritingCubit, WritingState>(
              builder: (context, state) {
                if (state is WritingInitial || state is WritingFailure) {
                  return Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      BlocBuilder<WritingCheckCubit, WritingCheckState>(
                        builder: (context, state) {
                          if (state is WritingCheckInProgress) {
                            return const CircularProgressIndicator();
                          } else if (state is WritingCheckSuccess) {
                            wordList = state.randomWordList;
                            return Center(
                              child: Wrap(
                                alignment: WrapAlignment.center,
                                spacing: 5,
                                runSpacing: 5,
                                children: [
                                  ...state.randomWordList.map(
                                    (word) =>
                                        _buildTappableWord(context, word: word),
                                  )
                                ],
                              ),
                            );
                          } else if (state is WritingCheckFailure) {
                            return const Text('Library is empty');
                          } else {
                            return const SizedBox();
                          }
                        },
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      FilledButton(
                          onPressed: () {
                            if (_textEditingController.text.isNotEmpty) {
                              context.read<WritingCubit>().evaluateSentence(
                                  sentence: _textEditingController.text,
                                  wordList: wordList);
                            } else {
                              ScaffoldMessenger.of(context).clearSnackBars();
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('The sentence is empty')));
                            }
                          },
                          child: const Text('Submit')),
                      Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).scaffoldBackgroundColor,
                        ),
                        child: TextField(
                          onTapOutside: (event) {
                            FocusScope.of(context).unfocus();
                          },
                          //keyboardType: TextInputType.multiline,
                          maxLines: null,
                          style: Theme.of(context).textTheme.titleLarge,
                          focusNode: _focusNode,
                          controller: _textEditingController,

                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintStyle: const TextStyle().copyWith(fontSize: 15),
                            hintText:
                                'Write a sentence/passage with the given words...',
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                          ),
                        ),
                      ),
                    ],
                  );
                } else if (state is WritingInProgress) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is WritingSuccess) {
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        Text('Your answer: ${_textEditingController.text}'),
                        Text(
                            'Grammatical Accuracy: ${state.evaluation['Grammatical Accuracy']}'),
                        Text('Fluency: ${state.evaluation['Fluency']}'),
                        Text('Originality: ${state.evaluation['Originality']}'),
                        Text('Coherence: ${state.evaluation['Coherence']}'),
                        Text('Word Usage: ${state.evaluation['Word Usage']}'),
                        Text(
                            'Example Sentence: ${state.evaluation['Example Sentence']}'),
                        FilledButton(
                            onPressed: () {
                              _textEditingController.clear();
                              context.read<WritingCheckCubit>().generateWords();
                              context.read<WritingCubit>().tryAgain();
                            },
                            child: const Text('Continue')),
                      ],
                    ),
                  );
                } else {
                  return const SizedBox();
                }
              },
            ),
          ),
        );
      }),
    );
  }

  InkWell _buildTappableWord(BuildContext context, {required String word}) {
    return InkWell(
      borderRadius: BorderRadius.circular(4),
      onTap: () {
        navigateTo(
            appRoute: AppRoute.libraryWordInformation,
            context: context,
            replacement: false,
            data: {'word': word, 'firstMeaning': ' '});
      },
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).colorScheme.primary),
            borderRadius: BorderRadius.circular(4)),
        child: Padding(
          padding: const EdgeInsets.only(left: 4, right: 4),
          child: Text(
            word,
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
        ),
      ),
    );
  }
}

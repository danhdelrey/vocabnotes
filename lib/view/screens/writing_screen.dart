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
                    ],
                  );
                } else if (state is WritingInProgress) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is WritingSuccess) {
                  return SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15, right: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 15,
                          ),
                          Center(
                            child: Wrap(
                              alignment: WrapAlignment.center,
                              spacing: 5,
                              runSpacing: 5,
                              children: [
                                ...wordList.map(
                                  (word) =>
                                      _buildTappableWord(context, word: word),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            'Your answer:',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          Text(
                            _textEditingController.text,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const Divider(),
                          _buildEvaluation(
                              context: context,
                              title: 'Grammatical Accuracy:',
                              evaluation:
                                  state.evaluation['Grammatical Accuracy']),
                          _buildEvaluation(
                              context: context,
                              title: 'Fluency:',
                              evaluation: state.evaluation['Fluency']),
                          _buildEvaluation(
                              context: context,
                              title: 'Originality:',
                              evaluation: state.evaluation['Originality']),
                          _buildEvaluation(
                              context: context,
                              title: 'Coherence:',
                              evaluation: state.evaluation['Coherence']),
                          _buildEvaluation(
                              context: context,
                              title: 'Word Usage:',
                              evaluation: state.evaluation['Word Usage']),
                          const Divider(),
                          Text(
                            'Example Sentence:',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(state.evaluation['Example Sentence'],
                              style: Theme.of(context).textTheme.titleMedium),
                          const SizedBox(
                            height: 20,
                          ),
                          Center(
                            child: FilledButton(
                                onPressed: () {
                                  _textEditingController.clear();
                                  context
                                      .read<WritingCheckCubit>()
                                      .generateWords();
                                  context.read<WritingCubit>().tryAgain();
                                },
                                child: const Text('Continue')),
                          ),
                        ],
                      ),
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

  _buildEvaluation(
      {required BuildContext context,
      required String title,
      required String evaluation}) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
                child: int.tryParse(evaluation[0])! >= 0 &&
                        int.tryParse(evaluation[0])! <= 5
                    ? Text(
                        evaluation,
                        style:
                            Theme.of(context).textTheme.titleMedium!.copyWith(
                                  color: Theme.of(context).colorScheme.error,
                                ),
                      )
                    : int.tryParse(evaluation[0])! >= 6 &&
                            int.tryParse(evaluation[0])! <= 8
                        ? Text(
                            evaluation,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                          )
                        : int.tryParse(evaluation[0])! >= 9 &&
                                int.tryParse(evaluation[0])! <= 10
                            ? Text(
                                evaluation,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(
                                      color: const Color.fromARGB(
                                          255, 6, 192, 248),
                                    ),
                              )
                            : Text(
                                evaluation,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(
                                      color: const Color.fromARGB(
                                          255, 240, 224, 0),
                                    ),
                              )),
          ],
        ),
        const SizedBox(
          height: 15,
        ),
      ],
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

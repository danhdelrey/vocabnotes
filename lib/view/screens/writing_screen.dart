import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:skeletonizer/skeletonizer.dart';
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
                  return BlocBuilder<WritingCheckCubit, WritingCheckState>(
                    builder: (context, state) {
                      if (state is WritingCheckInProgress) {
                        return const Skeletonizer(
                            child:
                                Center(child: Text('fhsudhfoshdifnidfdfdfdf')));
                      } else if (state is WritingCheckSuccess) {
                        wordList = state.randomWordList;
                        return Column(
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            Center(
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
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
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
                                  hintStyle:
                                      const TextStyle().copyWith(fontSize: 15),
                                  hintText:
                                      'Write a sentence/paragraph using the provided words...',
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16.0),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            FilledButton(
                                onPressed: () {
                                  if (_textEditingController.text.isNotEmpty) {
                                    context
                                        .read<WritingCubit>()
                                        .evaluateSentence(
                                            sentence:
                                                _textEditingController.text,
                                            wordList: wordList);
                                  } else {
                                    ScaffoldMessenger.of(context)
                                        .clearSnackBars();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content:
                                                Text('The sentence is empty')));
                                  }
                                },
                                child: const Text('Submit')),
                          ],
                        );
                      } else if (state is WritingCheckFailure) {
                        return const Center(
                            child: Text('The library is empty'));
                      } else {
                        return const SizedBox();
                      }
                    },
                  );
                } else if (state is WritingInProgress) {
                  return SingleChildScrollView(
                    child: Skeletonizer(
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
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                            ),
                            const Divider(),
                            _buildEvaluation(
                                context: context,
                                title: 'Grammatical Accuracy:',
                                evaluation: '10/10'),
                            _buildEvaluation(
                                context: context,
                                title: 'Fluency:',
                                evaluation: '10/10'),
                            _buildEvaluation(
                                context: context,
                                title: 'Originality:',
                                evaluation: '10/10'),
                            _buildEvaluation(
                                context: context,
                                title: 'Coherence:',
                                evaluation: '10/10'),
                            _buildEvaluation(
                                context: context,
                                title: 'Word Usage:',
                                evaluation: '10/10'),
                            const Divider(),
                            Text(
                              'Example Sentence:',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              'This is an example sentence This is an example sentence',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Center(
                              child: FilledButton(
                                  onPressed: () {},
                                  child: const Text('Continue')),
                            ),
                          ],
                        ),
                      ),
                    ),
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
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
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
                          Text(
                            state.evaluation['Example Sentence'],
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                          ),
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
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Text(
                evaluation,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
            ),
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

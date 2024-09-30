import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:vocabnotes/app/routes.dart';
import 'package:vocabnotes/bloc/writing_check_cubit/writing_check_cubit.dart';
import 'package:vocabnotes/bloc/writing_cubit/writing_cubit.dart';

class Writing extends StatefulWidget {
  const Writing({super.key});

  @override
  State<Writing> createState() => _WritingState();
}

class _WritingState extends State<Writing> {
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
              child: Column(
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
                      onSubmitted: null,
                    
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintStyle: const TextStyle().copyWith(fontSize: 15),
                        hintText:
                            'Write a sentence/passage with these words...',
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 16.0),
                      ),
                    ),
                  ),
                ],
              ),
            ));
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

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
          body: Stack(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: SingleChildScrollView(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Center(
                            child: Text(
                              'Write a sentence using all of these words:',
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          BlocBuilder<WritingCheckCubit, WritingCheckState>(
                            builder: (context, state) {
                              if (state is WritingCheckInProgress) {
                                return const CircularProgressIndicator();
                              } else if (state is WritingCheckSuccess) {
                                return Center(
                                  child: Wrap(
                                    alignment: WrapAlignment.center,
                                    spacing: 5,
                                    runSpacing: 5,
                                    children: [
                                      ...state.randomWordList.map(
                                        (word) => _buildTappableWord(context,
                                            word: word),
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
                            height: 20,
                          ),
                          BlocBuilder<WritingCubit, String>(
                            builder: (context, state) {
                              return Text(
                                state,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .tertiary,
                                    ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                  ),
                  child: TextField(
                    onTapOutside: (event) {
                      FocusScope.of(context).unfocus();
                    },
                    style: Theme.of(context).textTheme.bodyMedium,
                    focusNode: _focusNode,
                    controller: _textEditingController,
                    onSubmitted: null,
                    onChanged: (value) {
                      context.read<WritingCubit>().startWriting(value);
                    },
                    decoration: InputDecoration(
                      suffixIcon: const Icon(HugeIcons.strokeRoundedSent),
                      hintText: 'hint text',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 16.0),
                    ),
                  ),
                ),
              )
            ],
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

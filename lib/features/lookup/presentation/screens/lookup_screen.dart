import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:vocabnotes/common/widgets/search_field.dart';
import 'package:vocabnotes/config/routes.dart';
import 'package:vocabnotes/features/lookup/presentation/blocs/save_to_library/save_to_library_bloc.dart';
import 'package:vocabnotes/features/lookup/presentation/blocs/word_information_bloc/word_information_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vocabnotes/features/lookup/presentation/widgets/word_information.dart';

class LookupScreen extends StatefulWidget {
  const LookupScreen({super.key});

  @override
  State<LookupScreen> createState() => _LookupScreenState();
}

class _LookupScreenState extends State<LookupScreen> {
  late TextEditingController _textEditingController;
  final _searchedWords = Queue<String>();

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
          create: (context) => WordInformationBloc(),
        ),
        BlocProvider(
          create: (context) => SaveToLibraryBloc(),
        ),
      ],
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: _buildAppBar(context),
            body: BlocListener<WordInformationBloc, WordInformationState>(
                listener: (context, state) {
                  if (state is WordInformationLookup) {
                    navigateTo(
                      appRoute: AppRoute.lookupWordInformation,
                      context: context,
                      replacement: false,
                      data: state.word,
                    );
                  }
                },
                child: const Placeholder()),
          );
        },
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: SearchField(
        textEditingController: _textEditingController,
        hintText: 'Look up word online',
        onSubmit: (value) {
          context.read<WordInformationBloc>().add(LookupWordEvent(word: value));
        },
      ),
    );
  }

  Scaffold _buildSearchWordInformationError(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: _searchedWords.isNotEmpty
            ? IconButton(
                onPressed: () {
                  String previousWord = _searchedWords.removeLast();
                  context
                      .read<WordInformationBloc>()
                      .add(GetWordInformationEvent(word: previousWord));
                },
                icon: const Icon(HugeIcons.strokeRoundedArrowLeft01),
              )
            : Container(),
      ),
      body: const Center(
        child: Text('something went wrong'),
      ),
    );
  }

  AppBar _buildTopBar(WordInformationLoaded state, BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Text(state.englishWordModelList[0].name),
      leading: _searchedWords.length > 1
          ? IconButton(
              onPressed: () {
                _searchedWords.removeLast();
                String previousWord = _searchedWords.removeLast();
                context
                    .read<WordInformationBloc>()
                    .add(GetWordInformationEvent(word: previousWord));
              },
              icon: const Icon(HugeIcons.strokeRoundedArrowLeft01),
            )
          : Container(),
      actions: [
        IconButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text('Add to library?'),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Cancel')),
                  FilledButton(
                      onPressed: () {
                        Navigator.pop(context);
                        context.read<SaveToLibraryBloc>().add(
                            SaveWordToLibraryEvent(
                                wordList: state.englishWordModelList));
                      },
                      child: const Text('Yes'))
                ],
              ),
            );
          },
          icon: const Icon(HugeIcons.strokeRoundedNoteAdd),
        ),
      ],
    );
  }
}

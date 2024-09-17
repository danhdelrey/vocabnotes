import 'package:flutter/material.dart';
import 'package:vocabnotes/features/lookup/presentation/blocs/save_to_library/save_to_library_bloc.dart';
import 'package:vocabnotes/features/lookup/presentation/blocs/word_information_bloc/word_information_bloc.dart';

class LookupWordInformationScreen extends StatefulWidget {
  const LookupWordInformationScreen({super.key});

  @override
  State<LookupWordInformationScreen> createState() => _LookupWordInformationScreenState();
}

class _LookupWordInformationScreenState extends State<LookupWordInformationScreen> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
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
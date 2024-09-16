import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:vocabnotes/common/widgets/search_field.dart';
import 'package:vocabnotes/data_models/english_word_model.dart';
import 'package:vocabnotes/features/lookup/presentation/blocs/word_information_bloc/word_information_bloc.dart';
import 'package:vocabnotes/features/lookup/presentation/widgets/tappable_word.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    return BlocProvider(
      create: (context) => WordInformationBloc(),
      child: Builder(builder: (context) {
        return Scaffold(
          appBar: _buildAppBar(context),
          body: BlocBuilder<WordInformationBloc, WordInformationState>(
            builder: (context, state) {
              if (state is WordInformationInitial) {
                return const Center(
                  child: Text('look up a word'),
                );
              } else if (state is WordInformationLoaded) {
                _searchedWords.addLast(state.englishWordModelList[0].name);
                return Scaffold(
                  appBar: _buildTopBar(state, context),
                  body: _buildWordInformation(state),
                );
              } else if (state is WordInformationloading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is WordInformationError) {
                return _buildSearchWordInformationError(context);
              }
              return Container();
            },
          ),
        );
      }),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: SearchField(
        textEditingController: _textEditingController,
        hintText: 'Look up word online',
        onSubmit: (value) {
          context
              .read<WordInformationBloc>()
              .add(GetWordInformationEvent(word: value));
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
              builder: (context) => AlertDialog(
                title: const Text('Add to library?'),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Cancel')),
                  FilledButton(onPressed: () {}, child: const Text('Yes'))
                ],
              ),
            );
          },
          icon: const Icon(HugeIcons.strokeRoundedNoteAdd),
        ),
      ],
    );
  }

  Padding _buildWordInformation(WordInformationLoaded state) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
      child: ListView.builder(
        itemCount: state.englishWordModelList.length,
        itemBuilder: (context, index) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWordTitle(
              context: context,
              word: state.englishWordModelList[index].name,
              phonetic: state.englishWordModelList[index].phonetic,
            ),
            ...state.englishWordModelList[index].decodedMeanings.map(
              (meanings) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDefinitions(
                    definitions: meanings['definitions'],
                    partOfSpeech: meanings['partOfSpeech'],
                  ),
                  _buildRelatedWords(
                      title: 'synonyms:', wordList: meanings['synonyms']),
                  _buildRelatedWords(
                      title: 'antonyms:', wordList: meanings['antonyms']),
                  const Divider(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Column _buildWordTitle({required context, required word, phonetic}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          word,
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        if (phonetic != null)
          Text(phonetic!, style: Theme.of(context).textTheme.bodyLarge),
      ],
    );
  }

  Column _buildRelatedWords({List<dynamic>? wordList, required title}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (wordList != null && wordList.isNotEmpty)
          Text(
            title,
            style: const TextStyle().copyWith(fontWeight: FontWeight.bold),
          ),
        if (wordList != null && wordList.isNotEmpty)
          Wrap(
            children: [
              ...wordList.map(
                (word) => TappableWord(word: word),
              ),
            ],
          ),
      ],
    );
  }

  Column _buildDefinitions({required List<dynamic> definitions, partOfSpeech}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 10,
        ),
        if (partOfSpeech != null)
          Container(
            decoration: BoxDecoration(
              color: ThemeData().colorScheme.outlineVariant,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding:
                  const EdgeInsets.only(top: 1, bottom: 1, left: 4, right: 4),
              child: Text(
                partOfSpeech,
              ),
            ),
          ),
        const SizedBox(
          height: 15,
        ),
        ...definitions.map(
          (definition) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (definition['definition'] != null)
                Text(
                  '‣ ${definition['definition']}',
                  style:
                      const TextStyle().copyWith(fontWeight: FontWeight.bold),
                ),
              if (definition['example'] != null)
                Text(
                  'E.g. ${definition['example']}',
                  style: const TextStyle().copyWith(
                    fontStyle: FontStyle.italic,
                  ),
                ),
              const SizedBox(
                height: 15,
              )
            ],
          ),
        ),
      ],
    );
  }
}

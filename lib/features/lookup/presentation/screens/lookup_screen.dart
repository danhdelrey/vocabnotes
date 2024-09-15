import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:vocabnotes/common/widgets/search_field.dart';
import 'package:vocabnotes/data_models/english_word_model.dart';
import 'package:vocabnotes/features/lookup/presentation/bloc/word_information_bloc.dart';
import 'package:vocabnotes/features/lookup/presentation/widgets/tappable_word.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LookupScreen extends StatefulWidget {
  const LookupScreen({super.key});

  @override
  State<LookupScreen> createState() => _LookupScreenState();
}

class _LookupScreenState extends State<LookupScreen> {
  late TextEditingController _textEditingController;

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
          appBar: AppBar(
            title: SearchField(
              textEditingController: _textEditingController,
              hintText: 'Look up word online',
              onSubmit: (value) => context
                  .read<WordInformationBloc>()
                  .add(GetWordInformationEvent(word: value)),
            ),
          ),
          body: BlocBuilder<WordInformationBloc, WordInformationState>(
            builder: (context, state) {
              if (state is WordInformationInitial) {
                return const Center(
                  child: Text('look up a word'),
                );
              } else if (state is WordInformationLoaded) {
                return ListView.builder(
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
                                title: 'synonyms',
                                wordList: meanings['synonyms']),
                            _buildRelatedWords(
                                title: 'antonyms',
                                wordList: meanings['antonyms']),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              } else if (state is WordInformationloading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return const Center(child: Text('error'));
            },
          ),
        );
      }),
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
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }

  Column _buildRelatedWords({List<dynamic>? wordList, required title}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (wordList != null && wordList.isNotEmpty) Text(title),
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

  Column _buildDefinitions(
      {required List<dynamic> definitions, required partOfSpeech}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(partOfSpeech),
        ...definitions.map(
          (definition) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(definition['definition']),
              if (definition['example'] != null) Text(definition['example']),
            ],
          ),
        ),
      ],
    );
  }
}

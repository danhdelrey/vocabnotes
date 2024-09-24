import 'package:flutter/material.dart';
import 'package:vocabnotes/data_models/english_word_model.dart';
import 'package:vocabnotes/features/lookup/presentation/widgets/definition_with_example.dart';
import 'package:vocabnotes/features/lookup/presentation/widgets/tappable_word.dart';
import 'package:vocabnotes/features/lookup/presentation/widgets/word_title.dart';

class WordInformation extends StatelessWidget {
  const WordInformation({super.key, required this.englishWordModelList});
  final List<EnglishWordModel> englishWordModelList;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
      child: ListView.builder(
        itemCount: englishWordModelList.length,
        itemBuilder: (context, index) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            WordTitle(word: englishWordModelList[index].name, phonetic: englishWordModelList[index].phonetic),
            ...englishWordModelList[index].decodedMeanings.map(
                  (meanings) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDefinitions(
                        context: context,
                        definitions: meanings['definitions'],
                        partOfSpeech: meanings['partOfSpeech'],
                      ),
                      _buildRelatedWords(
                          title: 'synonyms:',
                          wordList: meanings['synonyms'],
                          context: context),
                      _buildRelatedWords(
                          title: 'antonyms:',
                          wordList: meanings['antonyms'],
                          context: context),
                      const Divider(),
                    ],
                  ),
                ),
          ],
        ),
      ),
    );
  }

  Column _buildRelatedWords(
      {List<dynamic>? wordList, required title, required context}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (wordList != null && wordList.isNotEmpty)
          Text(
            title,
            style: const TextStyle().copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
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

  Column _buildDefinitions(
      {required List<dynamic> definitions, partOfSpeech, required context}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 10,
        ),
        if (partOfSpeech != null)
          Text(
            partOfSpeech,
            style: const TextStyle().copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        const SizedBox(
          height: 15,
        ),
        ...definitions.map(
          (definition) => Column(
            children: [
              DefinitionWithExample(
                  definition: definition['definition'],
                  example: definition['example']),
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

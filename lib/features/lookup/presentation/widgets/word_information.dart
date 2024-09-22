import 'package:flutter/material.dart';
import 'package:vocabnotes/data_models/english_word_model.dart';
import 'package:vocabnotes/features/lookup/presentation/widgets/tappable_word.dart';

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
            _buildWordTitle(
              context: context,
              word: englishWordModelList[index].name,
              phonetic: englishWordModelList[index].phonetic,
            ),
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

  Column _buildWordTitle({required context, required word, phonetic}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          word,
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
        ),
        if (phonetic != null)
          Text(phonetic!,
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontFamily: "Roboto",
                  )),
      ],
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (definition['definition'] != null)
                Text(
                  '> ${definition['definition']}',
                  style: const TextStyle().copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              if (definition['example'] != null)
                Text(
                  'E.g. ${definition['example']}',
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

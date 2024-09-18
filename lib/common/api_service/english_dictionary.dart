import 'dart:convert';

import 'package:free_english_dictionary/free_english_dictionary.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:vocabnotes/data_models/english_word_model.dart';

abstract class EnglishDictionary {
  Future<List<EnglishWordModel>> getWordInformation(String word);
}

class FreeEnglishDictionary implements EnglishDictionary {
  @override
  Future<List<EnglishWordModel>> getWordInformation(String word) async {
    List<EnglishWordModel> englishWordModelList = [];
    //return a list of word meaning
    final wordMeaningList = await FreeDictionary.getWordMeaning(word: word);

    for (var wordMeaning in wordMeaningList) {
      String name = wordMeaning.word!;
      String phonetic;
      if (wordMeaning.phonetic != null) {
        phonetic = wordMeaning.phonetic!;
      } else {
        phonetic = wordMeaning.phonetics!
            .firstWhere((phonetic) => phonetic.text != null)
            .text!;
      }

      String wordMeanings = jsonEncode(wordMeaning.meanings);
      EnglishWordModel englishWordModel = EnglishWordModel(
          name: name, meanings: wordMeanings, phonetic: phonetic);

      englishWordModelList.add(englishWordModel);
    }

    return englishWordModelList;
  }
}

class GeminiDictionary implements EnglishDictionary {
  @override
  Future<List<EnglishWordModel>> getWordInformation(String word) async {
    final schema = Schema.array(
      items: Schema.object(
        requiredProperties: ['word', 'meanings'],
        properties: {
          'word': Schema.string(nullable: false),
          'meanings': Schema.array(
            items: Schema.object(
              requiredProperties: ['definitions'],
              properties: {
                'definitions': Schema.array(
                  items: Schema.object(requiredProperties: [
                    'definition',
                    'example'
                  ], properties: {
                    'definition': Schema.string(nullable: false),
                    'example': Schema.string(nullable: false),
                  }),
                ),
                'synonyms': Schema.array(
                  items: Schema.string(nullable: true),
                ),
                'antonyms': Schema.array(
                  items: Schema.string(nullable: true),
                ),
              },
            ),
          ),
        },
      ),
    );

    final model = GenerativeModel(
        model: 'gemini-1.5-flash',
        apiKey: 'AIzaSyB4O0xvcgzvkoqbDi2VXtKUaRsTbTLTznA',
        generationConfig: GenerationConfig(
            responseMimeType: 'application/json', responseSchema: schema));

    final prompt =
        'Find the meaning of this english word/phrase, correct it if it is mispelled or incorrect: $word';
    final response = await model.generateContent([Content.text(prompt)]);

    List<EnglishWordModel> englishWordModelList = [];

    List<dynamic> wordList = jsonDecode(response.text!);

    for (var word in wordList) {
      EnglishWordModel englishWordModel = EnglishWordModel(
          name: word['word'], meanings: jsonEncode(word['meanings']));
      englishWordModelList.add(englishWordModel);
    }

    return englishWordModelList;
  }

  Future<List<dynamic>> generateShortStory(
      {required String genre,
      required String length,
      required String level,
      required List<String> wordList}) async {
    final schema = Schema.array(
      nullable: false,
      items: Schema.object(
        requiredProperties: ['sentence', 'wordsInSentence', 'translation'],
        properties: {
          'sentence': Schema.string(nullable: false),
          'wordsInSentence':
              Schema.array(items: Schema.string(nullable: false)),
          'translation': Schema.string(nullable: false),
        },
      ),
    );

    final model = GenerativeModel(
        model: 'gemini-1.5-flash',
        apiKey: 'AIzaSyB4O0xvcgzvkoqbDi2VXtKUaRsTbTLTznA',
        generationConfig: GenerationConfig(
            responseMimeType: 'application/json', responseSchema: schema));

    final prompt =
        'Write a $genre short story in English with $level vocabulary level, about $length long. The story should be broken down into multiple sentences. Each sentence should be followed by a Vietnamese translation of that sentence. The story must include the following words: $wordList';
    final response = await model.generateContent([Content.text(prompt)]);

    List<dynamic> data = jsonDecode(response.text!);
    return data;
  }
}

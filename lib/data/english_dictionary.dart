import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:free_english_dictionary/free_english_dictionary.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:vocabnotes/data/english_word_model.dart';

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
      String? phonetic;
      if (wordMeaning.phonetic != null) {
        phonetic = wordMeaning.phonetic!;
      } else if (wordMeaning.phonetics!.isNotEmpty) {
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
        requiredProperties: ['isRealWord', 'word', 'meanings', 'phonetic'],
        properties: {
          'isRealWord': Schema.boolean(nullable: false),
          'word': Schema.string(nullable: false),
          'phonetic': Schema.string(nullable: false),
          'meanings': Schema.array(
            items: Schema.object(
              requiredProperties: ['partOfSpeech', 'definitions'],
              properties: {
                'partOfSpeech': Schema.string(nullable: false),
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

    final safetySettings = [
      SafetySetting(HarmCategory.harassment, HarmBlockThreshold.none),
      SafetySetting(HarmCategory.hateSpeech, HarmBlockThreshold.none),
      SafetySetting(HarmCategory.dangerousContent, HarmBlockThreshold.none),
      SafetySetting(HarmCategory.sexuallyExplicit, HarmBlockThreshold.none),
    ];

    final model = GenerativeModel(
        model: 'gemini-1.5-flash',
        apiKey: dotenv.env['GEMINI_API_KEY']!,
        safetySettings: safetySettings,
        generationConfig: GenerationConfig(
            responseMimeType: 'application/json', responseSchema: schema));

    final prompt =
        'Check if this word or phrase exists in English (is a real word/phrase). If it does, find its meaning, correct any misspellings: $word';
    final response = await model.generateContent([Content.text(prompt)]);
    List<dynamic> wordList = jsonDecode(response.text!);
    List<EnglishWordModel> englishWordModelList = [];

    if (wordList[0]['isRealWord'] == true) {
      for (var word in wordList) {
        EnglishWordModel englishWordModel = EnglishWordModel(
            phonetic: '/${word['phonetic']}/',
            name: word['word'],
            meanings: jsonEncode(word['meanings']));
        englishWordModelList.add(englishWordModel);
      }
    }

    return englishWordModelList;
  }

  Future<List<dynamic>> generateShortStory(
      {required String genre,
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
    final safetySettings = [
      SafetySetting(HarmCategory.harassment, HarmBlockThreshold.none),
      SafetySetting(HarmCategory.hateSpeech, HarmBlockThreshold.none),
      SafetySetting(HarmCategory.dangerousContent, HarmBlockThreshold.none),
      SafetySetting(HarmCategory.sexuallyExplicit, HarmBlockThreshold.none),
    ];
    final model = GenerativeModel(
        model: 'gemini-1.5-flash',
        apiKey: 'AIzaSyB4O0xvcgzvkoqbDi2VXtKUaRsTbTLTznA',
        safetySettings: safetySettings,
        generationConfig: GenerationConfig(
            responseMimeType: 'application/json', responseSchema: schema));

    final prompt =
        'Write a $genre story in English using $level-level vocabulary. The story should be broken down into multiple sentences. Each sentence should be followed by a Vietnamese translation of that sentence. The story must include the following words or phrases: $wordList';
    final response = await model.generateContent([Content.text(prompt)]);

    List<dynamic> data = jsonDecode(response.text!);
    return data;
  }

  Future<Map<String, dynamic>> translateDefinitionsIntoVietnamese(
      {required String definition, required String? example}) async {
    final schema = Schema.object(requiredProperties: [
      'translatedDefinition'
    ], properties: {
      'translatedDefinition': Schema.string(nullable: false),
      'translatedExample': Schema.string(nullable: true),
    });
    final safetySettings = [
      SafetySetting(HarmCategory.harassment, HarmBlockThreshold.none),
      SafetySetting(HarmCategory.hateSpeech, HarmBlockThreshold.none),
      SafetySetting(HarmCategory.dangerousContent, HarmBlockThreshold.none),
      SafetySetting(HarmCategory.sexuallyExplicit, HarmBlockThreshold.none),
    ];
    final model = GenerativeModel(
        model: 'gemini-1.5-flash',
        apiKey: 'AIzaSyB4O0xvcgzvkoqbDi2VXtKUaRsTbTLTznA',
        safetySettings: safetySettings,
        generationConfig: GenerationConfig(
            responseMimeType: 'application/json', responseSchema: schema));

    final prompt =
        'Translate the following definition and example of a word into Vietnamse: definition: $definition, example: $example';

    final response = await model.generateContent([Content.text(prompt)]);

    return jsonDecode(response.text!);
  }

  Future<Map<String, dynamic>> evaluateTheSentence(
      {required String sentence, required List<String> wordList}) async {
    final schema = Schema.object(
      requiredProperties: [
        'Grammatical Accuracy',
        'Fluency',
        'Originality',
        'Coherence',
        'Word Usage',
        'Example Sentence'
      ],
      properties: {
        'Grammatical Accuracy': Schema.string(nullable: false),
        'Fluency': Schema.string(nullable: false),
        'Originality': Schema.string(nullable: false),
        'Coherence': Schema.string(nullable: false),
        'Word Usage': Schema.string(nullable: false),
        'Example Sentence': Schema.string(nullable: false),
      },
    );
    final safetySettings = [
      SafetySetting(HarmCategory.harassment, HarmBlockThreshold.none),
      SafetySetting(HarmCategory.hateSpeech, HarmBlockThreshold.none),
      SafetySetting(HarmCategory.dangerousContent, HarmBlockThreshold.none),
      SafetySetting(HarmCategory.sexuallyExplicit, HarmBlockThreshold.none),
    ];
    final model = GenerativeModel(
        model: 'gemini-1.5-flash',
        apiKey: 'AIzaSyB4O0xvcgzvkoqbDi2VXtKUaRsTbTLTznA',
        safetySettings: safetySettings,
        generationConfig: GenerationConfig(
            responseMimeType: 'application/json', responseSchema: schema));

    final prompt =
        """Task: You will be provided with a list of English words and a sentence/paragraph. Your task is to evaluate how well the sentence/paragraph utilizes the words from the list.

Input:

1. Word List: $wordList
2. Sentence/Paragraph: $sentence

Evaluation Criteria:

* Grammatical Accuracy: Is the sentence/paragraph grammatically correct? (Score out of 100)
* Fluency:  Does the sentence/paragraph sound natural and easy to understand? (Score out of 100)
* Originality: Is the use of language creative and engaging? (Score out of 100)
* Coherence: Are the words connected in a logical and meaningful way? (Score out of 100)
* Word Usage:  Does the sentence/paragraph use ALL the words from the list? (Score out of the total number of words). If any words are missing, please list them.
* Example Sentence:  Provide an example sentence/paragraph using the ideas in the input sentence that utilizes ALL the words in the word list in a grammatically correct, fluent, and creative way.

Output:

Provide a detailed evaluation of the sentence/paragraph based on the criteria listed above. 

Example:

Word List: [apple, red, eat, delicious, tree, sun]
Sentence: The red apple I ate from the tree was delicious.

Output:

* Grammatical Accuracy: 100/100
* Fluency: 80/100
* Originality: 60/100
* Coherence: 100/100
* Word Usage: 5/6 (Missing word: "sun")
* Example Sentence: The sun warmed the tree as I picked a red apple. It was so delicious to eat, I knew I’d be back for more.""";

    final response = await model.generateContent([Content.text(prompt)]);

    return jsonDecode(response.text!);
  }
}

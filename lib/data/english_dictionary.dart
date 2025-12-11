import 'dart:convert';

import 'package:dio/dio.dart'; // Import Dio
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:free_english_dictionary/free_english_dictionary.dart';
// import 'package:google_generative_ai/google_generative_ai.dart'; // Removed
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
  final Dio _dio = Dio();
  final String _baseUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent';

  /// Helper function to call Gemini API via Dio
  Future<String> _callGeminiApi({
    required String prompt,
    required Map<String, dynamic> responseSchema,
  }) async {
    final apiKey = dotenv.env['GEMINI_API_KEY'];
    if (apiKey == null || apiKey.isEmpty) {
      throw Exception('GEMINI_API_KEY is not defined in .env');
    }

    final url = '$_baseUrl?key=$apiKey';

    // Cấu hình safety settings cơ bản giống code cũ
    final safetySettings = [
      {"category": "HARM_CATEGORY_HARASSMENT", "threshold": "BLOCK_NONE"},
      {"category": "HARM_CATEGORY_HATE_SPEECH", "threshold": "BLOCK_NONE"},
      {
        "category": "HARM_CATEGORY_DANGEROUS_CONTENT",
        "threshold": "BLOCK_NONE"
      },
      {
        "category": "HARM_CATEGORY_SEXUALLY_EXPLICIT",
        "threshold": "BLOCK_NONE"
      },
    ];

    final data = {
      "contents": [
        {
          "parts": [
            {"text": prompt}
          ]
        }
      ],
      "safetySettings": safetySettings,
      "generationConfig": {
        "responseMimeType": "application/json",
        "responseSchema": responseSchema,
      }
    };

    try {
      final response = await _dio.post(
        url,
        data: data,
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode == 200) {
        // Parse response structure of Gemini REST API
        // { "candidates": [ { "content": { "parts": [ { "text": "..." } ] } } ] }
        final candidates = response.data['candidates'] as List;
        if (candidates.isNotEmpty) {
          final parts = candidates[0]['content']['parts'] as List;
          if (parts.isNotEmpty) {
            return parts[0]['text'] as String;
          }
        }
      }
      throw Exception('Failed to generate content: ${response.statusCode}');
    } catch (e) {
      throw Exception('Error calling Gemini API: $e');
    }
  }

  @override
  Future<List<EnglishWordModel>> getWordInformation(String word) async {
    // Reconstruct Schema as Map
    final schema = {
      "type": "ARRAY",
      "items": {
        "type": "OBJECT",
        "required": ["isRealWord", "word", "meanings", "phonetic"],
        "properties": {
          "isRealWord": {"type": "BOOLEAN", "nullable": false},
          "word": {"type": "STRING", "nullable": false},
          "phonetic": {"type": "STRING", "nullable": false},
          "meanings": {
            "type": "ARRAY",
            "items": {
              "type": "OBJECT",
              "required": ["partOfSpeech", "definitions"],
              "properties": {
                "partOfSpeech": {"type": "STRING", "nullable": false},
                "definitions": {
                  "type": "ARRAY",
                  "items": {
                    "type": "OBJECT",
                    "required": ["definition", "example"],
                    "properties": {
                      "definition": {"type": "STRING", "nullable": false},
                      "example": {"type": "STRING", "nullable": false}
                    }
                  }
                },
                "synonyms": {
                  "type": "ARRAY",
                  "items": {"type": "STRING", "nullable": true}
                },
                "antonyms": {
                  "type": "ARRAY",
                  "items": {"type": "STRING", "nullable": true}
                }
              }
            }
          }
        }
      }
    };

    final prompt =
        'Check if this word or phrase exists in English (is a real word/phrase). If it does, find its meaning, correct any misspellings: $word';

    final jsonString =
        await _callGeminiApi(prompt: prompt, responseSchema: schema);

    List<dynamic> wordList = jsonDecode(jsonString);
    List<EnglishWordModel> englishWordModelList = [];

    if (wordList.isNotEmpty && wordList[0]['isRealWord'] == true) {
      for (var wordItem in wordList) {
        EnglishWordModel englishWordModel = EnglishWordModel(
            phonetic: '/${wordItem['phonetic']}/',
            name: wordItem['word'],
            meanings: jsonEncode(wordItem['meanings']));
        englishWordModelList.add(englishWordModel);
      }
    }

    return englishWordModelList;
  }

  Future<List<dynamic>> generateShortStory(
      {required String genre,
      required String level,
      required List<String> wordList}) async {
    final schema = {
      "type": "ARRAY",
      "nullable": false,
      "items": {
        "type": "OBJECT",
        "required": ["sentence", "wordsInSentence", "translation"],
        "properties": {
          "sentence": {"type": "STRING", "nullable": false},
          "wordsInSentence": {
            "type": "ARRAY",
            "items": {"type": "STRING", "nullable": false}
          },
          "translation": {"type": "STRING", "nullable": false}
        }
      }
    };

    final prompt =
        'Write a $genre story in English using $level-level vocabulary. The story should be broken down into multiple sentences. Each sentence should be followed by a Vietnamese translation of that sentence. The story must include the following words or phrases: $wordList';

    final jsonString =
        await _callGeminiApi(prompt: prompt, responseSchema: schema);

    List<dynamic> data = jsonDecode(jsonString);
    return data;
  }

  Future<Map<String, dynamic>> translateDefinitionsIntoVietnamese(
      {required String definition, required String? example}) async {
    final schema = {
      "type": "OBJECT",
      "required": ["translatedDefinition"],
      "properties": {
        "translatedDefinition": {"type": "STRING", "nullable": false},
        "translatedExample": {"type": "STRING", "nullable": true}
      }
    };

    final prompt =
        'Translate the following definition and example of a word into Vietnamse: definition: $definition, example: $example';

    final jsonString =
        await _callGeminiApi(prompt: prompt, responseSchema: schema);

    return jsonDecode(jsonString);
  }

  Future<Map<String, dynamic>> evaluateTheSentence(
      {required String sentence, required List<String> wordList}) async {
    final schema = {
      "type": "OBJECT",
      "required": [
        "Grammatical Accuracy",
        "Fluency",
        "Originality",
        "Coherence",
        "Word Usage",
        "Example Sentence"
      ],
      "properties": {
        "Grammatical Accuracy": {"type": "STRING", "nullable": false},
        "Fluency": {"type": "STRING", "nullable": false},
        "Originality": {"type": "STRING", "nullable": false},
        "Coherence": {"type": "STRING", "nullable": false},
        "Word Usage": {"type": "STRING", "nullable": false},
        "Example Sentence": {"type": "STRING", "nullable": false}
      }
    };

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

    final jsonString =
        await _callGeminiApi(prompt: prompt, responseSchema: schema);

    return jsonDecode(jsonString);
  }
}

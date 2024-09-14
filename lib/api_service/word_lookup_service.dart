import 'package:vocabnotes/api_service/english_dictionary.dart';
import 'package:vocabnotes/data_models/english_word_model.dart';

class WordLookupService {
  final EnglishDictionary englishDictionary;
  final GeminiDictionary geminiDictionary;

  WordLookupService({required this.englishDictionary, required this.geminiDictionary});

  Future<List<EnglishWordModel>> lookupWordFromDictionary(String word) async {
    return englishDictionary.getWordInformation(word);
  }

  Future<List<EnglishWordModel>> lookupWordFromGemini(String word) async {
    return geminiDictionary.getWordInformation(word);
  }
}

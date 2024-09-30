import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:vocabnotes/data/english_dictionary.dart';
import 'package:vocabnotes/data/word_lookup_service.dart';

part 'writing_state.dart';

class WritingCubit extends Cubit<WritingState> {
  WritingCubit() : super(WritingInitial());
  final wordLookupService = WordLookupService(
    englishDictionary: FreeEnglishDictionary(),
    geminiDictionary: GeminiDictionary(),
  );
  void evaluateSentence(
      {required String sentence, required List<String> wordList}) async {
    try {
      emit(WritingInProgress());
      Map<String, dynamic> result = await wordLookupService.geminiDictionary
          .evaluateTheSentence(sentence: sentence, wordList: wordList);
      emit(WritingSuccess(evaluation: result));
    } catch (e) {
      emit(WritingFailure());
    }
  }

  void tryAgain() {
    emit(WritingInitial());
  }
}

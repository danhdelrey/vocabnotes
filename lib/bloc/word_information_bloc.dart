import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:vocabnotes/api_service/english_dictionary.dart';
import 'package:vocabnotes/api_service/word_lookup_service.dart';
import 'package:vocabnotes/data_models/english_word_model.dart';

part 'word_information_event.dart';
part 'word_information_state.dart';

class WordInformationBloc
    extends Bloc<WordInformationEvent, WordInformationState> {
  WordInformationBloc() : super(WordInformationInitial()) {
    final wordLookupService = WordLookupService(
      englishDictionary: FreeEnglishDictionary(),
      geminiDictionary: GeminiDictionary(),
    );

    on<GetWordInformationEvent>((event, emit) async {
      List<EnglishWordModel> englishWordModelList;
      try {
        englishWordModelList =
            await wordLookupService.lookupWordFromDictionary(event.word);
        emit(WordInformationLoaded(englishWordModelList: englishWordModelList));
      } catch (e) {
        try {
          englishWordModelList =
              await wordLookupService.lookupWordFromGemini(event.word);
          emit(WordInformationLoaded(
              englishWordModelList: englishWordModelList));
        } catch (e) {
          emit(WordInformationError());
        }
      }
    });
  }
}

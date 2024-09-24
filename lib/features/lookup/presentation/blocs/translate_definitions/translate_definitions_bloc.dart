import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:vocabnotes/common/api_service/english_dictionary.dart';
import 'package:vocabnotes/common/api_service/word_lookup_service.dart';

part 'translate_definitions_event.dart';
part 'translate_definitions_state.dart';

class TranslateDefinitionsBloc
    extends Bloc<TranslateDefinitionsEvent, TranslateDefinitionsState> {
  TranslateDefinitionsBloc() : super(TranslateDefinitionsInitial()) {
    final wordLookupService = WordLookupService(
      englishDictionary: FreeEnglishDictionary(),
      geminiDictionary: GeminiDictionary(),
    );

    on<TranslateDefinitionsPressed>((event, emit) async {
      emit(TranslateDefinitionsInProgress());
      final translatedDefinitions = await wordLookupService.geminiDictionary
          .translateDefinitionsIntoVietnamese(
              definition: event.definition, example: event.example);
      emit(TranslateDefinitionsSuccess(translatedDefinition: translatedDefinitions['translatedDefinition'], translatedExample: translatedDefinitions['translatedExample']));
    });
  }
}

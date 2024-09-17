import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:vocabnotes/common/api_service/english_dictionary.dart';
import 'package:vocabnotes/common/api_service/word_lookup_service.dart';

part 'short_stories_event.dart';
part 'short_stories_state.dart';

class ShortStoriesBloc extends Bloc<ShortStoriesEvent, ShortStoriesState> {
  ShortStoriesBloc() : super(ShortStoriesInitial()) {
    final wordLookupService = WordLookupService(
      englishDictionary: FreeEnglishDictionary(),
      geminiDictionary: GeminiDictionary(),
    );
    on<GenerateShortStory>((event, emit)async {
      try {
        emit(ShortStoriesGenerating());






        //final data = await wordLookupService.geminiDictionary.generateShortStory(wordList: )
      } catch (e) {
        emit(ShortStoriesGeneratedFailure());
      }
    });
  }
}

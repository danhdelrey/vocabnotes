import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:vocabnotes/common/api_service/english_dictionary.dart';
import 'package:vocabnotes/common/api_service/word_lookup_service.dart';
import 'package:vocabnotes/database/word_database.dart';

part 'short_stories_event.dart';
part 'short_stories_state.dart';

class ShortStoriesBloc extends Bloc<ShortStoriesEvent, ShortStoriesState> {
  ShortStoriesBloc() : super(ShortStoriesInitial()) {
    final wordLookupService = WordLookupService(
      englishDictionary: FreeEnglishDictionary(),
      geminiDictionary: GeminiDictionary(),
    );
    on<GenerateShortStory>((event, emit) async {
      try {
        emit(ShortStoriesGenerating());

        final database = await $FloorWordDatabase
            .databaseBuilder('word_database.db')
            .build();
        final wordDao = database.wordDao;

        //lay ra n tu khac nhau trong database
        final allWordsFromDatabase = await wordDao.getAllWordNamesInDatabase();
        Random random = Random();
        allWordsFromDatabase!.shuffle(random);
        final randomWordList =
            allWordsFromDatabase.take(event.numberOfWordsInUse).toList();

        final shortStory = await wordLookupService.geminiDictionary
            .generateShortStory(wordList: randomWordList);

        emit(ShortStoriesGeneratedSuccess(
            shortStory: shortStory, wordList: allWordsFromDatabase));
      } catch (e) {
        emit(ShortStoriesGeneratedFailure());
      }
    });
  }
}

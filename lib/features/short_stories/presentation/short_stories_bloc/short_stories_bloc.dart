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

        Set<String> uniqueWordSet = allWordsFromDatabase!.toSet();
        List<String> uniqueWordList = uniqueWordSet.toList();

        uniqueWordList.shuffle(random);
        final randomWordList =
            uniqueWordList.take(event.numberOfWordsInUse).toList();

        final shortStory = await wordLookupService.geminiDictionary
            .generateShortStory(
                wordList: randomWordList,
                genre: event.genre,
                length: event.length,
                level: event.level);

        emit(ShortStoriesGeneratedSuccess(
            shortStory: shortStory, wordList: uniqueWordList));
      } catch (e) {
        emit(ShortStoriesGeneratedFailure());
      }
    });
  }
}

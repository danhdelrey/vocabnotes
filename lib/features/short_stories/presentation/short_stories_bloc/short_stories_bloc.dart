
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

        Set<String> uniqueWordSet = allWordsFromDatabase!.toSet();
        List<String> uniqueWordList = uniqueWordSet.toList();

        uniqueWordList.shuffle();
        final SharedPreferences prefs = await SharedPreferences.getInstance();

        final genreFetched = prefs.getString('genre');
        final levelFetched = prefs.getString('level');
        final lengthFetched = prefs.getString('length');
        final wordsUsedFetched = prefs.getString('wordsUsed');

        String genre;
        String level;
        String length;
        int wordsUsed;

        if (genreFetched != null) {
          genre = genreFetched;
        } else {
          genre = 'Comedy';
        }

        if (levelFetched != null) {
          level = levelFetched;
        } else {
          level = 'B1';
        }

        if (lengthFetched != null) {
          length = lengthFetched;
        } else {
          length = '100 words';
        }

        if (wordsUsedFetched != null) {
          wordsUsed = int.tryParse(wordsUsedFetched)!;
        } else {
          wordsUsed = 2;
        }

        final randomWordList = uniqueWordList.take(wordsUsed).toList();

        final shortStory = await wordLookupService.geminiDictionary
            .generateShortStory(
                wordList: randomWordList,
                genre: genre,
                length: length,
                level: level);

        emit(ShortStoriesGeneratedSuccess(
            shortStory: shortStory, wordList: uniqueWordList));
      } catch (e) {
        emit(ShortStoriesGeneratedFailure());
      }
    });
  }
}

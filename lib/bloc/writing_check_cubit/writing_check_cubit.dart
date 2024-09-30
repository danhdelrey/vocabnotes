import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vocabnotes/data/word_database.dart';

part 'writing_check_state.dart';

class WritingCheckCubit extends Cubit<WritingCheckState> {
  WritingCheckCubit() : super(WritingCheckInitial());

  void generateWords() async {
    try {
      emit(WritingCheckInProgress());

      final database =
          await $FloorWordDatabase.databaseBuilder('word_database.db').build();
      final wordDao = database.wordDao;

      //lay ra n tu khac nhau trong database
      final allWordsFromDatabase = await wordDao.getAllWordNamesInDatabase();

      if(allWordsFromDatabase!.isEmpty){
        emit(WritingCheckFailure());
      }else{
        Set<String> uniqueWordSet = allWordsFromDatabase!.toSet();
        List<String> uniqueWordList = uniqueWordSet.toList();

        uniqueWordList.shuffle();
        final SharedPreferences prefs = await SharedPreferences.getInstance();

        final wordsUsedFetched = prefs.getString('wordsUsedInWriting');

        int wordsUsed;

        if (wordsUsedFetched != null) {
          wordsUsed = int.tryParse(wordsUsedFetched)!;
        } else {
          wordsUsed = 2;
        }

        final randomWordList = uniqueWordList.take(wordsUsed).toList();

        emit(WritingCheckSuccess(randomWordList: randomWordList));
      }

      
    } catch (e) {
      emit(WritingCheckFailure());
    }
  }

  void submitSentence(String sentence) {}
}

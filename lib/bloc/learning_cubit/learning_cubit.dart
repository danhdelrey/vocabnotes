import 'package:bloc/bloc.dart';
import 'package:vocabnotes/data/word_database.dart';

class LearningCubit extends Cubit<int> {
  LearningCubit() : super(0);

  void countWordsFromLibrary() async {
    final database =
        await $FloorWordDatabase.databaseBuilder('word_database.db').build();

    final wordDao = database.wordDao;

    final wordCount = await wordDao.countAllWords();

    emit(wordCount!);
  }
}

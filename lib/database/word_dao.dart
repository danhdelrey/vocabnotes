import 'package:floor/floor.dart';
import 'package:vocabnotes/data_models/english_word_model.dart';

@dao
abstract class WordDao {
  @Query('select * from EnglishWordModel where name = :word')
  Future<List<EnglishWordModel>?> findWords(String word);

  @insert
  Future<void> insertWord(EnglishWordModel word);
}

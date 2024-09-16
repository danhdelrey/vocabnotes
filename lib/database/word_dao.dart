import 'package:floor/floor.dart';
import 'package:vocabnotes/data_models/english_word_model.dart';

@dao
abstract class WordDao {

  @insert
  Future<void> insertWord(List<EnglishWordModel> word);

  @Query("SELECT * FROM EnglishWordModel WHERE name LIKE '%' || :word || '%'")
  Future<List<EnglishWordModel>?> findWordInDatabase(String word);

  @Query(
      "SELECT COUNT(*) FROM EnglishWordModel WHERE name LIKE '%' || :word || '%'")
  Future<int?> countWord(String word);

  @Query("DELETE FROM EnglishWordModel WHERE name LIKE '%' || :word || '%'")
  Future<void> deleteWord(String word);
}

import 'package:floor/floor.dart';
import 'package:vocabnotes/data_models/english_word_model.dart';

@dao
abstract class WordDao {
  @insert
  Future<void> insertWord(List<EnglishWordModel> word);

  @Query("SELECT * FROM EnglishWordModel")
  Future<List<EnglishWordModel>?> getAllWordsInDatabase();

  @Query("SELECT name FROM EnglishWordModel")
  Future<List<String>?> getAllWordNamesInDatabase();

  @Query("SELECT * FROM EnglishWordModel WHERE name LIKE '%' || :word || '%'")
  Future<List<EnglishWordModel>?> findWordInDatabase(String word);

  @Query("SELECT * FROM EnglishWordModel WHERE name = :wordName and meanings LIKE '%' || :firstMeaning || '%'")
  Future<EnglishWordModel?> getWordInformation(String wordName, String firstMeaning);

  @Query("SELECT COUNT(*) FROM EnglishWordModel WHERE name = :word ")
  Future<int?> countWord(String word);

  @Query("SELECT COUNT(*) FROM EnglishWordModel")
  Future<int?> countAllWords();

  @Query(
      "DELETE FROM EnglishWordModel WHERE name = :wordName and meanings LIKE '%' || :firstMeaning || '%'")
  Future<void> deleteWord(String wordName,String firstMeaning);
}

import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:vocabnotes/data_models/english_word_model.dart';
import 'package:vocabnotes/database/word_dao.dart';

part 'word_database.g.dart';

@Database(version: 1, entities: [EnglishWordModel])
abstract class WordDatabase extends FloorDatabase {
  WordDao get wordDao;
}

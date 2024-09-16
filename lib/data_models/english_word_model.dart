import 'dart:convert';

import 'package:floor/floor.dart';
import 'package:uuid/uuid.dart';

@entity
class EnglishWordModel {
  @PrimaryKey(autoGenerate: true)
  String id;
  String name;
  String? phonetic;
  String meanings;

  EnglishWordModel({required this.name, required this.meanings, this.phonetic})
      : id = const Uuid().v4();

  List<dynamic> get decodedMeanings {
    return jsonDecode(meanings);
  }
}

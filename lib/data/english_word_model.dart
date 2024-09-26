import 'dart:convert';

import 'package:floor/floor.dart';

@entity
class EnglishWordModel {
  @PrimaryKey(autoGenerate: true)
  int? id;
  String name;
  String? phonetic;
  String meanings;

  EnglishWordModel({required this.name, required this.meanings, this.phonetic});

  List<dynamic> get decodedMeanings {
    return jsonDecode(meanings);
  }

  
}

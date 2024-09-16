import 'package:flutter/material.dart';
import 'package:vocabnotes/data_models/english_word_model.dart';
import 'package:vocabnotes/features/lookup/presentation/widgets/word_information.dart';

class WordInformationScreen extends StatelessWidget {
  const WordInformationScreen({super.key, required this.englishWordModelList});
  final List<EnglishWordModel> englishWordModelList;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(englishWordModelList[0].name),
      ),
      body: WordInformation(englishWordModelList: englishWordModelList),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:vocabnotes/common/widgets/search_field.dart';
import 'package:vocabnotes/features/library/presentation/widgets/word_list_tile.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  late TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _textEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SearchField(textEditingController: _textEditingController, hintText: 'Search in library',),
      ),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) => const WordListTile(
          word: 'hello',
          firstMeaning:
              'hellohellohellohehhellohellohellohellohellohellohellohellohellohellohellohelloellohellohellohellohellohellohellohellohellohellohellohellollohellohellohellohellohellohellohellohello',
          phonetic: '/hello/',
        ),
      ),
    );
  }
}

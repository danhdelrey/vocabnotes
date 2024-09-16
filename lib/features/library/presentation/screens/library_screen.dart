import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:vocabnotes/common/widgets/search_field.dart';
import 'package:vocabnotes/features/library/presentation/bloc/library_bloc.dart';
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
    return BlocProvider(
      create: (context) => LibraryBloc()..add(GetAllWordsFromDatabaseEvent()),
      child: Scaffold(
        appBar: AppBar(
          title: SearchField(
            textEditingController: _textEditingController,
            hintText: 'Search in library',
          ),
        ),
        body: BlocBuilder<LibraryBloc, LibraryState>(
          builder: (context, state) {
            if (state is LibraryLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is Libraryloaded) {
              return ListView.builder(
                itemCount: state.wordListTiles.length,
                itemBuilder: (context, index) => WordListTile(
                  word: state.wordListTiles[index].word,
                  firstMeaning: state.wordListTiles[index].firstMeaning,
                  phonetic: state.wordListTiles[index].phonetic,
                ),
              );
            } else if (state is LibraryEmpty) {
              return const Center(
                child: Text('no words found'),
              );
            } else if (state is LibraryError) {
              return const Center(
                child: Text('something went wrong'),
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}

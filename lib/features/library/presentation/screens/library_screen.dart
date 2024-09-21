import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:skeletonizer/skeletonizer.dart';
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
      child: Builder(builder: (context) {
        return RefreshIndicator(
          onRefresh: () async {
            context.read<LibraryBloc>().add(GetAllWordsFromDatabaseEvent());
          },
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Library'),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(kToolbarHeight),
                child: SearchField(
                  textEditingController: _textEditingController,
                  hintText: 'Search in library',
                  onChanged: (value) {
                    context
                        .read<LibraryBloc>()
                        .add(SearchInLibrary(word: value));
                  },
                ),
              ),
            ),
            body: BlocListener<LibraryBloc, LibraryState>(
              listener: (context, state) {
                if (state is WordDeleteSuccess) {
                  context
                      .read<LibraryBloc>()
                      .add(GetAllWordsFromDatabaseEvent());
                  ScaffoldMessenger.of(context).clearSnackBars();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Deleted'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                } else if (state is WordDeleteFailure) {
                  context
                      .read<LibraryBloc>()
                      .add(GetAllWordsFromDatabaseEvent());
                  ScaffoldMessenger.of(context).clearSnackBars();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Something went wrong'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                }
              },
              child: BlocBuilder<LibraryBloc, LibraryState>(
                builder: (context, state) {
                  if (state is LibraryLoading) {
                    return Skeletonizer(
                      enabled: true,
                      child: ListView.builder(
                        itemCount: (MediaQuery.of(context).size.height / 80)
                            .ceil(), // Số lượng item placeholder
                        itemBuilder: (context, index) => const WordListTile(
                          word: 'Lorem ipsum dolor',
                          firstMeaning:
                              'Suspendisse aliquet metus ut varius luctus. Maecenas luctus ligula eu dapibus pretium. Interdum et malesuada fames ac ante ipsum primis in faucibus. Praesent eget erat nulla. Vestibulum molestie eros sit amet maximus viverra.',
                          phonetic: 'phonetic',
                        ), // Widget placeholder
                      ),
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
                      child: Text('No words found in your library.'),
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
          ),
        );
      }),
    );
  }
}

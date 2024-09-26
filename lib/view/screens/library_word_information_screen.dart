import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vocabnotes/data/english_word_model.dart';
import 'package:vocabnotes/bloc/library/library_bloc.dart';
import 'package:vocabnotes/bloc/word_information/word_information_bloc.dart';
import 'package:vocabnotes/view/widgets/word_information.dart';

class LibraryWordInformationScreen extends StatelessWidget {
  const LibraryWordInformationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LibraryBloc()
        ..add(GetWordFromDatabaseEvent(
            wordName:
                ((ModalRoute.of(context)!.settings.arguments as Map)['word']),
            firstMeaning: ((ModalRoute.of(context)!.settings.arguments
                as Map)['firstMeaning']))),
      child: BlocBuilder<LibraryBloc, LibraryState>(
        builder: (context, state) {
          if (state is GetWordLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is GetWordSucess) {
            return Scaffold(
              appBar: AppBar(
                title: Text((ModalRoute.of(context)!.settings.arguments
                    as Map<String, String>)['word']!),
              ),
              body: WordInformation(
                  englishWordModelList: [state.englishWordModel]),
            );
          } else if (state is GetWordFailure) {
            return const Text('Something went wrong');
          }
          return Container();
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vocabnotes/data_models/english_word_model.dart';
import 'package:vocabnotes/features/library/presentation/bloc/library_bloc.dart';
import 'package:vocabnotes/features/lookup/presentation/widgets/word_information.dart';

class WordInformationScreen extends StatelessWidget {
  const WordInformationScreen({super.key, required this.englishWordModelList});
  final List<EnglishWordModel> englishWordModelList;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LibraryBloc(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(englishWordModelList[0].name),
        ),
        body: BlocBuilder<LibraryBloc, LibraryState>(
          builder: (context, state) {
            if (state is LibraryLoading) {}
            return Container();
          },
        ),
      ),
    );
  }
}

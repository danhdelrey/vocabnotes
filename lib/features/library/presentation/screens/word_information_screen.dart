import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vocabnotes/data_models/english_word_model.dart';
import 'package:vocabnotes/features/library/presentation/bloc/library_bloc.dart';
import 'package:vocabnotes/features/lookup/presentation/widgets/word_information.dart';

class WordInformationScreen extends StatelessWidget {
  const WordInformationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hello'),
      ),
      body: const Placeholder(),
    );
  }
}

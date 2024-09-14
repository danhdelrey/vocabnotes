import 'package:flutter/material.dart';
import 'package:vocabnotes/common/widgets/search_field.dart';
import 'package:vocabnotes/features/lookup/presentation/bloc/word_information_bloc.dart';
import 'package:vocabnotes/features/lookup/presentation/widgets/tappable_word.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LookupScreen extends StatefulWidget {
  const LookupScreen({super.key});

  @override
  State<LookupScreen> createState() => _LookupScreenState();
}

class _LookupScreenState extends State<LookupScreen> {
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
      create: (context) => WordInformationBloc(),
      child: Scaffold(
        appBar: AppBar(
          title: SearchField(
            textEditingController: _textEditingController,
            hintText: 'Look up word online',
            
          ),
        ),
        body: SingleChildScrollView(
          child: BlocBuilder<WordInformationBloc, WordInformationState>(
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildWordTitle(
                      context: context, word: 'record', phonetic: '/ˈɹɛkɔːd/'),
                  const Text('noun'),
                  const Text(
                      'A disk, usually made of a polymer, used to record sound for playback on a phonograph.'),
                  const Text('E.g. This is the example'),
                  const Text(
                      'A disk, usually made of a polymer, used to record sound for playback on a phonograph.'),
                  const Text('E.g. This is the example'),
                  const Text(
                      'A disk, usually made of a polymer, used to record sound for playback on a phonograph.'),
                  const Text('E.g. This is the example'),
                  const Text('synonyms'),
                  _buildRelatedWords(
                    title: 'synonyms',
                    wordList: ['hello', 'hello'],
                  ),
                  _buildRelatedWords(
                    title: 'antonym',
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Column _buildWordTitle({required context, required word, phonetic}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          word,
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        if (phonetic != null)
          Text(phonetic!, style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }

  _buildRelatedWords({List<String>? wordList, required title}) {
    return Column(
      children: [
        if (wordList != null) Text(title),
        if (wordList != null)
          Wrap(
            children: [
              ...wordList.map(
                (word) => TappableWord(word: word),
              ),
            ],
          ),
      ],
    );
  }
}

import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:vocabnotes/data_models/english_word_model.dart';
import 'package:vocabnotes/database/word_database.dart';

part 'multiple_choice_event.dart';
part 'multiple_choice_state.dart';

class MultipleChoiceBloc
    extends Bloc<MultipleChoiceEvent, MultipleChoiceState> {
  MultipleChoiceBloc() : super(MultipleChoiceInitial()) {
    on<GetQuestionsEvent>((event, emit) async {
      emit(QuestionsLoading());
      final database =
          await $FloorWordDatabase.databaseBuilder('word_database.db').build();
      final wordDao = database.wordDao;

      final englishWordModelList = await wordDao.getAllWordsInDatabase();
      englishWordModelList!.shuffle();
      final fourRandomWords = englishWordModelList.take(4).toList();

      List<Map<String, String>> wordWithDefinitionMapList = [];

      for (var word in fourRandomWords) {
        Map<String, String> wordWithDefinition = {
          'word': _getRandomWordWithDefinition(word)['word']!,
          'definition': _getRandomWordWithDefinition(word)['definition']!
        };
        wordWithDefinitionMapList.add(wordWithDefinition);
      }

      String word = wordWithDefinitionMapList[0]['word']!;
      String correctAnswer = wordWithDefinitionMapList[0]['definition']!;

      wordWithDefinitionMapList.shuffle();

      emit(QuestionsLoaded(
          word: word,
          correctAnswer: correctAnswer,
          choices: wordWithDefinitionMapList));
    });

    on<ChooseAnswerEvent>((event, emit) {
      if (event.answer == event.correctAnswer) {
        emit(CorrectAnswer());
      } else {
        emit(IncorrectAnswer(chosen: event.answer));
      }
    });
  }
}

Map<String, String> _getRandomWordWithDefinition(EnglishWordModel word) {
  Random random = Random();
  Map<String, String> wordAndDefinition;

  final randomMeaning =
      word.decodedMeanings[random.nextInt(word.decodedMeanings.length)];
  List<dynamic> definitions = randomMeaning['definitions'];
  String randomDefinition =
      definitions[random.nextInt(definitions.length)]['definition'];

  wordAndDefinition = {'word': word.name, 'definition': randomDefinition};
  return wordAndDefinition;
}

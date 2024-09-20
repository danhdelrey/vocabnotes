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
      try {
        emit(QuestionsLoading());
        final database = await $FloorWordDatabase
            .databaseBuilder('word_database.db')
            .build();
        final wordDao = database.wordDao;

        final englishWordModelList = await wordDao.getAllWordsInDatabase();
        englishWordModelList!.shuffle();

        final fourRandomWords = englishWordModelList.take(4).toList();

        String word = fourRandomWords[0].name;

        List<String> answers = [];
        answers.add(_getRandomDefinition(fourRandomWords[0]));
        answers.add(_getRandomDefinition(fourRandomWords[1]));
        answers.add(_getRandomDefinition(fourRandomWords[2]));
        answers.add(_getRandomDefinition(fourRandomWords[4]));
        answers.shuffle();

        emit(QuestionsLoaded(
            word: word,
            a: answers[0],
            b: answers[1],
            c: answers[2],
            d: answers[3]));
      } catch (e) {
        emit(QuestionsFailure());
      }
    });
  }
}

String _getRandomDefinition(EnglishWordModel word) {
  Random random = Random();
  final randomMeaning =
      word.decodedMeanings[random.nextInt(word.decodedMeanings.length)];
  List<dynamic> definitions = randomMeaning['definitions'];
  String randomDefinition =
      definitions[random.nextInt(definitions.length)]['definition'];
  return randomDefinition;
}

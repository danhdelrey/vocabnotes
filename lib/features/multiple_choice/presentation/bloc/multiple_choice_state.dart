part of 'multiple_choice_bloc.dart';

sealed class MultipleChoiceState extends Equatable {
  const MultipleChoiceState();

  @override
  List<Object> get props => [];
}

final class MultipleChoiceInitial extends MultipleChoiceState {}

final class QuestionsLoading extends MultipleChoiceState {}

final class QuestionsLoaded extends MultipleChoiceState {
  final String word;
  final String correctAnswer;
  final String a;
  final String b;
  final String c;
  final String d;

  const QuestionsLoaded(
      {required this.word,
      required this.correctAnswer,
      required this.a,
      required this.b,
      required this.c,
      required this.d});
}

final class QuestionsFailure extends MultipleChoiceState {}

final class CorrectAnswer extends MultipleChoiceState {}

final class IncorrectAnswer extends MultipleChoiceState {}

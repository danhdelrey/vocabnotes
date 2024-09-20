part of 'multiple_choice_bloc.dart';

sealed class MultipleChoiceEvent extends Equatable {
  const MultipleChoiceEvent();

  @override
  List<Object> get props => [];
}

final class GetQuestionsEvent extends MultipleChoiceEvent {}

final class ChooseAnswerEvent extends MultipleChoiceEvent {
  final String answer;
  final String correctAnswer;

  const ChooseAnswerEvent({required this.answer, required this.correctAnswer});
}

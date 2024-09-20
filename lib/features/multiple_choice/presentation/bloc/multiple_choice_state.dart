part of 'multiple_choice_bloc.dart';

sealed class MultipleChoiceState extends Equatable {
  const MultipleChoiceState();
  
  @override
  List<Object> get props => [];
}

final class MultipleChoiceInitial extends MultipleChoiceState {}

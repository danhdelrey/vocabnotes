part of 'writing_cubit.dart';

sealed class WritingState extends Equatable {
  const WritingState();

  @override
  List<Object> get props => [];
}

final class WritingInitial extends WritingState {}

final class WritingInProgress extends WritingState {}

final class WritingSuccess extends WritingState {
  final Map<String, dynamic> evaluation;

  const WritingSuccess({required this.evaluation});
}

final class WritingFailure extends WritingState {}

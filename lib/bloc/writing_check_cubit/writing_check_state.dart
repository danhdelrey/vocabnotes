part of 'writing_check_cubit.dart';

sealed class WritingCheckState extends Equatable {
  const WritingCheckState();

  @override
  List<Object> get props => [];
}

final class WritingCheckInitial extends WritingCheckState {}

final class WritingCheckInProgress extends WritingCheckState {}

final class WritingCheckSuccess extends WritingCheckState {
  final List<String> randomWordList;

  WritingCheckSuccess({required this.randomWordList});
}

final class WritingCheckFailure extends WritingCheckState {}

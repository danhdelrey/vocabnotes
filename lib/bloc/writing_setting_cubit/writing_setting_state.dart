part of 'writing_setting_cubit.dart';

sealed class WritingSettingState extends Equatable {
  const WritingSettingState();

  @override
  List<Object> get props => [];
}

final class WritingSettingInitial extends WritingSettingState {}

final class WritingSettingFetchedSuccess extends WritingSettingState {
  final int wordsUsed;

  const WritingSettingFetchedSuccess({required this.wordsUsed});
}

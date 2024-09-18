part of 'short_stories_setting_bloc.dart';

sealed class ShortStoriesSettingState extends Equatable {
  const ShortStoriesSettingState();

  @override
  List<Object> get props => [];
}

final class ShortStoriesSettingInitial extends ShortStoriesSettingState {}

final class ShortStoriesSettingFetched extends ShortStoriesSettingState {
  final String genre;
  final String level;
  final String length;
  final int wordsUsed;

  const ShortStoriesSettingFetched(
      {required this.genre,
      required this.level,
      required this.length,
      required this.wordsUsed});
}

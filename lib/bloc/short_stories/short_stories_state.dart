part of 'short_stories_bloc.dart';

sealed class ShortStoriesState extends Equatable {
  const ShortStoriesState();

  @override
  List<Object> get props => [];
}

final class ShortStoriesInitial extends ShortStoriesState {}

final class ShortStoriesGenerating extends ShortStoriesState {}

final class ShortStoriesGeneratedSuccess extends ShortStoriesState {
  final List<dynamic> shortStory;
  final List<String> wordList;

  const ShortStoriesGeneratedSuccess({required this.shortStory,required this.wordList});
}

final class ShortStoriesGeneratedFailure extends ShortStoriesState {}

final class ShortStoriesTranslated extends ShortStoriesState {}

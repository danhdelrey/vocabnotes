part of 'short_stories_bloc.dart';

sealed class ShortStoriesEvent extends Equatable {
  const ShortStoriesEvent();

  @override
  List<Object> get props => [];
}

final class GenerateShortStory extends ShortStoriesEvent {
  
}

final class TranslateStoryIntoVietnamese extends ShortStoriesEvent {}

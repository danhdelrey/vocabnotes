part of 'short_stories_bloc.dart';

sealed class ShortStoriesEvent extends Equatable {
  const ShortStoriesEvent();

  @override
  List<Object> get props => [];
}

final class GenerateShortStory extends ShortStoriesEvent {
  final String genre;
  final String level;
  final String length;
  final int numberOfWordsInUse;

  const GenerateShortStory( 
      {required this.numberOfWordsInUse,
      required this.genre,
      required this.level,
      required this.length,
      });
}

final class TranslateStoryIntoVietnamese extends ShortStoriesEvent {}

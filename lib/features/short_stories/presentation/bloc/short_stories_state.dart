part of 'short_stories_bloc.dart';

sealed class ShortStoriesState extends Equatable {
  const ShortStoriesState();
  
  @override
  List<Object> get props => [];
}

final class ShortStoriesInitial extends ShortStoriesState {}

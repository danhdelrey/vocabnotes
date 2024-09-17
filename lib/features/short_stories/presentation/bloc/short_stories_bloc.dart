import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'short_stories_event.dart';
part 'short_stories_state.dart';

class ShortStoriesBloc extends Bloc<ShortStoriesEvent, ShortStoriesState> {
  ShortStoriesBloc() : super(ShortStoriesInitial()) {
    on<GenerateShortStory>((event, emit) {
      try {
        emit(ShortStoriesGenerating());
      } catch (e) {
        emit(ShortStoriesGeneratedFailure());
      }
    });
  }
}

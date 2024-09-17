import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'short_stories_event.dart';
part 'short_stories_state.dart';

class ShortStoriesBloc extends Bloc<ShortStoriesEvent, ShortStoriesState> {
  ShortStoriesBloc() : super(ShortStoriesInitial()) {
    on<ShortStoriesEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}

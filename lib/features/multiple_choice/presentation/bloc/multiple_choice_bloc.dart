import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'multiple_choice_event.dart';
part 'multiple_choice_state.dart';

class MultipleChoiceBloc extends Bloc<MultipleChoiceEvent, MultipleChoiceState> {
  MultipleChoiceBloc() : super(MultipleChoiceInitial()) {
    on<MultipleChoiceEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}

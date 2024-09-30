import 'package:bloc/bloc.dart';

class WritingCubit extends Cubit<String> {
  WritingCubit() : super('');

  void startWriting(String text) {
    emit(text);
  }
}

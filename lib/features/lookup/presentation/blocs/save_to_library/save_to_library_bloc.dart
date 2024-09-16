import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:vocabnotes/data_models/english_word_model.dart';
import 'package:vocabnotes/database/word_database.dart';

part 'save_to_library_event.dart';
part 'save_to_library_state.dart';

class SaveToLibraryBloc extends Bloc<SaveToLibraryEvent, SaveToLibraryState> {
  SaveToLibraryBloc() : super(SaveToLibraryInitial()) {
    on<SaveWordToLibraryEvent>((event, emit) async {
      emit(SaveToLibraryLoading());
      final database =
          await $FloorWordDatabase.databaseBuilder('word_database.db').build();
      final wordDao = database.wordDao;

      final wordCount = await wordDao.countWord(event.wordList[0].name);
      if (wordCount == 0) {
        await wordDao.insertWord(event.wordList);
        emit(const SaveToLibrarySuccess(
            message: 'Successfully added to library'));
      } else {
        emit(const SaveToLibraryFailure(
            message: 'Word already exists in library'));
      }
    });
  }
}

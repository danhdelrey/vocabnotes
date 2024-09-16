import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:vocabnotes/database/word_database.dart';
import 'package:vocabnotes/features/library/presentation/widgets/word_list_tile.dart';

part 'library_event.dart';
part 'library_state.dart';

class LibraryBloc extends Bloc<LibraryEvent, LibraryState> {
  LibraryBloc() : super(LibraryInitial()) {
    on<GetAllWordsFromDatabaseEvent>((event, emit) async {
      emit(LibraryLoading());
      try {
        final database = await $FloorWordDatabase
            .databaseBuilder('word_database.db')
            .build();

        final wordDao = database.wordDao;

        List<WordListTile> wordListTiles = [];

        final listOfWords = await wordDao.getAllWordsInDatabase();
        if (listOfWords!.isNotEmpty) {
          for (var word in listOfWords) {
            WordListTile wordListTile = WordListTile(
              word: word.name,
              firstMeaning: word.decodedMeanings[0]['definitions']
                  ['definition'],
              phonetic: word.phonetic,
            );
            wordListTiles.add(wordListTile);
          }
          emit(Libraryloaded(wordListTiles: wordListTiles));
        } else {
          emit(LibraryEmpty());
        }
      } catch (e) {
        emit(LibraryError());
      }
    });
  }
}

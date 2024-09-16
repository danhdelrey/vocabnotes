part of 'library_bloc.dart';

sealed class LibraryState extends Equatable {
  const LibraryState();

  @override
  List<Object> get props => [];
}

final class LibraryInitial extends LibraryState {}

final class LibraryLoading extends LibraryState {}

final class LibraryError extends LibraryState {
  
}

final class LibraryEmpty extends LibraryState {}


final class Libraryloaded extends LibraryState {
  final List<WordListTile> wordListTiles;
  Libraryloaded({required this.wordListTiles});
}

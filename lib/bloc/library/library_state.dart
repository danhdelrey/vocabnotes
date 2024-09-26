part of 'library_bloc.dart';

sealed class LibraryState extends Equatable {
  const LibraryState();

  @override
  List<Object> get props => [];
}

final class LibraryInitial extends LibraryState {}

final class LibraryLoading extends LibraryState {}

final class LibraryError extends LibraryState {}

final class LibraryEmpty extends LibraryState {}

final class Libraryloaded extends LibraryState {
  final List<WordListTile> wordListTiles;
  const Libraryloaded({required this.wordListTiles});
}
final class WordDeleteSuccess extends LibraryState {}

final class WordDeleteFailure extends LibraryState {}

final class GetWordLoading extends LibraryState {}

final class GetWordSucess extends LibraryState {
  final EnglishWordModel englishWordModel;

  const GetWordSucess({required this.englishWordModel});
}

final class GetWordFailure extends LibraryState {}

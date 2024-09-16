part of 'library_bloc.dart';

sealed class LibraryEvent extends Equatable {
  const LibraryEvent();

  @override
  List<Object> get props => [];
}

final class GetAllWordsFromDatabaseEvent extends LibraryEvent {}

final class DeleteWordFromDatabase extends LibraryEvent {
  final String id;

  const DeleteWordFromDatabase(
      {required this.id});
}

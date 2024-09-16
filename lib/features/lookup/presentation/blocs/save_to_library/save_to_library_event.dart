part of 'save_to_library_bloc.dart';

sealed class SaveToLibraryEvent extends Equatable {
  const SaveToLibraryEvent();

  @override
  List<Object> get props => [];
}

final class SaveWordToLibraryEvent extends SaveToLibraryEvent {
  final List<EnglishWordModel> wordList;
  const SaveWordToLibraryEvent({required this.wordList});
}

part of 'save_to_library_bloc.dart';

sealed class SaveToLibraryState extends Equatable {
  const SaveToLibraryState();

  @override
  List<Object> get props => [];
}

final class SaveToLibraryInitial extends SaveToLibraryState {}

class SaveToLibraryLoading extends SaveToLibraryState {}

class SaveToLibrarySuccess extends SaveToLibraryState {
  final String message;
  const SaveToLibrarySuccess({required this.message});
}

class SaveToLibraryFailure extends SaveToLibraryState {
  final String message;
  const SaveToLibraryFailure({required this.message});
}

part of 'word_information_bloc.dart';

sealed class WordInformationState extends Equatable {
  const WordInformationState();

  @override
  List<Object> get props => [];
}

final class WordInformationInitial extends WordInformationState {}

final class WordInformationLoaded extends WordInformationState {
  final List<EnglishWordModel> englishWordModelList;
  final String searchedWord;

  const WordInformationLoaded(
      {required this.searchedWord, required this.englishWordModelList});
}

final class WordInformationloading extends WordInformationState {}

final class WordInformationError extends WordInformationState {
  
}

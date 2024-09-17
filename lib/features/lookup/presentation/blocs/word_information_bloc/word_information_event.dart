part of 'word_information_bloc.dart';

sealed class WordInformationEvent extends Equatable {
  const WordInformationEvent();

  @override
  List<Object> get props => [];
}

final class GetWordInformationEvent extends WordInformationEvent {
  final String word;

  const GetWordInformationEvent({required this.word});
}

final class LookupWordEvent extends WordInformationEvent {
  final String word;

  const LookupWordEvent({required this.word});
}

part of 'translate_definitions_bloc.dart';

sealed class TranslateDefinitionsEvent extends Equatable {
  const TranslateDefinitionsEvent();

  @override
  List<Object> get props => [];
}

final class TranslateDefinitionsPressed extends TranslateDefinitionsEvent {
  final String definition;
  final String? example;

  const TranslateDefinitionsPressed(
      {required this.definition, required this.example});
}

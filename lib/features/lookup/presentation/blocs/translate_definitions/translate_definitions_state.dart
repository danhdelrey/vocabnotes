part of 'translate_definitions_bloc.dart';

sealed class TranslateDefinitionsState extends Equatable {
  const TranslateDefinitionsState();

  @override
  List<Object> get props => [];
}

final class TranslateDefinitionsInitial extends TranslateDefinitionsState {}

final class TranslateDefinitionsInProgress extends TranslateDefinitionsState {}

final class TranslateDefinitionsSuccess extends TranslateDefinitionsState {
  final String translatedDefinition;
  final String? translatedExample;

  const TranslateDefinitionsSuccess(
      {required this.translatedDefinition, required this.translatedExample});
}

final class TranslateDefinitionsFailure extends TranslateDefinitionsState {}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vocabnotes/features/lookup/presentation/blocs/translate_definitions/translate_definitions_bloc.dart';

class DefinitionWithExample extends StatelessWidget {
  const DefinitionWithExample({
    super.key,
    required this.definition,
    required this.example,
  });

  final String definition;
  final String? example;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TranslateDefinitionsBloc(),
      child: Builder(builder: (context) {
        return InkWell(
          onTap: () {
            context.read<TranslateDefinitionsBloc>().add(
                TranslateDefinitionsPressed(
                    definition: definition, example: example));
          },
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '> $definition',
                  style: const TextStyle().copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (example != null)
                  Text(
                    'E.g. $example',
                  ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

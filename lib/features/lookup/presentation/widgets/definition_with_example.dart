import 'package:flutter/material.dart';

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '> $definition',
          style: const TextStyle().copyWith(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        if(example != null)
        Text(
          'E.g. $example',
        ),
        const SizedBox(
          height: 15,
        )
      ],
    );
  }
}

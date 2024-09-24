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
    return InkWell(
      onTap: () {},
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
  }
}

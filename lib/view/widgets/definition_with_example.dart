import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:vocabnotes/bloc/translate_definitions/translate_definitions_bloc.dart';

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
        return Padding(
          padding: const EdgeInsets.only(left: 5, right: 5, bottom: 5),
          child:
              BlocBuilder<TranslateDefinitionsBloc, TranslateDefinitionsState>(
            builder: (context, state) {
              if (state is TranslateDefinitionsInitial) {
                return InkWell(
                  onTap: () {
                    context.read<TranslateDefinitionsBloc>().add(
                        TranslateDefinitionsPressed(
                            definition: definition, example: example));
                  },
                  borderRadius: BorderRadius.circular(4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        definition,
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
                );
              } else if (state is TranslateDefinitionsInProgress) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      definition,
                      style: const TextStyle().copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (example != null)
                      Text(
                        'E.g. $example',
                      ),
                    Skeletonizer(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            definition,
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
                    )
                  ],
                );
              } else if (state is TranslateDefinitionsSuccess) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      definition,
                      style: const TextStyle().copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (example != null)
                      Text(
                        'E.g. $example',
                      ),
                    Text(state.translatedDefinition,
                        style: GoogleFonts.roboto(
                          color: const Color(0xffff66b3),
                          fontWeight: FontWeight.bold,
                        )),
                    if (example != null)
                      Text('E.g. ${state.translatedExample}',
                          style: GoogleFonts.roboto()),
                  ],
                );
              } else {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      definition,
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
                );
              }
            },
          ),
        );
      }),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:vocabnotes/app/routes.dart';
import 'package:vocabnotes/bloc/learning_cubit/learning_cubit.dart';

class LearningScreen extends StatelessWidget {
  const LearningScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LearningCubit()..countWordsFromLibrary(),
      child: Builder(builder: (context) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Learning'),
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'Words in library',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                BlocBuilder<LearningCubit, int>(
                  builder: (context, state) {
                    return Center(
                      child: Text(
                        state.toString(),
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium!
                            .copyWith(
                              color: state > 0
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context).colorScheme.error,
                            ),
                      ),
                    );
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Text(
                    'Choose a learning mode:',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ),
                ListTile(
                  title: Text(
                    'Short stories',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle().copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  subtitle: const Text(
                    'Expand your vocabulary with AI-generated short stories.',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: FilledButton(
                    onPressed: () {
                      navigateTo(
                          appRoute: AppRoute.shortStories,
                          context: context,
                          replacement: false);
                    },
                    child: const Text('Start'),
                  ),
                ),
                ListTile(
                  title: Text(
                    'Multiple choice',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle().copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  subtitle: const Text(
                    'Create multiple-choice quizzes from your library.',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: FilledButton(
                    onPressed: () {
                      navigateTo(
                          appRoute: AppRoute.multipleChoice,
                          context: context,
                          replacement: false);
                    },
                    child: const Text('Start'),
                  ),
                ),
                ListTile(
                  title: Text(
                    'Writing',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle().copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  subtitle: const Text(
                    'Write a sentence/paragraph using the provided words.',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: FilledButton(
                    onPressed: () {
                      navigateTo(
                          appRoute: AppRoute.writing,
                          context: context,
                          replacement: false);
                    },
                    child: const Text('Start'),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:vocabnotes/app/theme.dart';
import 'package:vocabnotes/bloc/theme_switch_cubit/theme_switch_cubit.dart';
import 'package:vocabnotes/view/widgets/search_field.dart';
import 'package:vocabnotes/app/routes.dart';
import 'package:vocabnotes/bloc/save_to_library/save_to_library_bloc.dart';
import 'package:vocabnotes/bloc/word_information/word_information_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vocabnotes/view/widgets/word_information.dart';

class LookupScreen extends StatefulWidget {
  const LookupScreen({super.key});

  @override
  State<LookupScreen> createState() => _LookupScreenState();
}

class _LookupScreenState extends State<LookupScreen> {
  late TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _textEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WordInformationBloc(),
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: _buildAppBar(context),
            drawer: Drawer(
              child: Column(
                children: [
                  const Spacer(),
                  BlocBuilder<ThemeSwitchCubit, ThemeMode>(
                    builder: (context, state) {
                      return ListTile(
                        leading:
                            const HugeIcon(icon: HugeIcons.strokeRoundedMoon02),
                        title: const Text('Dark mode'),
                        trailing: Switch(
                          value: state == ThemeMode.dark,
                          onChanged: (value) {
                            context.read<ThemeSwitchCubit>().themeSwitching();
                          },
                        ),
                      );
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
            body: SizedBox(
              width: double.infinity,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.auto_awesome,
                        size: 72,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'More features coming soon!',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Stay tuned for more updates as we continue to enhance your experience.',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.color
                                  ?.withOpacity(0.7),
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text('Look up'),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: SearchField(
          textEditingController: _textEditingController,
          hintText: 'Look up a word or phrase online',
          onSubmit: (value) {
            navigateTo(
              appRoute: AppRoute.lookupWordInformation,
              context: context,
              replacement: false,
              data: value,
            );
          },
        ),
      ),
    );
  }
}

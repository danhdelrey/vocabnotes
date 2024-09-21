import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:vocabnotes/common/widgets/search_field.dart';
import 'package:vocabnotes/config/routes.dart';
import 'package:vocabnotes/features/lookup/presentation/blocs/save_to_library/save_to_library_bloc.dart';
import 'package:vocabnotes/features/lookup/presentation/blocs/word_information_bloc/word_information_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vocabnotes/features/lookup/presentation/widgets/word_information.dart';

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
          hintText: 'Search for a word or phrase',
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

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vocabnotes/bloc/writing_setting_cubit/writing_setting_cubit.dart';

class WritingSettingScreen extends StatelessWidget {
  const WritingSettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WritingSettingCubit()..getSetting(),
      child: Builder(builder: (context) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Customize'),
          ),
          body: Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, top: 20),
            child: BlocBuilder<WritingSettingCubit, WritingSettingState>(
              builder: (context, state) {
                if (state is WritingSettingFetchedSuccess) {
                  return Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            'Words used',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          const Spacer(),
                          DropdownMenu(
                            initialSelection: state.wordsUsed,
                            onSelected: (value) {
                              context.read<WritingSettingCubit>().changeSetting(
                                  key: 'wordsUsedInWriting',
                                  value: value.toString());
                            },
                            dropdownMenuEntries: const [
                              DropdownMenuEntry(value: 2, label: '2'),
                              DropdownMenuEntry(value: 4, label: '4'),
                              DropdownMenuEntry(value: 6, label: '6'),
                            ],
                          ),
                        ],
                      ),
                    ],
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
        );
      }),
    );
  }
}

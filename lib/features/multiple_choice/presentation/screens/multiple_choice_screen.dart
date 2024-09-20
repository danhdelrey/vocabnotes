import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class MultipleChoiceScreen extends StatelessWidget {
  const MultipleChoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ThemeData().scaffoldBackgroundColor,
        elevation: 0,
        surfaceTintColor: ThemeData().scaffoldBackgroundColor,
        title: const Text('Multiple choice'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, top: 40),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'in the nick of time',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(color: Theme.of(context).colorScheme.primary),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  'Choose the correct definition:',
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                const SizedBox(
                  height: 10,
                ),
                _buildChoice(context),
                _buildChoice(context),
                _buildChoice(context),
                _buildChoice(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _buildChoice(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(5),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).colorScheme.outlineVariant,
            ),
            borderRadius: BorderRadius.circular(5),
          ),
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
                'definitiondefinitiondefinitiondefinitiondefinitiondefinitiondefinitiondefinitiondefinit'),
          ),
        ),
      ),
    );
  }
}

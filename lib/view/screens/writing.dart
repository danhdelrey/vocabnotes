import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:vocabnotes/app/routes.dart';

class Writing extends StatefulWidget {
  const Writing({super.key});

  @override
  State<Writing> createState() => _WritingState();
}

class _WritingState extends State<Writing> {
  late TextEditingController _textEditingController;
  final FocusNode _focusNode = FocusNode();

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Writing'),
        actions: [
          IconButton(
              onPressed: () {
                navigateTo(
                    appRoute: AppRoute.writingSetting,
                    context: context,
                    replacement: false);
              },
              icon: const Icon(HugeIcons.strokeRoundedEdit02))
        ],
      ),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Write a sentence using all of these words:',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Wrap(
                      spacing: 5,
                      runSpacing: 5,
                      children: [
                        _buildTappableWord(context),
                        _buildTappableWord(context),
                        _buildTappableWord(context),
                        _buildTappableWord(context),
                        _buildTappableWord(context),
                        _buildTappableWord(context),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Your sentence:',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    Text(
                      'this is my sentence this is my sentence this is my sentence this is my sentence',
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: Theme.of(context).colorScheme.tertiary,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
              child: TextField(
                onTapOutside: (event) {
                  FocusScope.of(context).unfocus();
                },
                style: Theme.of(context).textTheme.bodyMedium,
                focusNode: _focusNode,
                controller: _textEditingController,
                onSubmitted: null,
                decoration: InputDecoration(
                  suffixIcon: const Icon(HugeIcons.strokeRoundedSent),
                  hintText: 'hint text',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(0),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  InkWell _buildTappableWord(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(4),
      onTap: () {
        navigateTo(
            appRoute: AppRoute.lookupWordInformation,
            context: context,
            replacement: false,
            data: 'happy');
      },
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).colorScheme.primary),
            borderRadius: BorderRadius.circular(4)),
        child: Padding(
          padding: const EdgeInsets.only(left: 4, right: 4),
          child: Text(
            'happy',
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
        ),
      ),
    );
  }
}

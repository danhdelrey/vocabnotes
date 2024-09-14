import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Library'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Container(
            decoration:
                BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor),
            child: TextField(
              controller: _textEditingController,
              onSubmitted: (value){},
              decoration: InputDecoration(
                hintText: 'Search in library',
                prefixIcon: const Icon(HugeIcons.strokeRoundedSearch02),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(28.0),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
              ),
            ),
          ),
        ),
      ),
      body: const Placeholder(),
    );
  }
}

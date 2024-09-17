import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class ShortStoriesScreen extends StatelessWidget {
  const ShortStoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Short stories'),
        actions: [
          IconButton(
              onPressed: () {}, icon: const Icon(HugeIcons.strokeRoundedEdit02))
        ],
      ),
      body: const Placeholder(),
    );
  }
}

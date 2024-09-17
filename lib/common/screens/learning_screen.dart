import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class LearningScreen extends StatelessWidget {
  const LearningScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Learning'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              title: Text(
                'Short stories',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle().copyWith(fontWeight: FontWeight.bold),
              ),
              subtitle: const Text(
                'Learning vocabulary by AI-generated short stories.',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: FilledButton(
                onPressed: () {},
                child: const Text('Start'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

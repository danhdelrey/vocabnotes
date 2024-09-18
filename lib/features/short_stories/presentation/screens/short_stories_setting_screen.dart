import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShortStoriesSettingScreen extends StatelessWidget {
  const ShortStoriesSettingScreen({super.key});

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customize'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  'Genre',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const Spacer(),
                DropdownMenu(
                  initialSelection: 'Comedy',
                  onSelected: (value) async {
                    

                  },
                  dropdownMenuEntries: const [
                    DropdownMenuEntry(value: 'Comedy', label: 'Comedy'),
                    DropdownMenuEntry(value: 'Drama', label: 'Drama'),
                    DropdownMenuEntry(value: 'Fantasy', label: 'Fantasy'),
                    DropdownMenuEntry(value: 'Horror', label: 'Horror'),
                    DropdownMenuEntry(value: 'Romance', label: 'Romance'),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              children: [
                Text(
                  'Level',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const Spacer(),
                DropdownMenu(
                  initialSelection: 'B1',
                  onSelected: (value) {
                    level = value!;
                  },
                  dropdownMenuEntries: const [
                    DropdownMenuEntry(value: 'A1', label: 'A1'),
                    DropdownMenuEntry(value: 'A2', label: 'A2'),
                    DropdownMenuEntry(value: 'B1', label: 'B1'),
                    DropdownMenuEntry(value: 'B2', label: 'B2'),
                    DropdownMenuEntry(value: 'C1', label: 'C1'),
                    DropdownMenuEntry(value: 'C2', label: 'C2'),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              children: [
                Text(
                  'Length',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const Spacer(),
                DropdownMenu(
                  initialSelection: '100 words',
                  onSelected: (value) {
                    length = value!;
                  },
                  dropdownMenuEntries: const [
                    DropdownMenuEntry(value: '100 words', label: '100 words'),
                    DropdownMenuEntry(value: '150 words', label: '150 words'),
                    DropdownMenuEntry(value: '200 words', label: '200 words'),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              children: [
                Text(
                  'Words used',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const Spacer(),
                DropdownMenu(
                  initialSelection: 2,
                  onSelected: (value) {
                    wordsUsed = value!;
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
        ),
      ),
    );
  }
}

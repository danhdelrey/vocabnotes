import 'package:flutter/material.dart';

class WritingSettingScreen extends StatelessWidget {
  const WritingSettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customize'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15, top: 20),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  'Words used',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const Spacer(),
                DropdownMenu(
                  initialSelection: 2,
                  onSelected: (value) {},
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

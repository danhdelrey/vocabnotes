import 'package:flutter/material.dart';
import 'package:vocabnotes/config/theme.dart';

class TappableWord extends StatelessWidget {
  const TappableWord({
    super.key,
    required this.word,
  });

  final String word;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2),
      child: InkWell(
        onTap: () {
          
        },
        borderRadius: BorderRadius.circular(7),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(7),
              border: Border.all(color: kColorScheme.outlineVariant)),
          padding: const EdgeInsets.all(4),
          child: Text(word),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class WordListTile extends StatelessWidget {
  const WordListTile(
      {super.key,
      required this.word,
      this.phonetic,
      required this.firstMeaning});
  final String word;
  final String? phonetic;
  final String firstMeaning;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(firstMeaning),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {},
      background: Container(
        color: Colors.red,
      ),
      child: ListTile(
        onTap: () {},
        title: RichText(
          text: TextSpan(
            style: DefaultTextStyle.of(context).style,
            children: [
              TextSpan(
                text: '$word ',
                style: const TextStyle().copyWith(fontWeight: FontWeight.bold),
              ),
              if (phonetic != null) TextSpan(text: phonetic),
            ],
          ),
        ),

        //  Text(
        //   '$word $phonetic',
        //   maxLines: 1,
        //   overflow: TextOverflow.ellipsis,
        //   style: const TextStyle().copyWith(fontWeight: FontWeight.bold),
        // ),
        subtitle: Text(
          firstMeaning,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: const Icon(HugeIcons.strokeRoundedArrowRight01),
      ),
    );
  }
}

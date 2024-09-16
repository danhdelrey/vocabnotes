import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:vocabnotes/config/routes.dart';
import 'package:vocabnotes/features/library/presentation/bloc/library_bloc.dart';

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
    return BlocProvider(
      create: (context) => LibraryBloc(),
      child: Dismissible(
        key: Key(firstMeaning),
        direction: DismissDirection.endToStart,
        confirmDismiss: (direction) async {
          return await showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text('Delete from library?'),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    child: const Text('Cancel')),
                FilledButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                      context.read<LibraryBloc>().add(DeleteWordFromDatabase(
                          wordName: word, firstMeaning: firstMeaning));
                    },
                    child: const Text('Yes'))
              ],
            ),
          );
        },
        onDismissed: (direction) {},
        background: Container(
          color: Colors.red,
          child: const Center(child: Icon(HugeIcons.strokeRoundedRemove01)),
        ),
        child: ListTile(
          onTap: () {
            navigateTo(
                appRoute: AppRoute.wordInformation,
                context: context,
                replacement: false);
          },
          title: RichText(
            text: TextSpan(
              style: DefaultTextStyle.of(context).style,
              children: [
                TextSpan(
                  text: '$word ',
                  style:
                      const TextStyle().copyWith(fontWeight: FontWeight.bold),
                ),
                if (phonetic != null) TextSpan(text: phonetic),
              ],
            ),
          ),
          subtitle: Text(
            firstMeaning,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: const Icon(HugeIcons.strokeRoundedArrowRight01),
        ),
      ),
    );
  }
}

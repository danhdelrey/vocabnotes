import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:vocabnotes/config/theme.dart';
import 'package:vocabnotes/features/short_stories/presentation/bloc/short_stories_bloc.dart';

class ShortStoriesScreen extends StatelessWidget {
  const ShortStoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ShortStoriesBloc(),
      child: Builder(builder: (context) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: ThemeData().scaffoldBackgroundColor,
            elevation: 0,
            surfaceTintColor: ThemeData().scaffoldBackgroundColor,
            title: const Text('Short stories'),
            actions: [
              IconButton(
                  onPressed: () {},
                  icon: const Icon(HugeIcons.strokeRoundedEdit02))
            ],
          ),
          body: Stack(
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 25, right: 25, top: 30, bottom: 90),
                  child: SingleChildScrollView(
                    child: BlocBuilder<ShortStoriesBloc, ShortStoriesState>(
                      builder: (context, state) {
                        if (state is ShortStoriesGenerating) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (state is ShortStoriesGeneratedSuccess) {
                          return const Text('hello');
                        } else if (state is ShortStoriesGeneratedFailure) {
                          return const Text('Something went wrong');
                        } else
                          return Container();
                      },
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 15, left: 10),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: IconButton(
                      onPressed: () {},
                      icon: const Icon(HugeIcons.strokeRoundedTranslation)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: FilledButton.icon(
                    onPressed: () {
                      context.read<ShortStoriesBloc>().add(
                            const GenerateShortStory(
                                numberOfWordsInUse: 5,
                                genre: 'humourous',
                                level: 'C1',
                                length: '50 words'),
                          );
                    },
                    label: const Text('Generate'),
                    icon: const Icon(HugeIcons.strokeRoundedReload),
                  ),
                ),
              )
            ],
          ),
        );
      }),
    );
  }

  Column _buildSentenceAndTranslation(BuildContext context) {
    return Column(
      children: [
        RichText(
          text: TextSpan(
            children: [
              WidgetSpan(
                child: InkWell(
                  borderRadius: BorderRadius.circular(4),
                  onTap: () {},
                  child: Padding(
                    padding: const EdgeInsets.only(left: 4, right: 4),
                    child: Text(
                      'word',
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: kColorScheme.primary,
                          ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        _buildTranslation(context),
      ],
    );
  }

  Text _buildTranslation(BuildContext context) {
    return Text(
      'Một người đàn ông bước vào thư viện và vui vẻ hỏi thủ thư về những cuốn sách về chứng hoang tưởng.',
      style: Theme.of(context)
          .textTheme
          .bodyMedium!
          .copyWith(fontFamily: 'Roboto'),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:vocabnotes/view/widgets/search_field.dart';
import 'package:vocabnotes/app/routes.dart';
import 'package:vocabnotes/data/english_word_model.dart';
import 'package:vocabnotes/bloc/library/library_bloc.dart';
import 'package:vocabnotes/bloc/save_to_library/save_to_library_bloc.dart';
import 'package:vocabnotes/bloc/word_information/word_information_bloc.dart';
import 'package:vocabnotes/view/widgets/word_information.dart';

class LookupWordInformationScreen extends StatefulWidget {
  const LookupWordInformationScreen({super.key});

  @override
  State<LookupWordInformationScreen> createState() =>
      _LookupWordInformationScreenState();
}

class _LookupWordInformationScreenState
    extends State<LookupWordInformationScreen> {
  late TextEditingController _textEditingController;
  List<EnglishWordModel> englishWordModelList = [];

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
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => WordInformationBloc()
            ..add(GetWordInformationEvent(
                word: ModalRoute.of(context)!.settings.arguments as String)),
        ),
        BlocProvider(
          create: (_) => SaveToLibraryBloc(),
        )
      ],
      child: Builder(builder: (context) {
        return Scaffold(
          body: MultiBlocListener(
            listeners: [
              BlocListener<SaveToLibraryBloc, SaveToLibraryState>(
                listener: (context, state) {
                  if (state is SaveToLibrarySuccess) {
                    ScaffoldMessenger.of(context).clearSnackBars();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.message),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  } else if (state is SaveToLibraryFailure) {
                    ScaffoldMessenger.of(context).clearSnackBars();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.message),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  }
                },
              ),
            ],
            child: BlocBuilder<WordInformationBloc, WordInformationState>(
              builder: (context, state) {
                if (state is WordInformationloading) {
                  return _buildPlaceholder();
                } else if (state is WordInformationLoaded) {
                  englishWordModelList = state.englishWordModelList;
                  return Scaffold(
                    appBar: _buildTopBar(state, context),
                    body: WordInformation(
                        englishWordModelList: englishWordModelList),
                  );
                } else if (state is WordInformationError) {
                  return Scaffold(
                    appBar: AppBar(
                      centerTitle: false,
                      title: Text(
                          ModalRoute.of(context)!.settings.arguments as String),
                      bottom: PreferredSize(
                        preferredSize: const Size.fromHeight(kToolbarHeight),
                        child: SearchField(
                          textEditingController: _textEditingController,
                          hintText: '',
                          onSubmit: (value) {
                            navigateTo(
                              appRoute: AppRoute.lookupWordInformation,
                              context: context,
                              replacement: false,
                              data: value,
                            );
                          },
                        ),
                      ),
                      actions: [
                        IconButton(
                          onPressed: () {
                            Navigator.popUntil(
                                context, (route) => route.isFirst);
                          },
                          icon: HugeIcon(icon: HugeIcons.strokeRoundedHome09),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon:
                              HugeIcon(icon: HugeIcons.strokeRoundedNoteAdd),
                        ),
                      ],
                    ),
                    body: const Center(
                      child: Text('Failed to look up :(('),
                    ),
                  );
                }
                return WordInformation(
                    englishWordModelList: englishWordModelList);
              },
            ),
          ),
        );
      }),
    );
  }

  _buildPlaceholder() {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(ModalRoute.of(context)!.settings.arguments as String),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: SearchField(
            textEditingController: _textEditingController,
            hintText: '',
            onSubmit: (value) {},
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: HugeIcon(icon: HugeIcons.strokeRoundedHome09),
          ),
          IconButton(
            onPressed: () {},
            icon: HugeIcon(icon: HugeIcons.strokeRoundedNoteAdd),
          ),
        ],
      ),
      body: Skeletonizer(
        child: WordInformation(englishWordModelList: [
          EnglishWordModel(
              phonetic: 'recordrecord', name: 'recordrecord', meanings: """[
            {
                "partOfSpeech": "noun",
                "definitions": [
                    {
                        "definition": "A musical instrument producing a sound when struck, similar to a bell (e.g. a tubular metal bar) or actually a bell. Often used in the plural to refer to the set: the chimes.",
                        "synonyms": [],
                        "antonyms": [],
                        "example": "Hugo was a chime player in the school orchestra."
                    },
                    {
                        "definition": "An individual ringing component of such a set.",
                        "synonyms": [],
                        "antonyms": [],
                        "example": "Peter removed the C♯ chime from its mounting so that he could get at the dust that had accumulated underneath."
                    },
                    {
                        "definition": "A small bell or other ringing or tone-making device as a component of some other device.",
                        "synonyms": [],
                        "antonyms": [],
                        "example": "The professor had stuffed a wad of gum into the chime of his doorbell so that he wouldn't be bothered."
                    },
                    {
                        "definition": "The sound of such an instrument or device.",
                        "synonyms": [],
                        "antonyms": [],
                        "example": "The copier gave a chime to indicate that it had finished printing."
                    },
                    {
                        "definition": "A small hammer or other device used to strike a bell.",
                        "synonyms": [],
                        "antonyms": [],
                        "example": "Strike the bell with the brass chime hanging on the chain next to it."
                    }
                ],
                "synonyms": [
                ],
                "antonyms": []
            }
        ]""")
        ]),
      ),
    );
  }

  AppBar _buildTopBar(WordInformationLoaded state, BuildContext context) {
    return AppBar(
      centerTitle: false,
      title: Text(state.englishWordModelList[0].name),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: SearchField(
          textEditingController: _textEditingController,
          hintText: '',
          onSubmit: (value) {
            navigateTo(
              appRoute: AppRoute.lookupWordInformation,
              context: context,
              replacement: false,
              data: value,
            );
          },
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            Navigator.popUntil(context, (route) => route.isFirst);
          },
          icon: HugeIcon(icon: HugeIcons.strokeRoundedHome09),
        ),
        IconButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text('Add to library?'),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Cancel')),
                  FilledButton(
                      onPressed: () {
                        Navigator.pop(context);
                        context.read<SaveToLibraryBloc>().add(
                            SaveWordToLibraryEvent(
                                wordList: state.englishWordModelList));
                      },
                      child: const Text('Yes'))
                ],
              ),
            );
          },
          icon: HugeIcon(icon: HugeIcons.strokeRoundedNoteAdd),
        ),
      ],
    );
  }
}

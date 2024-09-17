import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:vocabnotes/common/widgets/search_field.dart';
import 'package:vocabnotes/config/routes.dart';
import 'package:vocabnotes/data_models/english_word_model.dart';
import 'package:vocabnotes/features/library/presentation/bloc/library_bloc.dart';
import 'package:vocabnotes/features/lookup/presentation/blocs/save_to_library/save_to_library_bloc.dart';
import 'package:vocabnotes/features/lookup/presentation/blocs/word_information_bloc/word_information_bloc.dart';
import 'package:vocabnotes/features/lookup/presentation/widgets/word_information.dart';

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
          appBar: AppBar(
            title: SearchField(
              textEditingController: _textEditingController,
              hintText: '',
              onSubmit: (value) {
                context
                    .read<WordInformationBloc>()
                    .add(LookupWordEvent(word: value));
              },
            ),
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                icon: const Icon(HugeIcons.strokeRoundedHome09),
              )
            ],
          ),
          body: MultiBlocListener(
            listeners: [
              BlocListener<WordInformationBloc, WordInformationState>(
                listener: (context, state) {
                  if (state is WordInformationLookup) {
                    navigateTo(
                      appRoute: AppRoute.lookupWordInformation,
                      context: context,
                      replacement: false,
                      data: state.word,
                    );
                  }
                },
              ),
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
                  return const Center(
                    child: Text('something went wrong'),
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

  Skeletonizer _buildPlaceholder() {
    return Skeletonizer(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: false,
          title: const Text('Lorem ipsum dolor'),
          actions: [
            IconButton(
                onPressed: () {},
                icon: const Icon(HugeIcons.strokeRoundedHome01)),
          ],
        ),
        body: WordInformation(englishWordModelList: [
          EnglishWordModel(phonetic: 'record', name: 'record', meanings: """[
          {
              "partOfSpeech": "noun",
              "definitions": [
                  {
                      "definition": "A disk, usually made of a polymer, used to record sound for playback on a phonograph.",
                      "synonyms": [
                          "gramophone record",
                          "record",
                          "vinyl"
                      ],
                      "antonyms": []
                  }
              ],
              "synonyms": [
                  "gramophone record",
                  "record",
                  "vinyl"
              ],
              "antonyms": []
          },
          {
              "partOfSpeech": "noun",
              "definitions": [
                  {
                      "definition": "An item of information put into a temporary or permanent physical medium.",
                      "synonyms": [],
                      "antonyms": [],
                      "example": "The person had a record of the interview so she could review her notes."
                  },
                  {
                      "definition": "Any instance of a physical medium on which information was put for the purpose of preserving it and making it available for future reference.",
                      "synonyms": [
                          "log"
                      ],
                      "antonyms": [],
                      "example": "We have no record of you making this payment to us."
                  },
                  {
                      "definition": "A set of data relating to a single individual or item.",
                      "synonyms": [],
                      "antonyms": []
                  },
                  {
                      "definition": "The most extreme known value of some variable, particularly that of an achievement in competitive events.",
                      "synonyms": [],
                      "antonyms": [],
                      "example": "The heat and humidity were both new records."
                  }
              ],
              "synonyms": [
                  "log"
              ],
              "antonyms": []
          }
      ]""")
        ]),
      ),
    );
  }

  // Scaffold _buildSearchWordInformationError(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       leading: _searchedWords.isNotEmpty
  //           ? IconButton(
  //               onPressed: () {
  //                 String previousWord = _searchedWords.removeLast();
  //                 context
  //                     .read<WordInformationBloc>()
  //                     .add(GetWordInformationEvent(word: previousWord));
  //               },
  //               icon: const Icon(HugeIcons.strokeRoundedArrowLeft01),
  //             )
  //           : Container(),
  //     ),
  //     body: const Center(
  //       child: Text('something went wrong'),
  //     ),
  //   );
  // }

  AppBar _buildTopBar(WordInformationLoaded state, BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      centerTitle: false,
      title: Text(state.englishWordModelList[0].name),
      actions: [
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
          icon: const Icon(HugeIcons.strokeRoundedNoteAdd),
        ),
      ],
    );
  }
}

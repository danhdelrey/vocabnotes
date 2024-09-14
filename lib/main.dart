import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vocabnotes/bloc/word_information_bloc.dart';

void main() {
  runApp(
    BlocProvider(
      create: (context) => WordInformationBloc()
        ..add(
          const GetWordInformationEvent(word: 'record'),
        ),
      child: MaterialApp(
        home: Scaffold(
          body: BlocBuilder<WordInformationBloc, WordInformationState>(
            builder: (context, state) {
              if (state is WordInformationInitial) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is WordInformationLoaded) {
                return Center(
                    child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ...state.englishWordModelList.map(
                      (e) => Column(
                        children: [
                          Text(e.name),
                          Text(e.meanings),
                        ],
                      ),
                    )
                  ],
                ));
              }

              return const Center(child: Text('error'));
            },
          ),
        ),
      ),
    ),
  );
}

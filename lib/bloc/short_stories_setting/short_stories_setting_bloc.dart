import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'short_stories_setting_event.dart';
part 'short_stories_setting_state.dart';

class ShortStoriesSettingBloc
    extends Bloc<ShortStoriesSettingEvent, ShortStoriesSettingState> {
  ShortStoriesSettingBloc() : super(ShortStoriesSettingInitial()) {
    on<ShortStoryChangeSetting>((event, emit) async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(event.key, event.value);
    });

    on<ShortStoryGetSetting>((event, emit) async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      final genreFetched = prefs.getString('genre');
      final levelFetched = prefs.getString('level');
      final lengthFetched = prefs.getString('length');
      final wordsUsedFetched = prefs.getString('wordsUsed');

      String genre;
      String level;
      String length;
      int wordsUsed;

      if (genreFetched != null) {
        genre = genreFetched;
      } else {
        genre = 'Comedy';
      }

      if (levelFetched != null) {
        level = levelFetched;
      } else {
        level = 'B1';
      }

      if (lengthFetched != null) {
        length = lengthFetched;
      } else {
        length = '100 words';
      }

      if (wordsUsedFetched != null) {
        wordsUsed = int.tryParse(wordsUsedFetched)!;
      } else {
        wordsUsed = 2;
      }

      emit(ShortStoriesSettingFetched(
          genre: genre, level: level, length: length, wordsUsed: wordsUsed));
    });
  }
}

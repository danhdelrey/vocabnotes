import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'writing_setting_state.dart';

class WritingSettingCubit extends Cubit<WritingSettingState> {
  WritingSettingCubit() : super(WritingSettingInitial());

  void changeSetting({required String key, required String value}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  void getSetting() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final wordsUsedFetched = prefs.getString('wordsUsedInWriting');

    int wordsUsed;

    if (wordsUsedFetched != null) {
      wordsUsed = int.tryParse(wordsUsedFetched)!;
    } else {
      wordsUsed = 2;
    }

    emit(WritingSettingFetchedSuccess(wordsUsed: wordsUsed));
  }
}

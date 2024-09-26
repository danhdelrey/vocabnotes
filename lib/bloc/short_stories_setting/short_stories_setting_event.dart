part of 'short_stories_setting_bloc.dart';

sealed class ShortStoriesSettingEvent extends Equatable {
  const ShortStoriesSettingEvent();

  @override
  List<Object> get props => [];
}

final class ShortStoryChangeSetting extends ShortStoriesSettingEvent {
  final String value;
  final String key;
  

  const ShortStoryChangeSetting({required this.value, required this.key});
}

final class ShortStoryGetSetting extends ShortStoriesSettingEvent {
  
}

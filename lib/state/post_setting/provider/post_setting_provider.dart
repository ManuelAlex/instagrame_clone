import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone/state/post_setting/model/post_settings.dart';
import 'package:instagram_clone/state/post_setting/notifier/post_settings_notifier.dart';

final postSettingsProvider =
    StateNotifierProvider<PostSettingNotifier, Map<PostSettings, bool>>(
  (ref) => PostSettingNotifier(),
);

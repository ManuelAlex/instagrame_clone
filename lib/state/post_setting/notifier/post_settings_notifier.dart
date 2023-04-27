import 'package:collection/collection.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone/state/post_setting/model/post_settings.dart';

class PostSettingNotifier extends StateNotifier<Map<PostSettings, bool>> {
  PostSettingNotifier()
      : super(
          UnmodifiableMapView(
            {
              for (final postSetting in PostSettings.values) postSetting: true,
            },
          ),
        );
  void setSetting(
    PostSettings settings,
    bool value,
  ) {
    final existingValue = state[settings];
    if (existingValue == null || existingValue == value) {
      return;
    }
    state = Map.unmodifiable(
      Map.from(state)..[settings] = value,
    );
  }
}

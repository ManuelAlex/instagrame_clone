import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone/state/image_upload/typedefs/isloading.dart';

import 'package:instagram_clone/state/post/notifiers/delete_state_notifier.dart';

final deletePostProvider =
    StateNotifierProvider<DeleteStateNotifier, Isloading>(
        (_) => DeleteStateNotifier());

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone/state/comment/notifiers/send_comment_notifier.dart';
import 'package:instagram_clone/state/image_upload/typedefs/isloading.dart';

final sendCommentProvider =
    StateNotifierProvider<SendCommentStateNotifier, Isloading>(
  (_) => SendCommentStateNotifier(),
);

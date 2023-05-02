import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone/state/auth/provider/user_id_provider.dart';
import 'package:instagram_clone/state/post/model/post.dart';

final canUserDeletePostProvider =
    StreamProvider.family.autoDispose<bool, Post>((ref, Post post) async* {
  final userId = ref.watch(userIdProvider);
  yield userId == post.userId;
});

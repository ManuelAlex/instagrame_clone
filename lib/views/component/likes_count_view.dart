import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone/state/likes/providers/like_count_provider.dart';
import 'package:instagram_clone/state/post/typedefs/post_id.dart';
import 'package:instagram_clone/views/component/animation/small_error_animation_view.dart';

import 'constant/strings.dart';

class LikesCountView extends ConsumerWidget {
  final PostId postId;
  const LikesCountView({
    super.key,
    required this.postId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final likes = ref.watch(
      likeCountProvider(
        postId,
      ),
    );
    return likes.when(
      data: (numLike) {
        final personOrPeople = numLike == 1 ? Strings.person : Strings.people;
        return Text('$numLike $personOrPeople ${Strings.likedThis}');
      },
      error: (error, stackTrace) {
        return const SmallErrorAnimationView();
      },
      loading: () {
        return const CircularProgressIndicator();
      },
    );
  }
}

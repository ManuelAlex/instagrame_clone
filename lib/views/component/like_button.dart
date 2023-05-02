import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone/state/auth/provider/user_id_provider.dart';
import 'package:instagram_clone/state/likes/model/like_dislike_request.dart';
import 'package:instagram_clone/state/likes/providers/has_liked_post_provider.dart';
import 'package:instagram_clone/state/likes/providers/like_dislike_provider.dart';
import 'package:instagram_clone/state/post/typedefs/post_id.dart';
import 'package:instagram_clone/views/component/animation/small_error_animation_view.dart';

class LikeButton extends ConsumerWidget {
  final PostId postId;
  const LikeButton({
    super.key,
    required this.postId,
  });

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final hasLiked = ref.watch(hasLikedPostProvider(postId));
    return hasLiked.when(
      data: (hasLiked) {
        return IconButton(
          onPressed: () {
            final userId = ref.watch(userIdProvider);
            if (userId == null) {
              return;
            }
            ref.read(
              likeDisLikePostProvider(
                LikeDisLikeRequest(likedBy: userId, postId: postId),
              ),
            );
          },
          icon: FaIcon(
            hasLiked ? FontAwesomeIcons.solidHeart : FontAwesomeIcons.heart,
          ),
        );
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

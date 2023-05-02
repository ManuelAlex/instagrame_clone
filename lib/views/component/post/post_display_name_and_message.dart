import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone/state/post/model/post.dart';
import 'package:instagram_clone/state/user_info/providers/user_info_providder.dart';
import 'package:instagram_clone/views/component/animation/small_error_animation_view.dart';
import 'package:instagram_clone/views/component/rich_text_two_parts.dart';

class PostDisplaynameAnMessage extends ConsumerWidget {
  final Post post;
  const PostDisplaynameAnMessage({
    super.key,
    required this.post,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = ref.watch(userInfoProvider(
      post.userId,
    ));
    return userId.when(
      data: (userInfo) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: RichTextTwoPart(
            leftPart: userInfo.displayName,
            rigtPart: post.message,
          ),
        );
      },
      error: (error, stackTtace) {
        return const SmallErrorAnimationView();
      },
      loading: () {
        return const CircularProgressIndicator();
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone/state/comment/models/comment_model.dart';
import 'package:instagram_clone/state/user_info/providers/user_info_providder.dart';
import 'package:instagram_clone/views/component/animation/small_error_animation_view.dart';
import 'package:instagram_clone/views/component/rich_text_two_parts.dart';

class CompactCommentTile extends ConsumerWidget {
  final Comment comment;
  const CompactCommentTile({
    super.key,
    required this.comment,
  });

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final userInfo = ref.watch(
      userInfoProvider(
        comment.fromuserId,
      ),
    );
    return userInfo.when(
      data: (userInfo) {
        return RichTextTwoPart(
          leftPart: userInfo.displayName,
          rigtPart: comment.commentMessage,
        );
      },
      error: (error, stackTrace) => const SmallErrorAnimationView(),
      loading: () => const CircularProgressIndicator(),
    );
  }
}

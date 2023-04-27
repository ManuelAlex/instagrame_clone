import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone/state/auth/provider/user_id_provider.dart';
import 'package:instagram_clone/state/comment/models/comment_model.dart';
import 'package:instagram_clone/state/comment/provider/delete_comments_provider.dart';
import 'package:instagram_clone/state/user_info/providers/user_info_providder.dart';
import 'package:instagram_clone/views/component/animation/loading_animation_view.dart';
import 'package:instagram_clone/views/component/animation/small_error_animation_view.dart';
import 'package:instagram_clone/views/component/constant/strings.dart';
import 'package:instagram_clone/views/component/dialogs/alart_dialogs_model.dart';
import 'package:instagram_clone/views/component/dialogs/delete_diaog.dart';

class CommentTile extends ConsumerWidget {
  final Comment comment;
  const CommentTile({
    super.key,
    required this.comment,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userInfo = ref.watch(userInfoProvider(
      comment.fromuserId,
    ));
    return userInfo.when(
      data: (userInfo) {
        final currentUser = ref.read(userIdProvider);

        return ListTile(
          trailing: currentUser == comment.fromuserId
              ? IconButton(
                  onPressed: () async {
                    final shouldDeleteComment =
                        await displayDeleteDialog(context);

                    if (shouldDeleteComment) {
                      await ref
                          .read(
                            commentProvider.notifier,
                          )
                          .deleteComment(
                            commentId: comment.commentId,
                          );
                    }
                  },
                  icon: const Icon(Icons.delete))
              : null,
          title: Text(
            userInfo.displayName,
          ),
          subtitle: Text(
            comment.commentMessage,
          ),
        );
      },
      loading: () {
        return const LoadingAnimationView();
      },
      error: (error, stackTrace) {
        return const SmallErrorAnimationView();
      },
    );
  }

  Future<bool> displayDeleteDialog(BuildContext context) =>
      const DeleteDialog(titleOfObject: Strings.comment).present(context).then(
            (value) => value ?? false,
          );
}

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone/state/auth/provider/user_id_provider.dart';
import 'package:instagram_clone/state/comment/models/post_comments_requests.dart';
import 'package:instagram_clone/state/comment/provider/post_comment_provider.dart';
import 'package:instagram_clone/state/comment/provider/send_comment_provider.dart';
import 'package:instagram_clone/state/post/typedefs/post_id.dart';
import 'package:instagram_clone/views/component/animation/empty_content_with_text_animation_view.dart';
import 'package:instagram_clone/views/component/animation/error_animation_view.dart';
import 'package:instagram_clone/views/component/animation/loading_animation_view.dart';
import 'package:instagram_clone/views/component/comment/comment_tile.dart';
import 'package:instagram_clone/views/component/constant/strings.dart';
import 'package:instagram_clone/views/extensions/dismiss_keyboard.dart';
//

class PostCommentsView extends HookConsumerWidget {
  final PostId postId;
  const PostCommentsView({
    super.key,
    required this.postId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final commentController = useTextEditingController();
    final hasText = useState(false);
    final request = useState(
      RequestsForPostsAndComments(
        postId: postId,
      ),
    );
    final comments = ref.watch(postCommentProvider(
      request.value,
    ));
    useEffect(() {
      commentController.addListener(() {
        hasText.value = commentController.text.isNotEmpty;
      });
      return () {};
    }, [
      commentController,
    ]);
    return Scaffold(
      appBar: AppBar(
        title: const Text(Strings.comment),
        actions: [
          IconButton(
            onPressed: hasText.value
                ? () {
                    _submitCommentWithCOntroler(
                      commentController,
                      ref,
                    );
                  }
                : null,
            icon: const Icon(Icons.send),
          ),
        ],
      ),
      body: SafeArea(
        child: Flex(
          direction: Axis.vertical,
          children: [
            Expanded(
              child: comments.when(
                data: (comments) {
                  if (comments.isEmpty) {
                    return const EmptyContentWithTextAnimationView(
                      text: Strings.noCommentsYet,
                    );
                  }
                  return RefreshIndicator(
                    onRefresh: () {
                      return Future.delayed(
                          const Duration(seconds: 1),
                          () => ref.refresh(
                                postCommentProvider(request.value),
                              ));
                    },
                    child: ListView.builder(
                      padding: const EdgeInsets.all(8.0),
                      itemCount: comments.length,
                      itemBuilder: (context, index) {
                        final comment = comments.elementAt(index);
                        return CommentTile(
                          comment: comment,
                        );
                      },
                    ),
                  );
                },
                loading: () {
                  return const LoadingAnimationView();
                },
                error: (stackTrace, error) {
                  return const ErrorAnimationView();
                },
              ),
            ),
            Expanded(
                child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 8.0,
                  right: 8.0,
                ),
                child: TextField(
                  textInputAction: TextInputAction.send,
                  controller: commentController,
                  onSubmitted: (comment) {
                    if (comment.isNotEmpty) {
                      _submitCommentWithCOntroler(commentController, ref);
                    }
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: Strings.writeYourCommentHere,
                  ),
                ),
              ),
            ))
          ],
        ),
      ),
    );
  }

  Future<void> _submitCommentWithCOntroler(
    TextEditingController controller,
    WidgetRef ref,
  ) async {
    final userId = ref.read(userIdProvider);
    if (userId == null) {
      return;
    }
    final isSent = await ref.read(sendCommentProvider.notifier).sendComment(
          commentMessage: controller.text,
          onPostId: postId,
          fromuserId: userId,
        );
    if (isSent) {
      controller.clear();
      dismisskeyboard();
    }
  }
}

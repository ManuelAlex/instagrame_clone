import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone/state/comment/models/post_comments_requests.dart';
import 'package:instagram_clone/state/enums/date_sorting.dart';
import 'package:instagram_clone/state/post/model/post.dart';
import 'package:instagram_clone/state/post/provider/can_user_delete_post_provider.dart';
import 'package:instagram_clone/state/post/provider/delete_state_provider.dart';
import 'package:instagram_clone/state/post/provider/specific_post_with_comment_provider.dart';
import 'package:instagram_clone/views/component/animation/error_animation_view.dart';
import 'package:instagram_clone/views/component/animation/loading_animation_view.dart';
import 'package:instagram_clone/views/component/animation/small_error_animation_view.dart';
import 'package:instagram_clone/views/component/comment/compact_comment_column.dart';
import 'package:instagram_clone/views/component/constant/strings.dart';
import 'package:instagram_clone/views/component/dialogs/alart_dialogs_model.dart';
import 'package:instagram_clone/views/component/dialogs/delete_diaog.dart';
import 'package:instagram_clone/views/component/like_button.dart';
import 'package:instagram_clone/views/component/likes_count_view.dart';
import 'package:instagram_clone/views/component/post/post_date_view.dart';
import 'package:instagram_clone/views/component/post/post_display_name_and_message.dart';
import 'package:instagram_clone/views/component/post/post_image_or_video_view.dart';
import 'package:instagram_clone/views/post_comments/post_comments_view.dart';
import 'package:share_plus/share_plus.dart';

class PostDetailsView extends ConsumerStatefulWidget {
  final Post post;
  const PostDetailsView({
    super.key,
    required this.post,
  });

  @override
  ConsumerState<PostDetailsView> createState() => _PostDetailsViewState();
}

class _PostDetailsViewState extends ConsumerState<PostDetailsView> {
  @override
  Widget build(BuildContext context) {
    final request = RequestsForPostsAndComments(
      postId: widget.post.postId,
      limit: 3,
      dateSorting: DateSorting.oldestOnTop,
    );
    final postWithComment = ref.watch(specificPostWithCommentprovider(request));
    final canUserDeletePost = ref.watch(canUserDeletePostProvider(widget.post));
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          Strings.postDetails,
        ),
        actions: [
          postWithComment.when(
            data: (postWithComment) => IconButton(
              onPressed: () {
                final url = postWithComment.post.fileUrl;
                Share.share(
                  url,
                  subject: Strings.checkOutThisPost,
                );
              },
              icon: const Icon(Icons.share),
            ),
            error: (error, stackTrace) => const SmallErrorAnimationView(),
            loading: () => const CircularProgressIndicator(),
          ),
          if (canUserDeletePost.value ?? false)
            IconButton(
              onPressed: () async {
                final shouldDeletePost = await const DeleteDialog(
                  titleOfObject: Strings.post,
                )
                    .present(
                      context,
                    )
                    .then((shouldDelete) => shouldDelete ?? false);

                if (shouldDeletePost) {
                  ref.read(deletePostProvider.notifier).deletePost(
                        post: widget.post,
                      );
                  if (mounted) {
                    Navigator.of(context).pop();
                  }
                }
              },
              icon: const Icon(
                Icons.delete,
              ),
            ),
        ],
      ),
      body: postWithComment.when(
        data: (postWithComment) {
          final postId = postWithComment.post.postId;
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                PostImageOrVideoView(
                  post: postWithComment.post,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    if (postWithComment.post.allowLikes)
                      LikeButton(postId: postId),
                    if (postWithComment.post.allowComments)
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  PostCommentsView(postId: postId),
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.mode_comment_outlined,
                        ),
                      ),
                  ],
                ),
                PostDisplaynameAnMessage(
                  post: postWithComment.post,
                ),
                PostDateView(
                  dateTime: postWithComment.post.createdAt,
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Divider(
                    color: Colors.white70,
                  ),
                ),
                CompactCommentColumn(
                  commentList: postWithComment.commentList,
                ),
                if (postWithComment.post.allowLikes)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        LikesCountView(
                          postId: postId,
                        ),
                      ],
                    ),
                  ),
                const SizedBox(
                  height: 100,
                )
              ],
            ),
          );
        },
        error: (error, stackTrace) => const ErrorAnimationView(),
        loading: () => const LoadingAnimationView(),
      ),
    );
  }
}

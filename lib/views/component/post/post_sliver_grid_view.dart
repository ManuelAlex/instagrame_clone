import 'package:flutter/material.dart';
import 'package:instagram_clone/state/post/model/post.dart';
import 'package:instagram_clone/views/component/post/post_thumbnail_view.dart';
import 'package:instagram_clone/views/post_details/post_details_view.dart';

class PostSliverGridView extends StatelessWidget {
  final Iterable<Post> posts;
  const PostSliverGridView({
    super.key,
    required this.posts,
  });

  @override
  Widget build(BuildContext context) {
    return SliverGrid(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final post = posts.elementAt(index);
          return PostThumbnailView(
              post: post,
              onTapped: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => PostDetailsView(post: post)));
              });
        },
        childCount: posts.length,
      ),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 8.0,
        crossAxisSpacing: 8.0,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:instagram_clone/state/post/model/post.dart';
import 'package:instagram_clone/views/component/post/post_thumbnail_view.dart';

class PostGridView extends StatelessWidget {
  const PostGridView({
    super.key,
    required this.posts,
  });
  final Iterable<Post> posts;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(8.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 8.0,
        crossAxisSpacing: 8.0,
      ),
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final post = posts.elementAt(index);
        return PostThumbnailView(
            post: post,
            onTapped: () {
              //TODO:navigate to post detailsView
            });
      },
    );
  }
}

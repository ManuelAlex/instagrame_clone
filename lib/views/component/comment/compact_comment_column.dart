import 'package:flutter/material.dart';
import 'package:instagram_clone/state/comment/models/comment_model.dart';
import 'package:instagram_clone/views/component/comment/compact_comment_tile.dart';

class CompactCommentColumn extends StatelessWidget {
  final Iterable<Comment> commentList;
  const CompactCommentColumn({
    super.key,
    required this.commentList,
  });

  @override
  Widget build(BuildContext context) {
    if (commentList.isEmpty) {
      return const SizedBox();
    }
    return Padding(
      padding: const EdgeInsets.only(
        left: 8.0,
        bottom: 8.0,
        right: 8.0,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: commentList
            .map((comment) => CompactCommentTile(
                  comment: comment,
                ))
            // .take(3)
            // .toList()
            // .reversed
            .toList(),
      ),
    );
  }
}

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:instagram_clone/state/comment/models/comment_model.dart';
import 'package:instagram_clone/state/post/model/post.dart';

@immutable
class PostWithComments {
  final Post post;
  final Iterable<Comment> commentList;
  const PostWithComments({
    required this.post,
    required this.commentList,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PostWithComments &&
          runtimeType == other.runtimeType &&
          post == other.post &&
          const IterableEquality().equals(
            commentList,
            other.commentList,
          );

  @override
  int get hashCode => Object.hashAll([
        post,
        commentList,
      ]);
}

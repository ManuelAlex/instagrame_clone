import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:instagram_clone/state/comment/type_def/comment_id.dart';
import 'package:instagram_clone/state/constants/firebase_field_names.dart';
import 'package:instagram_clone/state/post/typedefs/post_id.dart';
import 'package:instagram_clone/state/post/typedefs/user_id.dart';

@immutable
class Comment {
  final CommentId commentId;
  final DateTime createdAt;
  final String commentMessage;
  final PostId postId;
  final UserId fromuserId;

  Comment({
    required Map<String, dynamic> json,
    required this.commentId,
  })  : commentMessage = json[FirebaseFieldName.comment],
        createdAt = (json[FirebaseFieldName.createdAt] as Timestamp).toDate(),
        postId = json[FirebaseFieldName.postId],
        fromuserId = json[FirebaseFieldName.userId];

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Comment &&
          runtimeType == other.runtimeType &&
          commentId == other.commentId &&
          postId == other.postId &&
          createdAt == other.createdAt &&
          fromuserId == other.fromuserId;

  @override
  int get hashCode => Object.hashAll([
        commentId,
        postId,
        createdAt,
        fromuserId,
      ]);
}

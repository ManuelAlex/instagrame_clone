import 'dart:collection';
import 'package:flutter/foundation.dart' show immutable;
import 'package:instagram_clone/state/constants/firebase_field_names.dart';
import 'package:instagram_clone/state/post/typedefs/post_id.dart';
import 'package:instagram_clone/state/post/typedefs/user_id.dart';

@immutable
class LikePayload extends MapView<String, String> {
  // final UserId likedBy;
  // final PostId postId;
  // final DateTime likedDate;

  LikePayload({
    required UserId likedBy,
    required PostId postId,
    required DateTime dateTime,
  }) : super(
          {
            FirebaseFieldName.userId: likedBy,
            FirebaseFieldName.postId: postId,
            FirebaseFieldName.createdAt: dateTime.toIso8601String(),
          },
        );
}

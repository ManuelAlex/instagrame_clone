import 'package:flutter/foundation.dart' show immutable;
import 'package:instagram_clone/state/post/typedefs/post_id.dart';
import 'package:instagram_clone/state/post/typedefs/user_id.dart';

@immutable
class LikeDisLikeRequest {
  final UserId likedBy;
  final PostId postId;
  const LikeDisLikeRequest({
    required this.likedBy,
    required this.postId,
  });
}

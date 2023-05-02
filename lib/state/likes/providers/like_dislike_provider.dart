import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone/state/auth/constants/firebase_collection_name.dart';
import 'package:instagram_clone/state/constants/firebase_field_names.dart';
import 'package:instagram_clone/state/likes/model/like_dislike_request.dart';
import 'package:instagram_clone/state/likes/model/like_payload.dart';

final likeDisLikePostProvider =
    FutureProvider.family.autoDispose<bool, LikeDisLikeRequest>((
  ref,
  LikeDisLikeRequest request,
) async {
  final query = FirebaseFirestore.instance
      .collection(FirebaseCollectionName.likes)
      .where(
        FirebaseFieldName.postId,
        isEqualTo: request.postId,
      )
      .where(FirebaseFieldName.userId, isEqualTo: request.likedBy)
      .get();

  final hasLike = await query.then(
    (snapShot) => snapShot.docs.isNotEmpty,
  );
  if (hasLike) {
    //delete likes
    try {
      await query.then((snapShot) async {
        for (final doc in snapShot.docs) {
          await doc.reference.delete();
        }
      });
      return true;
    } catch (_) {
      return false;
    }
  } else {
    //add like object
    final like = LikePayload(
      likedBy: request.likedBy,
      postId: request.postId,
      dateTime: DateTime.now(),
    );

    try {
      await FirebaseFirestore.instance
          .collection(FirebaseCollectionName.likes)
          .add(like);
      return true;
    } catch (_) {
      return false;
    }
  }
});

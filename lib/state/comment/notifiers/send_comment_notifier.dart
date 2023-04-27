import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone/state/auth/constants/firebase_collection_name.dart';
import 'package:instagram_clone/state/comment/models/comment_payload.dart';
import 'package:instagram_clone/state/image_upload/typedefs/isloading.dart';
import 'package:instagram_clone/state/post/typedefs/post_id.dart';
import 'package:instagram_clone/state/post/typedefs/user_id.dart';

class SendCommentStateNotifier extends StateNotifier<Isloading> {
  SendCommentStateNotifier() : super(false);
  set setIsloading(bool value) => state = value;

  Future<bool> sendComment({
    required String commentMessage,
    required PostId onPostId,
    required UserId fromuserId,
  }) async {
    setIsloading = true;
    final commentPayload = CommentPayload(
      commentMessage: commentMessage,
      onPostId: onPostId,
      fromuserId: fromuserId,
    );

    try {
      await FirebaseFirestore.instance
          .collection(FirebaseCollectionName.comments)
          .add(
            commentPayload,
          );
      return true;
    } catch (_) {
      return false;
    } finally {
      setIsloading = false;
    }
  }
}

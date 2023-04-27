import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone/state/auth/constants/firebase_collection_name.dart';
import 'package:instagram_clone/state/image_upload/typedefs/isloading.dart';
import 'package:instagram_clone/state/comment/type_def/comment_id.dart';

class DeleteCommentStateNotifier extends StateNotifier<Isloading> {
  DeleteCommentStateNotifier() : super(false);
  set setIsloading(bool value) => state = value;
  Future<bool> deleteComment({
    required CommentId commentId,
  }) async {
    try {
      setIsloading = true;
      final query = FirebaseFirestore.instance
          .collection(FirebaseCollectionName.comments)
          .where(
            FieldPath.documentId,
            isEqualTo: commentId,
          )
          .limit(1)
          .get();

      await query.then((query) async {
        for (final doc in query.docs) {
          await doc.reference.delete();
        }
      });
      return true;
    } catch (_) {
      return false;
    } finally {
      setIsloading = false;
    }
  }
}

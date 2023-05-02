import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone/state/auth/constants/firebase_collection_name.dart';
import 'package:instagram_clone/state/constants/firebase_field_names.dart';
import 'package:instagram_clone/state/image_upload/extensions/get_collection_name_from_file_type.dart';
import 'package:instagram_clone/state/image_upload/typedefs/isloading.dart';
import 'package:instagram_clone/state/post/model/post.dart';
import 'package:instagram_clone/state/post/typedefs/post_id.dart';

class DeleteStateNotifier extends StateNotifier<Isloading> {
  DeleteStateNotifier() : super(false);
  set setIsloading(bool value) => state = value;

  Future<bool> deletePost({
    required Post post,
  }) async {
    try {
      setIsloading = true;
      //delete post thumbnail
      await FirebaseStorage.instance
          .ref()
          .child(post.userId)
          .child(FirebaseCollectionName.thumbnails)
          .child(post.thumbnailStorageId)
          .delete();

      //delete post original file image/video
      await FirebaseStorage.instance
          .ref()
          .child(post.userId)
          .child(post.fileType.getCollectionNameFromFileType)
          .child(post.originalFileStorageId)
          .delete();

      //delete comments associated with post
      await _deletAllDocuments(
          inCollection: FirebaseCollectionName.comments, postId: post.postId);

      //delete all likes associated with post
      await _deletAllDocuments(
          inCollection: FirebaseCollectionName.likes, postId: post.postId);

      //finally delete  post
      final query = await FirebaseFirestore.instance
          .collection(FirebaseCollectionName.posts)
          .where(
            FieldPath.documentId,
            isEqualTo: post.postId,
          )
          .limit(1)
          .get();

      for (final doc in query.docs) {
        doc.reference.delete();
      }

      return true;
    } catch (_) {
      return false;
    } finally {
      setIsloading = false;
    }
  }

  Future<void> _deletAllDocuments({
    required PostId postId,
    required String inCollection,
  }) async {
    return FirebaseFirestore.instance.runTransaction(
      maxAttempts: 3,
      timeout: const Duration(seconds: 20),
      (transaction) async {
        final query = await FirebaseFirestore.instance
            .collection(inCollection)
            .where(
              FirebaseFieldName.postId,
              isEqualTo: postId,
            )
            .get();

        for (final doc in query.docs) {
          transaction.delete(doc.reference);
        }
      },
    );
  }
}

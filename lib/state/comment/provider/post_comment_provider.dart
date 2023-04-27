import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone/state/auth/constants/firebase_collection_name.dart';
import 'package:instagram_clone/state/comment/extensions/comment_sorting_by_request.dart';
import 'package:instagram_clone/state/comment/models/comment_model.dart';
import 'package:instagram_clone/state/comment/models/post_comments_requests.dart';
import 'package:instagram_clone/state/constants/firebase_field_names.dart';

final postCommentProvider = StreamProvider.family
    .autoDispose<Iterable<Comment>, RequestsForPostsAndComments>(
        (ref, RequestsForPostsAndComments request) {
  final controller = StreamController<Iterable<Comment>>();
  final sub = FirebaseFirestore.instance
      .collection(FirebaseCollectionName.comments)
      .where(FirebaseFieldName.postId, isEqualTo: request.postId)
      .snapshots()
      .listen((snapShot) {
    final docs = snapShot.docs;
    final limitedDocs =
        request.limit != null ? docs.take(request.limit!) : docs;
    final comments = limitedDocs
        .where((eachComment) => !eachComment.metadata.hasPendingWrites)
        .map(
          (eachComment) => Comment(
            json: eachComment.data(),
            commentId: eachComment.id,
          ),
        )
        .applySortingFrom(
          requests: request,
        );

    controller.sink.add(
      comments,
    );
  });

  ref.onDispose(
    () {
      controller.close();
      sub.cancel();
    },
  );

  return controller.stream;
});

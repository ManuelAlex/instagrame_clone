import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone/state/auth/constants/firebase_collection_name.dart';
import 'package:instagram_clone/state/comment/extensions/comment_sorting_by_request.dart';
import 'package:instagram_clone/state/comment/models/comment_model.dart';
import 'package:instagram_clone/state/comment/models/post_comments_requests.dart';
import 'package:instagram_clone/state/comment/models/post_with_comments.dart';
import 'package:instagram_clone/state/constants/firebase_field_names.dart';
import 'package:instagram_clone/state/post/model/post.dart';

final specificPostWithCommentprovider = StreamProvider.family
    .autoDispose<PostWithComments, RequestsForPostsAndComments>(
  (
    ref,
    RequestsForPostsAndComments request,
  ) {
    final controller = StreamController<PostWithComments>();

    Post? post;
    Iterable<Comment>? commentList;
    void notify() {
      if (post == null) {
        return;
      } else {
        final outPutComment = (commentList ?? []).applySortingFrom(
          requests: request,
        );
        final result = PostWithComments(
          post: post!,
          commentList: outPutComment,
        );
        controller.sink.add(
          result,
        );
      }
    }

    //watch changes to the post
    final postSub = FirebaseFirestore.instance
        .collection(FirebaseCollectionName.posts)
        .where(FieldPath.documentId, isEqualTo: request.postId)
        .limit(1)
        .snapshots()
        .listen((snapshots) {
      final doc = snapshots.docs;
      if (doc.isEmpty) {
        post = null;
        commentList = null;
        notify();
        return;
      }
      if (doc.first.metadata.hasPendingWrites) {
        return;
      }
      post = Post(
        postId: doc.first.id,
        json: doc.first.data(),
      );
      notify();
    });
// watch changes to the comment

    final query = FirebaseFirestore.instance
        .collection(FirebaseCollectionName.comments)
        .where(FirebaseFieldName.postId, isEqualTo: request.postId)
        .orderBy(FirebaseFieldName.createdAt, descending: true);
    final limitedQuery =
        request.limit != null ? query.limit(request.limit!) : query;

    final commentLimitedSub = limitedQuery.snapshots().listen(
      (snapShot) {
        commentList = snapShot.docs
            .where((doc) => !doc.metadata.hasPendingWrites)
            .map(
              (comment) => Comment(
                json: comment.data(),
                commentId: comment.id,
              ),
            )
            .toList();
        notify();
      },
    );

    ref.onDispose(() {
      controller.close();
      postSub.cancel();
      commentLimitedSub.cancel();
    });
    return controller.stream;
  },
);

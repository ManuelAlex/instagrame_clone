import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone/state/auth/constants/firebase_collection_name.dart';
import 'package:instagram_clone/state/constants/firebase_field_names.dart';
import 'package:instagram_clone/state/post/typedefs/post_id.dart';

final likeCountProvider = StreamProvider.family.autoDispose<int, PostId>((
  ref,
  PostId postId,
) {
  final controller = StreamController<int>.broadcast();
  controller.onListen = () => controller.sink.add(0);
  final sub = FirebaseFirestore.instance
      .collection(FirebaseCollectionName.likes)
      .where(FirebaseFieldName.postId, isEqualTo: postId)
      .snapshots()
      .listen((snapShot) {
    final docs = snapShot.docs;
    final numLikes = docs.length;
    controller.sink.add(numLikes);
  });

  ref.onDispose(() {
    controller.close();
    sub.cancel();
  });
  return controller.stream;
});

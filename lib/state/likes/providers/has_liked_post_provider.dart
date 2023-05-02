import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone/state/auth/constants/firebase_collection_name.dart';
import 'package:instagram_clone/state/auth/provider/user_id_provider.dart';
import 'package:instagram_clone/state/constants/firebase_field_names.dart';
import 'package:instagram_clone/state/post/typedefs/post_id.dart';

final hasLikedPostProvider = StreamProvider.family.autoDispose<bool, PostId>(
  (
    ref,
    PostId postId,
  ) {
    final likedBy = ref.watch(userIdProvider);
    if (likedBy == null) {
      return Stream<bool>.value(false);
    }
    final controller = StreamController<bool>();
    final sub = FirebaseFirestore.instance
        .collection(FirebaseCollectionName.likes)
        .where(
          FirebaseFieldName.postId,
          isEqualTo: postId,
        )
        .where(
          FirebaseFieldName.userId,
          isEqualTo: likedBy,
        )
        .snapshots()
        .listen((snapShot) {
      if (snapShot.docs.isNotEmpty) {
        controller.add(true);
      } else {
        controller.add(false);
      }
    });

    ref.onDispose(() {
      controller.close();
      sub.cancel();
    });
    return controller.stream;
  },
);

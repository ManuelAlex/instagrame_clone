import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone/state/auth/constants/firebase_collection_name.dart';
import 'package:instagram_clone/state/constants/firebase_field_names.dart';
import 'package:instagram_clone/state/post/model/post.dart';
import 'package:instagram_clone/state/post/typedefs/search_term.dart';

final postBySearchTermProvider = StreamProvider.family
    .autoDispose<Iterable<Post>, SearchTerm>((ref, SearchTerm searchTerm) {
  final controller = StreamController<Iterable<Post>>();
  final sub = FirebaseFirestore.instance
      .collection(
        FirebaseCollectionName.posts,
      )
      .orderBy(
        FirebaseFieldName.createdAt,
        descending: true,
      )
      .snapshots()
      .listen(
    (snapshots) {
      final posts = snapshots.docs
          .map(
            (doc) => Post(
              postId: doc.id,
              json: doc.data(),
            ),
          )
          .where((post) => post.message.toLowerCase().contains(
                searchTerm.toLowerCase(),
              ));

      controller.sink.add(posts);
    },
  );

  ref.onDispose(() {
    controller.close();
    sub.cancel();
  });
  return controller.stream;
});

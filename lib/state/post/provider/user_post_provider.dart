import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone/state/auth/constants/firebase_collection_name.dart';
import 'package:instagram_clone/state/auth/provider/user_id_provider.dart';
import 'package:instagram_clone/state/constants/firebase_field_names.dart';
import 'package:instagram_clone/state/post/model/post.dart';
import 'package:instagram_clone/state/post/model/post_key.dart';

final userPostProvider = StreamProvider.autoDispose<Iterable<Post>>(
  ((ref) {
    final userId = ref.watch(userIdProvider);
    final controller = StreamController<Iterable<Post>>();
    controller.onListen = () {
      controller.sink.add([]);
    };
    final sub = FirebaseFirestore.instance
        .collection(
          FirebaseCollectionName.posts,
        )
        .orderBy(
          FirebaseFieldName.createdAt,
          descending: true,
        )
        .where(
          PostKey.userId,
          isEqualTo: userId,
        )
        .snapshots()
        .listen((
      snapshot,
    ) {
      final document = snapshot.docs
          .where(
            (
              doc,
            ) =>
                !doc.metadata.hasPendingWrites,
          )
          .map(
            (doc) => Post(
              postId: doc.id,
              json: doc.data(),
            ),
          );
      controller.sink.add(document);
    });

    ref.onDispose(() {
      sub.cancel();
      controller.close();
    });

    return controller.stream;
  }),
);

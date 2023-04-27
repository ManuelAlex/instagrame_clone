import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone/state/auth/constants/firebase_collection_name.dart';
import 'package:instagram_clone/state/constants/firebase_field_names.dart';
import 'package:instagram_clone/state/post/typedefs/user_id.dart';
import 'package:instagram_clone/state/user_info/models/user_info_model.dart';

final userInfoProvider =
    StreamProvider.autoDispose.family<UserInfoModel, UserId>((
  ref,
  UserId userId,
) {
  final controller = StreamController<UserInfoModel>();
  // controller.onListen = () {
  //   controller.sink.add({});
  // };
  final sub = FirebaseFirestore.instance
      .collection(FirebaseCollectionName.users)
      .where(
        FirebaseFieldName.userId,
        isEqualTo: userId,
      )
      .limit(1)
      .snapshots()
      .listen(
    (snapShot) {
      final docs = snapShot.docs.first;
      final json = docs.data();
      final userInfoModel = UserInfoModel.fromJson(
        userId: userId,
        json: json,
      );
      controller.sink.add(
        userInfoModel,
      );
    },
  );
  ref.onDispose(() {
    controller.close();
    sub.cancel();
  });
  return controller.stream;
});

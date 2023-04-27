import 'dart:collection' show MapView;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:instagram_clone/state/post/model/post_key.dart';
import 'package:instagram_clone/state/post/typedefs/user_id.dart';
import 'package:instagram_clone/state/image_upload/model/file_type.dart';
import 'package:instagram_clone/state/post_setting/model/post_settings.dart';

@immutable
class PostPayLoad extends MapView<String, dynamic> {
  PostPayLoad({
    required UserId userId,
    required String fileName,
    required String message,
    required String thumbnailUrl,
    required String fileUrl,
    required FileType fileType,
    required double aspectRatio,
    required String thumbnailStorageId,
    required String originalFileStorageId,
    required Map<PostSettings, bool> postSettings,
  }) : super(
          {
            PostKey.userId: userId,
            PostKey.fileName: fileName,
            PostKey.createdAt: FieldValue.serverTimestamp(),
            PostKey.message: message,
            PostKey.thumbnailUrl: thumbnailUrl,
            PostKey.fileUrl: fileUrl,
            PostKey.fileType: fileType.name,
            PostKey.aspectRatio: aspectRatio,
            PostKey.thumbnailStorageId: thumbnailStorageId,
            PostKey.originalFileStorageId: originalFileStorageId,
            PostKey.postSettings: {
              for (final postSetting in postSettings.entries)
                postSetting.key.storageKey: postSetting.value,
            },
          },
        );
}

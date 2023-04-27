import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone/state/auth/constants/firebase_collection_name.dart';

import 'package:instagram_clone/state/image_upload/constant/constant.dart';
import 'package:instagram_clone/state/image_upload/exceptions/could_not_build_thumbnail_exception.dart';
import 'package:instagram_clone/state/image_upload/extensions/get_collection_name_from_file_type.dart';
import 'package:instagram_clone/state/image_upload/extensions/get_image_data_aspect_ratio.dart';
import 'package:instagram_clone/state/image_upload/model/file_type.dart';
import 'package:instagram_clone/state/image_upload/typedefs/isloading.dart';
import 'package:instagram_clone/state/post/model/post_payload.dart';
import 'package:instagram_clone/state/post/typedefs/user_id.dart';
import 'package:instagram_clone/state/post_setting/model/post_settings.dart';
import 'package:uuid/uuid.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class ImageUploadNotifier extends StateNotifier<Isloading> {
  ImageUploadNotifier() : super(false);
  set setIsloading(bool value) => state = value;

  Future<bool> upload({
    required UserId userId,
    required File file,
    required FileType fileType,
    required String message,
    required Map<PostSettings, bool> postSettings,
  }) async {
    setIsloading = true;
    late Uint8List thumbnailUint8List;
    switch (fileType) {
      case FileType.image:
        final fileAsImage = img.decodeImage(file.readAsBytesSync());
        if (fileAsImage == null) {
          setIsloading = false;
          throw const CouldNotBuildThumbnailException();
        }
        final thunbnail = img.copyResize(
          fileAsImage,
          width: Constant.imageThumbnailWidth,
        );
        final thumbnailData = img.encodeJpg(
          thunbnail,
        );
        thumbnailUint8List = Uint8List.fromList(thumbnailData);

        break;
      case FileType.video:
        final thumb = await VideoThumbnail.thumbnailData(
          video: file.path,
          imageFormat: ImageFormat.JPEG,
          maxHeight: Constant.videoThumbnailMaxHeight,
          quality: Constant.videoThumbnailQuality,
        );
        if (thumb == null) {
          setIsloading = false;
          throw const CouldNotBuildThumbnailException();
        }
        thumbnailUint8List = thumb;
        break;
    }
    // calculate aspect ratio
    final double thumbnailAspectRatio =
        await thumbnailUint8List.getAspectRatio();
    // calculate references
    final fileName = const Uuid().v4();
    //create references to thumbnail and image
    final thumbnailreference = FirebaseStorage.instance
        .ref()
        .child(
          userId,
        )
        .child(FirebaseCollectionName.thumbnails)
        .child(fileName);
    final originalFileRef = FirebaseStorage.instance
        .ref()
        .child(
          userId,
        )
        .child(fileType.getCollectionNameFromFileType)
        .child(
          fileName,
        );

    try {
      setIsloading = true;
      //upload thumbnaill
      final uploadTask = await thumbnailreference.putData(thumbnailUint8List);
      final thumbnailStorageId = uploadTask.ref.name;
      //upload original final
      final uploadOriginalFileTask =
          await originalFileRef.putData(await file.readAsBytes());
      final originalFileStorageId = uploadOriginalFileTask.ref.name;
      //upload post
      final postPayload = PostPayLoad(
        userId: userId,
        fileName: fileName,
        message: message,
        thumbnailUrl: await thumbnailreference.getDownloadURL(),
        fileUrl: await originalFileRef.getDownloadURL(),
        fileType: fileType,
        aspectRatio: thumbnailAspectRatio,
        thumbnailStorageId: thumbnailStorageId,
        originalFileStorageId: originalFileStorageId,
        postSettings: postSettings,
      );
      await FirebaseFirestore.instance
          .collection(FirebaseCollectionName.posts)
          .add(postPayload);
      return true;
    } catch (_) {
      return false;
    } finally {
      setIsloading = false;
    }
  }
}

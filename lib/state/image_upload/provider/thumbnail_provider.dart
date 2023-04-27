import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone/state/image_upload/exceptions/could_not_build_thumbnail_exception.dart';
import 'package:instagram_clone/state/image_upload/extensions/get_image_aspect_ratio.dart';
import 'package:instagram_clone/state/image_upload/model/file_type.dart';
import 'package:instagram_clone/state/image_upload/model/image_with_aspect_ratio.dart';
import 'package:instagram_clone/state/image_upload/model/thumbnail_request.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

final thumbnailProvider =
    FutureProvider.family.autoDispose<ImageWithAspecRatio, ThumbNailRequest>(
  (
    _,
    ThumbNailRequest request,
  ) async {
    final Image image;

    switch (request.fileType) {
      case FileType.image:
        image = Image.file(
          request.file,
          fit: BoxFit.fitHeight,
        );
        break;
      case FileType.video:
        final videoImageThumb = await VideoThumbnail.thumbnailData(
          video: request.file.path,
          imageFormat: ImageFormat.JPEG,
          quality: 75,
        );
        if (videoImageThumb == null) {
          throw const CouldNotBuildThumbnailException();
        }
        image = Image.memory(
          videoImageThumb,
          fit: BoxFit.fitHeight,
        );
        break;
    }
    return ImageWithAspecRatio(
      aspectRatio: await image.getAspectRatio(),
      image: image,
    );
  },
);

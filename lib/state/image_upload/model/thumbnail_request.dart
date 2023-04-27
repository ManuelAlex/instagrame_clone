import 'dart:io';

import 'package:flutter/foundation.dart' show immutable;
import 'package:instagram_clone/state/image_upload/model/file_type.dart';

@immutable
class ThumbNailRequest {
  final File file;
  final FileType fileType;
  const ThumbNailRequest({
    required this.file,
    required this.fileType,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ThumbNailRequest &&
          runtimeType == other.runtimeType &&
          file == other.file &&
          fileType == other.fileType;

  @override
  int get hashCode => Object.hashAll(
        [
          runtimeType,
          file,
          fileType,
        ],
      );
}

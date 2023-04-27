import 'package:instagram_clone/state/image_upload/model/file_type.dart';

extension GetCollectionNameFromFileType on FileType {
  String get getCollectionNameFromFileType {
    switch (this) {
      case FileType.image:
        return 'images';

      case FileType.video:
        return 'videos';
    }
  }
}

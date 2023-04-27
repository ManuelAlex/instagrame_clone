import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone/state/image_upload/notifier/image_upload_notifier.dart';
import 'package:instagram_clone/state/image_upload/typedefs/isloading.dart';

final imageUploadProvider =
    StateNotifierProvider<ImageUploadNotifier, Isloading>(
  (ref) {
    return ImageUploadNotifier();
  },
);

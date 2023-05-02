import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone/state/auth/provider/auth_state_provider.dart';
import 'package:instagram_clone/state/comment/provider/send_comment_provider.dart';
import 'package:instagram_clone/state/image_upload/provider/image_uploader_provider.dart';
import 'package:instagram_clone/state/post/provider/delete_state_provider.dart';

final isLoadingProvider = Provider<bool>((ref) {
  final authState = ref.watch(authStateProvider);

  final isImageUploadState = ref.watch(imageUploadProvider);
  final isDeletingPost = ref.watch(deletePostProvider);
  final canSendComment = ref.watch(sendCommentProvider);
  return authState.isLoading ||
      isImageUploadState ||
      isDeletingPost ||
      canSendComment;
});

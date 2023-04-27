import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone/state/auth/provider/auth_state_provider.dart';
import 'package:instagram_clone/state/image_upload/provider/image_uploader_provider.dart';

final isLoadingProvider = Provider<bool>((ref) {
  final authState = ref.watch(authStateProvider);

  final isImageUploadState = ref.watch(imageUploadProvider);
  return authState.isLoading || isImageUploadState;
});

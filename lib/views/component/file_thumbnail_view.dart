import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone/state/image_upload/model/thumbnail_request.dart';
import 'package:instagram_clone/state/image_upload/provider/thumbnail_provider.dart';
import 'package:instagram_clone/views/component/animation/loading_animation_view.dart';
import 'package:instagram_clone/views/component/animation/small_error_animation_view.dart';

class FileThumbnailView extends ConsumerWidget {
  final ThumbNailRequest thumbNailRequest;
  const FileThumbnailView({
    super.key,
    required this.thumbNailRequest,
  });

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final thumbnail = ref.watch(
      thumbnailProvider(thumbNailRequest),
    );
    return thumbnail.when(
      data: (imageWithAspectRatio) {
        return AspectRatio(
          aspectRatio: imageWithAspectRatio.aspectRatio,
          child: imageWithAspectRatio.image,
        );
      },
      error: (error, stackTrace) {
        return const SmallErrorAnimationView();
      },
      loading: () {
        return const LoadingAnimationView();
      },
    );
  }
}

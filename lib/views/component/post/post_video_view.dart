import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:instagram_clone/state/post/model/post.dart';
import 'package:instagram_clone/views/component/animation/error_animation_view.dart';
import 'package:instagram_clone/views/component/animation/loading_animation_view.dart';
import 'package:video_player/video_player.dart';

class PostVideoView extends HookWidget {
  final Post post;
  const PostVideoView({
    super.key,
    required this.post,
  });

  @override
  Widget build(BuildContext context) {
    final controller = VideoPlayerController.network(post.fileUrl);

    final isVideoPlayerReady = useState(false);
    useEffect(
      () {
        controller.initialize().then((_) {
          isVideoPlayerReady.value = true;
          controller.setLooping(true);
          controller.play();
        });
        return controller.dispose;
      },
      [
        controller,
      ],
    );
    switch (isVideoPlayerReady.value) {
      case true:
        return AspectRatio(
          aspectRatio: post.aspectRatio,
          child: VideoPlayer(controller),
        );
      case false:
        return const LoadingAnimationView();
      default: //this shouldn't be called
        return const ErrorAnimationView();
    }
  }
}

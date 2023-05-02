import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone/state/post/provider/all_post_provider.dart';
import 'package:instagram_clone/views/component/animation/empty_content_with_text_animation_view.dart';
import 'package:instagram_clone/views/component/animation/error_animation_view.dart';
import 'package:instagram_clone/views/component/animation/loading_animation_view.dart';
import 'package:instagram_clone/views/component/post/post_grid_view.dart';
import 'package:instagram_clone/views/constant/strings.dart';

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final posts = ref.watch(allPostProvider);
    return RefreshIndicator(
      onRefresh: () {
        return Future.delayed(
          const Duration(seconds: 1),
          () => ref.refresh(allPostProvider),
        );
      },
      child: posts.when(
        data: (posts) {
          if (posts.isEmpty) {
            return const EmptyContentWithTextAnimationView(
              text: Strings.noPostsAvailable,
            );
          } else {
            return PostGridView(
              posts: posts,
            );
          }
        },
        error: (error, stackTrace) {
          return const ErrorAnimationView();
        },
        loading: () {
          return const LoadingAnimationView();
        },
      ),
    );
  }
}

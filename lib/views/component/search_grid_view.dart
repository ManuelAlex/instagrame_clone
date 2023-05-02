import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone/state/post/provider/post_by_search_term_provider.dart';
import 'package:instagram_clone/state/post/typedefs/search_term.dart';
import 'package:instagram_clone/views/component/animation/data_not_found_animation_view.dart';
import 'package:instagram_clone/views/component/animation/empty_content_with_text_animation_view.dart';
import 'package:instagram_clone/views/component/animation/error_animation_view.dart';
import 'package:instagram_clone/views/component/animation/loading_animation_view.dart';
import 'package:instagram_clone/views/component/constant/strings.dart';
import 'package:instagram_clone/views/component/post/post_sliver_grid_view.dart';

class SearchGridView extends ConsumerWidget {
  final SearchTerm searchTerm;
  const SearchGridView({
    super.key,
    required this.searchTerm,
  });

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    if (searchTerm.isEmpty) {
      return const SliverToBoxAdapter(
        child: EmptyContentWithTextAnimationView(
          text: Strings.enterYourSearchTermHere,
        ),
      );
    }
    final posts = ref.watch(
      postBySearchTermProvider(searchTerm),
    );

    return posts.when(
      data: (posts) {
        if (posts.isEmpty) {
          return const SliverToBoxAdapter(
            child: DataNotFoundAnimationView(),
          );
        }
        return PostSliverGridView(
          posts: posts,
        );
      },
      error: (stackTrace, error) => const SliverToBoxAdapter(
        child: ErrorAnimationView(),
      ),
      loading: () => const SliverToBoxAdapter(
        child: LoadingAnimationView(),
      ),
    );
  }
}

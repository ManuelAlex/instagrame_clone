import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone/views/component/constant/strings.dart';
import 'package:instagram_clone/views/component/search_grid_view.dart';
import 'package:instagram_clone/views/extensions/dismiss_keyboard.dart';

class SearchTabView extends HookConsumerWidget {
  const SearchTabView({super.key});

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final controller = useTextEditingController();
    final searchTerm = useState('');
    useEffect(() {
      controller.addListener(() {
        searchTerm.value = controller.text;
      });
      return () {};
    }, [
      controller,
    ]);
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: controller,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                  labelText: Strings.enterYourSearchTermHere,
                  suffixIcon: IconButton(
                      onPressed: () {
                        controller.clear();
                        dismisskeyboard();
                      },
                      icon: const Icon(Icons.clear))),
            ),
          ),
        ),
        SearchGridView(
          searchTerm: controller.text,
        )
      ],
    );
  }
}

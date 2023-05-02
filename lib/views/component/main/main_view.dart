import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone/state/auth/provider/auth_state_provider.dart';
import 'package:instagram_clone/state/image_upload/helpers/image_picker.dart';
import 'package:instagram_clone/state/image_upload/model/file_type.dart';
import 'package:instagram_clone/state/post_setting/provider/post_setting_provider.dart';
import 'package:instagram_clone/views/component/dialogs/alart_dialogs_model.dart';
import 'package:instagram_clone/views/component/dialogs/logout_dialog.dart';
import 'package:instagram_clone/views/constant/strings.dart';
import 'package:instagram_clone/views/create_new_post/create_new_post_view.dart';
import 'package:instagram_clone/views/tabs/search/search_view.dart';
import 'package:instagram_clone/views/tabs/user_post/user_post_view.dart';

class MainView extends ConsumerStatefulWidget {
  const MainView({super.key});

  @override
  ConsumerState<MainView> createState() => _MainViewState();
}

class _MainViewState extends ConsumerState<MainView> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(Strings.appName),
          actions: [
            IconButton(
              onPressed: () async {
                final videoFile =
                    await ImagePickerHelper.pickVideoFromGallery();
                if (videoFile == null) {
                  return;
                }
                () => ref.refresh(postSettingsProvider);

                if (!mounted) {
                  return;
                }
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => CreateNewPostView(
                      fileToPost: videoFile,
                      fileTypeToPost: FileType.video,
                    ),
                  ),
                );
              },
              icon: const FaIcon(
                FontAwesomeIcons.film,
              ),
            ),
            IconButton(
              onPressed: () async {
                final imageFile =
                    await ImagePickerHelper.pickImageFromGallery();
                if (imageFile == null) {
                  return;
                }
                () => ref.refresh(postSettingsProvider);

                if (!mounted) {
                  return;
                }
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => CreateNewPostView(
                      fileToPost: imageFile,
                      fileTypeToPost: FileType.image,
                    ),
                  ),
                );
              },
              icon: const Icon(
                Icons.add_a_photo_outlined,
              ),
            ),
            IconButton(
              onPressed: () async {
                final shouldLogout = await const LogOutDialog()
                    .present(context)
                    .then((value) => value ?? false);
                if (shouldLogout) {
                  await ref
                      .read(
                        authStateProvider.notifier,
                      )
                      .logOut();
                }
              },
              icon: const Icon(
                Icons.logout,
              ),
            ),
          ],
          bottom: const TabBar(tabs: [
            Tab(
              icon: Icon(
                Icons.person,
              ),
            ),
            Tab(
              icon: Icon(
                Icons.search,
              ),
            ),
            Tab(
              icon: Icon(
                Icons.home,
              ),
            ),
          ]),
        ),
        body: const TabBarView(children: [
          UserPostView(),
          SearchTabView(),
          UserPostView(),
        ]),
      ),
    );
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone/state/auth/provider/user_id_provider.dart';
import 'package:instagram_clone/state/image_upload/model/file_type.dart';
import 'package:instagram_clone/state/image_upload/model/thumbnail_request.dart';
import 'package:instagram_clone/state/image_upload/provider/image_uploader_provider.dart';
import 'package:instagram_clone/state/post_setting/model/post_settings.dart';
import 'package:instagram_clone/state/post_setting/provider/post_setting_provider.dart';
import 'package:instagram_clone/views/component/constant/strings.dart';
import 'package:instagram_clone/views/component/file_thumbnail_view.dart';

class CreateNewPostView extends StatefulHookConsumerWidget {
  final File fileToPost;
  final FileType fileTypeToPost;
  const CreateNewPostView({
    required this.fileToPost,
    required this.fileTypeToPost,
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CreateNewPostViewState();
}

class _CreateNewPostViewState extends ConsumerState<CreateNewPostView> {
  @override
  Widget build(BuildContext context) {
    final thumbnailRequest = ThumbNailRequest(
      file: widget.fileToPost,
      fileType: widget.fileTypeToPost,
    );
    final postSettings = ref.watch(postSettingsProvider);
    final postController = useTextEditingController();
    final focusNode = useFocusNode(canRequestFocus: false);
    final isPostButtonEnabled = useState<bool>(false);
    useEffect(() {
      void listner() {
        isPostButtonEnabled.value = postController.text.isNotEmpty;
      }

      postController.addListener(
        listner,
      );
      return () {
        postController.removeListener(listner);
      };
    }, [postController]);
    return Scaffold(
      appBar: AppBar(
        title: const Text(Strings.createNewPost),
        actions: [
          IconButton(
            onPressed: isPostButtonEnabled.value
                ? () async {
                    final userId = ref.read(userIdProvider);
                    if (userId == null) {
                      return;
                    }
                    final message = postController.text;
                    final isUploaded = await ref
                        .read(imageUploadProvider.notifier)
                        .upload(
                            userId: userId,
                            file: widget.fileToPost,
                            fileType: widget.fileTypeToPost,
                            message: message,
                            postSettings: postSettings);
                    if (isUploaded && mounted) {
                      Navigator.of(context).pop();
                    }
                  }
                : null,
            icon: const Icon(
              Icons.send,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            //thumbnail
            FileThumbnailView(
              thumbNailRequest: thumbnailRequest,
            ),
            //TextField
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: const InputDecoration(
                  labelText: Strings.pleaseWriteYourMessageHere,
                ),
                autofocus: true,
                maxLines: null,
                controller: postController,
                focusNode: focusNode,
              ),
            ),
            ...PostSettings.values.map(
              (postSetting) => ListTile(
                title: Text(postSetting.tittle),
                subtitle: Text(postSetting.description),
                trailing: Switch(
                    value: postSettings[postSetting] ?? false,
                    onChanged: (isOn) {
                      ref
                          .read(postSettingsProvider.notifier)
                          .setSetting(postSetting, isOn);
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

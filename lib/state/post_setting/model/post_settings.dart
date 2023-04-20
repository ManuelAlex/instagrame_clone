import 'package:instagram_clone/state/post_setting/constanst/contant.dart';

enum PostSettings {
  allowLikes(
    tittle: Constants.allowLikesTitle,
    description: Constants.allowLikesTitle,
    storageKey: Constants.allowLikesStorageKey,
  ),
  allowComments(
    tittle: Constants.allowCommentsTitle,
    description: Constants.allowCommentsTitle,
    storageKey: Constants.allowCommentsStorageKey,
  );

  final String tittle;
  final String description;
  final String storageKey;
  const PostSettings({
    required this.tittle,
    required this.description,
    required this.storageKey,
  });
}

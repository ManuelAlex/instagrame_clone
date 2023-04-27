import 'package:flutter/foundation.dart' show immutable;
import 'package:instagram_clone/state/enums/date_sorting.dart';
import 'package:instagram_clone/state/post/typedefs/post_id.dart';

@immutable
class RequestsForPostsAndComments {
  final PostId postId;
  final bool sortByCreatedAt;
  final DateSorting dateSorting;
  final int? limit;

  const RequestsForPostsAndComments({
    required this.postId,
    this.sortByCreatedAt = true,
    this.dateSorting = DateSorting.newestOnTop,
    this.limit,
  });

  @override
  bool operator ==(covariant RequestsForPostsAndComments other) =>
      identical(this, other) ||
      runtimeType == other.runtimeType &&
          postId == other.postId &&
          sortByCreatedAt == other.sortByCreatedAt &&
          dateSorting == other.dateSorting &&
          limit == other.limit;

  @override
  int get hashCode => Object.hashAll([
        postId,
        sortByCreatedAt,
        dateSorting,
        limit,
      ]);
}

import 'package:instagram_clone/state/comment/models/comment_model.dart';
import 'package:instagram_clone/state/comment/models/post_comments_requests.dart';
import 'package:instagram_clone/state/enums/date_sorting.dart';

extension CommentSortingByRequest on Iterable<Comment> {
  Iterable<Comment> applySortingFrom(
      {required RequestsForPostsAndComments requests}) {
    if (requests.sortByCreatedAt) {
      final sortedDocs = toList()
        ..sort(((a, b) {
          switch (requests.dateSorting) {
            case DateSorting.newestOnTop:
              return b.createdAt.compareTo(a.createdAt);

            case DateSorting.oldestOnTop:
              return a.createdAt.compareTo(b.createdAt);
          }
        }));
      return sortedDocs;
    } else {
      return this;
    }
  }
}

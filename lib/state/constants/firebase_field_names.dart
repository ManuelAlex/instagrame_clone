import 'package:flutter/foundation.dart' show immutable;

@immutable
class FirebaseFieldName {
  static const postId = 'uid';
  static const comment = 'comments';
  static const userId = 'user_id';
  static const createdAt = 'created_at';
  static const date = 'date';
  static const displayName = 'display_name';
  static const email = 'email';
  const FirebaseFieldName._();
}

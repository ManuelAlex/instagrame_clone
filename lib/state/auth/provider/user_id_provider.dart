import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone/state/auth/provider/auth_state_provider.dart';
import 'package:instagram_clone/state/post/typedefs/user_id.dart';

// final userIdProvider = Provider<UserId?>((
//   ref,
// ) {
//   final authState = ref.watch(
//     authStateProvider,
//   );
//   return authState.userId;
// });
final userIdProvider = Provider<UserId?>(
  ((ref) => ref.watch(authStateProvider).userId),
);

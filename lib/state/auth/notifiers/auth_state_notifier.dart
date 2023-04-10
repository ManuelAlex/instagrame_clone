import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone/state/auth/backend/authenticator.dart';
import 'package:instagram_clone/state/auth/models/auth_results.dart';
import 'package:instagram_clone/state/auth/models/auth_state.dart';
import 'package:instagram_clone/state/post/typedefs/user_id.dart';
import 'package:instagram_clone/state/user_info/backend/user_info_storage.dart';

class AuthStateNotifier extends StateNotifier<AuthState> {
  final _authenticator = const Authenticator();
  final _userStorage = const UserInfoStorage();
  AuthStateNotifier() : super(const AuthState.unKnown()) {
    if (_authenticator.isAlreadyLoggedIn) {
      state = AuthState(
        result: AuthResult.success,
        isLoading: false,
        userId: _authenticator.userId,
      );
    }
  }
  Future<void> logOut() async {
    state = state.copiedWithIsloading(true);
    await _authenticator.logout();
    state = const AuthState.unKnown();
  }

  Future<void> loginWithGoogle() async {
    state = state.copiedWithIsloading(true);
    final result = await _authenticator.loginWithGoogle();
    final userId = _authenticator.userId;
    if (result == AuthResult.success && userId != null) {
      await saveUserInfo(
        userId: userId,
      );
      state = AuthState(
        result: result,
        isLoading: false,
        userId: userId,
      );
    }
  }

  Future<void> loginWithFacebook() async {
    state = state.copiedWithIsloading(true);
    final result = await _authenticator.loginWithFacebook();
    final userId = _authenticator.userId;
    if (result == AuthResult.success && userId != null) {
      await saveUserInfo(
        userId: userId,
      );
      state = AuthState(
        result: result,
        isLoading: false,
        userId: userId,
      );
    }
  }

  Future<void> saveUserInfo({
    required UserId userId,
  }) async {
    _userStorage.saveUserInfo(
      userId: userId,
      displayName: _authenticator.currentDisplayName,
      email: _authenticator.email,
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:instagram_clone/state/auth/constants/constants.dart';
import 'package:instagram_clone/state/auth/models/auth_results.dart';
import 'package:instagram_clone/state/post/typedefs/user_id.dart';

class Authenticator {
  const Authenticator();
  User? get user => FirebaseAuth.instance.currentUser;
  UserId? get userId => user?.uid;
  bool get isAlreadyLoggedIn => userId != null;
  String get currentDisplayName => user?.displayName ?? '';
  String? get email => user?.email;

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
    await FacebookAuth.instance.logOut();
  }

  Future<AuthResult> loginWithFacebook() async {
    final loginResult = await FacebookAuth.instance.login(
      permissions: ['email', 'public_profile'],
    );
    final token = loginResult.accessToken?.token;
    if (token == null) {
      //user arborted login proccess

      return AuthResult.arborted;
    }
    // then get user credential
    final oAuthCredential = FacebookAuthProvider.credential(token);
    try {
      await FirebaseAuth.instance.signInWithCredential(oAuthCredential);
      return AuthResult.success;
    } on FirebaseAuthException catch (e) {
      final email = e.email;
      final credencial = e.credential;
      if (e.code == Constants.accountExistsWithDifferentCredentialsError &&
          email != null &&
          credencial != null) {
        final provider = await FirebaseAuth.instance.fetchSignInMethodsForEmail(
          email,
        );
        if (provider.contains(Constants.googleCom)) {
          await loginWithGoogle();
          await FirebaseAuth.instance.currentUser
              ?.linkWithCredential(credencial);

          return AuthResult.success;
        }
      }
      return AuthResult.failure;
    }
  }

  Future<AuthResult> loginWithGoogle() async {
    final googleSignIn = GoogleSignIn();
    final signInToAccount = await googleSignIn.signIn();

    if (signInToAccount == null) {
      return AuthResult.arborted;
    }
    final googleAuth = await signInToAccount.authentication;
    if (googleAuth.accessToken != null && googleAuth.idToken != null) {}
    try {
      final oAuthCreditials = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(oAuthCreditials);

      return AuthResult.success;
    } catch (e) {
      return AuthResult.failure;
    }
  }
}

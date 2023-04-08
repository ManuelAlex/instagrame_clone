import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:instagram_clone/state/auth/constants/constants.dart';
import 'package:instagram_clone/state/auth/models/auth_results.dart';
import 'package:instagram_clone/state/post/typedefs/user_id.dart';

class Authenticator {
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
    print('Facebook Login called');
    final loginResult = await FacebookAuth.instance.login(
      permissions: ['email', 'public_profile'],
    );
    final token = loginResult.accessToken?.token;
    if (token == null) {
      //user arborted login proccess
      print("token aborted for fb");
      return AuthResult.arborted;
    }
    // then get user credential
    final oAuthCredential = FacebookAuthProvider.credential(token);
    try {
      print("trying firebase fb");
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
          print('Facebook Login Executed');
          return AuthResult.success;
        }
      }
      return AuthResult.failure;
    }
  }

  Future<AuthResult> loginWithGoogle() async {
    print('google Login called');
    final googleSignIn = GoogleSignIn(
      scopes: [Constants.googleCom],
    );
    final signInToAccount =
        await googleSignIn.signIn().catchError((onError) => print(onError));
    ;
    if (signInToAccount == null) {
      print("user aborted gogle signing");
      return AuthResult.arborted;
    }
    final googleAuth = await signInToAccount.authentication;
    if (googleAuth.accessToken != null && googleAuth.idToken != null) {}
    try {
      final oAuthCreditials = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      print("trying gogle signing");
      await FirebaseAuth.instance.signInWithCredential(oAuthCreditials);
      print('google Login Executed');
      return AuthResult.success;
    } catch (e) {
      print(e);
      return AuthResult.failure;
    }
  }
}

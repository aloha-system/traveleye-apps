import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRemoteDatasource {
  final FirebaseAuth firebaseAuth;
  final GoogleSignIn _googleSignIn;

  const AuthRemoteDatasource(this.firebaseAuth, this._googleSignIn);

  // firebase authentication create accound with email and password
  Future<User> createAccount({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final result = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await result.user!.updateDisplayName(name);

      return result.user!;
    } on FirebaseAuthException catch (e) {
      throw Exception('Failed to create an account. ${e.code}');
    }
  }

  // firebase authentication sign in with email and password
  Future<User> signIn(String email, String password) async {
    try {
      final result = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return result.user!;
    } on FirebaseAuthException catch (e) {
      throw Exception(_mapFirebaseError(e));
    } catch (e) {
      throw Exception('Unexpected Error');
    }
  }

  // firebase authentication sign out
  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }

  // firebase authentication sign in with Google
  Future<User> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw Exception('Sign in aborted');
      }
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final result = await firebaseAuth.signInWithCredential(credential);
      return result.user!;
    } on FirebaseAuthException catch (e) {
      throw Exception('Google sign-in failed. ${e.code}');
    } catch (e) {
      rethrow;
    }
  }

  // firebase authentication reset password
  Future<void> resetPassword(String email) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw Exception('Failed to reset your password. ${e.code}');
    } on Exception catch (e) {
      throw Exception('Unexpected error. $e');
    }
  }

  // firebase error map for firebase authentication sign in
  _mapFirebaseError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'User not found';
      case 'wrong-password':
        return 'Wrong password';
      case 'invalid-email':
        return 'Email is not valid';
      default:
        return 'Unexpected error. Please try again later.';
    }
  }
}

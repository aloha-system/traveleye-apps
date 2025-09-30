import 'package:firebase_auth/firebase_auth.dart';

class AuthRemoteDatasource {
  final FirebaseAuth firebaseAuth;

  const AuthRemoteDatasource(this.firebaseAuth);

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

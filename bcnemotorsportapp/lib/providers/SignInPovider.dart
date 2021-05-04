import 'package:bcnemotorsportapp/services/DatabaseService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignInProvider extends ChangeNotifier {
  final BuildContext context;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  bool _isSigningIn;

  SignInProvider(context) : this.context = context {
    _isSigningIn = false;
  }

  bool get isSigningIn => _isSigningIn;

  set isSigningIn(bool isSigningIn) {
    _isSigningIn = isSigningIn;
    notifyListeners();
  }

  Future<bool> login() async {
    isSigningIn = true; // the setter is called
    final user = await googleSignIn.signIn();
    if (user != null) {
      // check if this user has permission or perhaps is Terrassa
      if (await DatabaseService.isEmailAuthorized(user.email)) {
        await googleSignIn.disconnect();
        isSigningIn = false;
        return false;
      }
      final googleAuth = await user.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
    }
    isSigningIn = false; // the setter is called
    return true;
  }

  Future<void> logout() async {
    await googleSignIn.disconnect();
    FirebaseAuth.instance.signOut();
  }
}
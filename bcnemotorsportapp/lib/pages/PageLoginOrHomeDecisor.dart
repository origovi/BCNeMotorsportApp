import 'package:bcnemotorsportapp/models/utilsAndErrors.dart';
import 'package:bcnemotorsportapp/providers/CloudDataProvider.dart';
import 'package:bcnemotorsportapp/pages/ScreenHome.dart';
import 'package:bcnemotorsportapp/screens/ScreenLogin.dart';
import 'package:bcnemotorsportapp/providers/SignInPovider.dart';
import 'package:bcnemotorsportapp/services/DatabaseService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PageLoginOrHomeDecisor extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, userSnapshot) {
        final signInProvider = Provider.of<SignInProvider>(context);
        // show error
        if (userSnapshot.hasError)
          return PageError(userSnapshot.error.toString());
        // if the user is signing in
        else if (signInProvider.isSigningIn)
          return ScreenLogin(loading: true);
        // if the user has successfully signed in
        else if (userSnapshot.hasData) {
          return FutureBuilder(
            future: DatabaseService.getAllUserData(user: userSnapshot.data),
            builder: (context, dataSnapshot) {
              // show error
              if (dataSnapshot.hasError)
                return PageError(dataSnapshot.error.toString());
              else if (dataSnapshot.hasData) {
                return ChangeNotifierProvider<CloudDataProvider>(
                  create: (context) =>
                      CloudDataProvider(context, data: dataSnapshot.data, user: userSnapshot.data),
                  child: ScreenHome(),
                );
              } else
                return ScreenLogin(loading: true);
            },
          );
        } else {
          return ScreenLogin(loading: false);
        }
      },
    );
  }
}

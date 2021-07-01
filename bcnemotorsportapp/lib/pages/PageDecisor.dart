import 'package:bcnemotorsportapp/models/AllData.dart';
import 'package:bcnemotorsportapp/models/utilsAndErrors.dart';
import 'package:bcnemotorsportapp/providers/CloudDataProvider.dart';
import 'package:bcnemotorsportapp/pages/PageHome.dart';
import 'package:bcnemotorsportapp/screens/ScreenLogin.dart';
import 'package:bcnemotorsportapp/providers/SignInPovider.dart';
import 'package:bcnemotorsportapp/screens/ScreenWithLogo.dart';
import 'package:bcnemotorsportapp/services/DatabaseService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PageDecisor extends StatefulWidget {
  @override
  _PageDecisorState createState() => _PageDecisorState();
}

class _PageDecisorState extends State<PageDecisor> {
  bool firstTime;
  @override
  void initState() { 
    super.initState();
    firstTime = true;
  }
  @override
  Widget build(BuildContext context) {
    // internet connection checker
    return StreamBuilder(
        stream: DataConnectionChecker().onStatusChange,
        builder: (context, AsyncSnapshot<DataConnectionStatus> connectionSnapshot) {
          if (connectionSnapshot.hasError)
            return PageError(connectionSnapshot.error.toString());
          // the internet connection status has changed
          else if (connectionSnapshot.hasData) {
            // if you have internet connection
            if (connectionSnapshot.data == DataConnectionStatus.connected)
              return StreamBuilder(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (context, AsyncSnapshot<User> userSnapshot) {
                  final signInProvider = Provider.of<SignInProvider>(context);
                  // show error
                  if (userSnapshot.hasError)
                    return PageError(userSnapshot.error.toString());
                  // if the user is signing in
                  else if (signInProvider.isSigningIn)
                    return ScreenLogin(loading: true);
                  // if the user has successfully signed in
                  else if (userSnapshot.hasData) {
                    // check if the user has access and get dbId
                    return StreamBuilder<QuerySnapshot>(
                        stream: DatabaseService.dbIdStream(userSnapshot.data.email),
                        builder: (context, AsyncSnapshot<QuerySnapshot> dbIdSnapshot) {
                          if (dbIdSnapshot.hasError)
                            return PageError(userSnapshot.error.toString());
                          else if (dbIdSnapshot.hasData) {
                            if (dbIdSnapshot.data.size >= 1) {
                              // sections stream
                              return StreamBuilder<QuerySnapshot>(
                                stream: DatabaseService.sectionsStream(),
                                builder: (context, AsyncSnapshot<QuerySnapshot> sectionsSnapshot) {
                                  // show error
                                  if (sectionsSnapshot.hasError)
                                    return PageError(sectionsSnapshot.error.toString());
                                  else if (sectionsSnapshot.hasData) {
                                    print("new sections data");
                                    // persons stream
                                    return StreamBuilder<QuerySnapshot>(
                                      stream: DatabaseService.personsStream(),
                                      builder:
                                          (context, AsyncSnapshot<QuerySnapshot> personsSnapshot) {
                                        // show error
                                        if (personsSnapshot.hasError)
                                          return PageError(personsSnapshot.error.toString());
                                        else if (personsSnapshot.hasData) {
                                          print("new persons data");
                                          // calendar stream
                                          List<String> userSectionIds = [];
                                          personsSnapshot.data.docs.where((element) => element.data()['dbId'] == dbIdSnapshot.data.docs[0].id).toList().first.data()['sections'].forEach((key, value) => userSectionIds.add(key));
                                          return StreamBuilder<QuerySnapshot>(
                                            stream: DatabaseService.calendarStream(userSectionIds),
                                            builder: (context,
                                                AsyncSnapshot<QuerySnapshot> calendarSnapshot) {
                                              // show error
                                              if (calendarSnapshot.hasError)
                                                return PageError(calendarSnapshot.error.toString());
                                              else if (calendarSnapshot.hasData) {
                                                print("new calendar data");
                                                Provider.of<CloudDataProvider>(context,
                                                        listen: false)
                                                    .init(
                                                        firstTime,
                                                        dbId: dbIdSnapshot.data.docs[0].id,
                                                        data: AllData.fromDatabase(sectionsData: sectionsSnapshot.data, personsData: personsSnapshot.data, calendarData: calendarSnapshot.data),
                                                        user: userSnapshot.data);
                                                firstTime = false;
                                                return PageHome();
                                              } else
                                                return ScreenLogin(loading: true);
                                            },
                                          );
                                        } else
                                          return ScreenLogin(loading: true);
                                      },
                                    );
                                  } else
                                    return ScreenLogin(loading: true);
                                },
                              );
                            }
                            // if the user was logged in and kicked (intruder)
                            else {
                              signInProvider.logout();
                              return ScreenLogin(loading: false);
                            }
                          } else
                            return ScreenLogin(loading: true);
                        });
                  } else {
                    return ScreenLogin(loading: false);
                  }
                },
              );
            // if there is no internet :(
            else
              return ScreenWithLogo(Text(
                "It seems you have lost your internet connection. Eduroam not working? LOL",
                style: TextStyle(color: Colors.white, fontSize: 17),
              ));
          } else
            return ScreenLogin(loading: true);
        });
  }
}

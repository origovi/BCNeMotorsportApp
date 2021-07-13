import 'package:bcnemotorsportapp/Constants.dart';
import 'package:bcnemotorsportapp/models/AllData.dart';
import 'package:bcnemotorsportapp/pages/PageError.dart';
import 'package:bcnemotorsportapp/providers/CloudDataProvider.dart';
import 'package:bcnemotorsportapp/pages/PageHome.dart';
import 'package:bcnemotorsportapp/screens/ScreenLogin.dart';
import 'package:bcnemotorsportapp/providers/SignInPovider.dart';
import 'package:bcnemotorsportapp/services/DatabaseService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ########################
// ## SUPER IMPORTANT!!! ##
// ## NO AUTOFORMAT      ##
// ########################

class DecisorScreen extends StatelessWidget {
  static const String app_version = "0.1";

  static final ScreenLogin screenLoginLoading = ScreenLogin(loading: true);

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
              return StreamBuilder<QuerySnapshot>(
                  stream: DatabaseService.versionStream(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> versionSnapshot) {
                    if (versionSnapshot.hasError)
                      return PageError(versionSnapshot.error.toString());
                    else if (versionSnapshot.hasData) {
                      // if the version of this app is not the latest
                      if (versionSnapshot.data.docs.isEmpty || versionSnapshot.data.docs[0].data()['version'] != DecisorScreen.app_version)
                        return PageError(Phrases.invalidAppVersion);
                      else
                        return StreamBuilder(
                          stream: FirebaseAuth.instance.authStateChanges(),
                          builder: (context, AsyncSnapshot<User> userSnapshot) {
                            final signInProvider = Provider.of<SignInProvider>(context);
                            // show error
                            if (userSnapshot.hasError)
                              return PageError(userSnapshot.error.toString());
                            // if the user is signing in
                            else if (signInProvider.isSigningIn)
                              return screenLoginLoading;
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
                                                builder: (context, AsyncSnapshot<QuerySnapshot> personsSnapshot) {
                                                  // show error
                                                  if (personsSnapshot.hasError)
                                                    return PageError(personsSnapshot.error.toString());
                                                  else if (personsSnapshot.hasData) {
                                                    print("new persons data");
                                                    // calendar stream
                                                    List<String> userSectionIds = [];
                                                    personsSnapshot.data.docs.where((element) => element.data()['dbId'] == dbIdSnapshot.data.docs[0].id)
                                                        .toList().first.data()['sections'].forEach((key, value) => userSectionIds.add(key));
                                                    bool isTeamLeader = personsSnapshot.data.docs.where((element) => element.data()['dbId'] == dbIdSnapshot.data.docs[0].id)
                                                            .toList().first.data()['teamLeader'];
                                                    return StreamBuilder<QuerySnapshot>(
                                                      stream: DatabaseService.calendarStream(
                                                        global: false,
                                                        sectionIds: userSectionIds,
                                                        isTeamLeader: isTeamLeader
                                                      ),
                                                      builder: (context, AsyncSnapshot<QuerySnapshot> calendarSectionSnapshot) {
                                                        // show error
                                                        if (calendarSectionSnapshot.hasError)
                                                          return PageError(calendarSectionSnapshot.error.toString());
                                                        else if (calendarSectionSnapshot.hasData) {
                                                          print("new calendar section data");
                                                          // calendar stream                                                          
                                                          return StreamBuilder<QuerySnapshot>(
                                                            stream: DatabaseService.calendarStream(
                                                                global: true),
                                                            builder: (context, AsyncSnapshot<QuerySnapshot> calendarGlobalSnapshot) {
                                                              // show error
                                                              if (calendarGlobalSnapshot.hasError)
                                                                return PageError(calendarGlobalSnapshot.error.toString());
                                                              else if (calendarGlobalSnapshot.hasData) {
                                                                print("new calendar global data");
                                                                return StreamBuilder<QuerySnapshot>(
                                                                  stream: DatabaseService.announcementsStream(
                                                                    global: false,
                                                                    sectionIds: userSectionIds,
                                                                    isTeamLeader: isTeamLeader
                                                                  ),
                                                                  builder: (context, AsyncSnapshot<QuerySnapshot> announcementsSectionSnapshot) {
                                                                    // show error
                                                                    if (announcementsSectionSnapshot.hasError)
                                                                      return PageError(announcementsSectionSnapshot.error.toString());
                                                                    else if (announcementsSectionSnapshot.hasData) {
                                                                      print("new announcements section data");
                                                                      
                                                                      // calendar stream                                                                      
                                                                      return StreamBuilder<QuerySnapshot>(
                                                                        stream: DatabaseService.announcementsStream(
                                                                            global: true),
                                                                        builder: (context, AsyncSnapshot<QuerySnapshot> announcementsGlobalSnapshot) {
                                                                          // show error
                                                                          if (announcementsGlobalSnapshot.hasError)
                                                                            return PageError(announcementsGlobalSnapshot.error.toString());
                                                                          else if (announcementsGlobalSnapshot.hasData) {
                                                                            print("new announcements global data");
                                                                            
                                                                            final CloudDataProvider provider = Provider.of<CloudDataProvider>(context, listen: false);
                                                                            List<String> selectedSectionIds = [];
                                                                            bool global;
                                                                            if (!provider.allDataNull) {
                                                                              selectedSectionIds = provider.calendarData.selectedSectionIds;
                                                                              global = provider.calendarData.global;
                                                                            }
                                                                            provider.init(
                                                                              dbId: dbIdSnapshot.data.docs[0].id,
                                                                              data: AllData.fromDatabase(
                                                                                sectionsData: sectionsSnapshot.data,
                                                                                personsData: personsSnapshot.data,
                                                                                eventData: calendarSectionSnapshot.data.docs + calendarGlobalSnapshot.data.docs,
                                                                                announcementData: announcementsSectionSnapshot.data.docs + announcementsGlobalSnapshot.data.docs,
                                                                              ),
                                                                              user: userSnapshot.data,
                                                                            );
                                                                            // filter calendar as it was before
                                                                            if (global != null) {
                                                                              provider.calendarData.filterCalendar(
                                                                                global: global,
                                                                                sectionIds: selectedSectionIds,
                                                                              );
                                                                            }
                                                                            // filter calendar, all appointments permited
                                                                            else {
                                                                              provider.calendarData.filterCalendar(
                                                                                global: true,
                                                                                sectionIds: provider.user.memberSectionIds,
                                                                              );
                                                                            }
                                                                            return PageHome();
                                                                          } else
                                                                            return screenLoginLoading;
                                                                        },
                                                                      );
                                                                    } else
                                                                      return screenLoginLoading;
                                                                  },
                                                                );
                                                              } else
                                                                return screenLoginLoading;
                                                            },
                                                          );
                                                        } else
                                                          return screenLoginLoading;
                                                      },
                                                    );
                                                  } else
                                                    return screenLoginLoading;
                                                },
                                              );
                                            } else
                                              return screenLoginLoading;
                                          },
                                        );
                                      }
                                      // if the user was logged in and kicked (intruder)
                                      else {
                                        signInProvider.logout();
                                        return ScreenLogin(loading: false);
                                      }
                                    } else
                                      return screenLoginLoading;
                                  });
                            } else {
                              return ScreenLogin(loading: false);
                            }
                          },
                        );
                    } else
                      return screenLoginLoading;
                  });

            // if there is no internet :(
            else
              return PageError(Phrases.noInternetConnection);
          } else
            return screenLoginLoading;
        });
  }
}

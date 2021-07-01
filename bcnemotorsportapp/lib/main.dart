import 'package:bcnemotorsportapp/Constants.dart';
import 'package:bcnemotorsportapp/models/utilsAndErrors.dart';
import 'package:bcnemotorsportapp/providers/CloudDataProvider.dart';
import 'package:bcnemotorsportapp/providers/SignInPovider.dart';
import 'package:bcnemotorsportapp/routeGenerator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _fbApp = Firebase.initializeApp();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    
    return FutureBuilder(
      future: _fbApp,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return PageError(snapshot.error.toString());
        } else if (snapshot.hasData) {
          return MultiProvider(
            providers: [
              ChangeNotifierProvider<SignInProvider>(
                create: (context) => SignInProvider(context),
              ),
              ChangeNotifierProvider<CloudDataProvider>(
                create: (context) => CloudDataProvider(context),
              ),
            ],
            child: MaterialApp(
              title: 'BCNeMotorsportApp',
              theme: ThemeData(
                primarySwatch: TeamColor.materialTeamColor,
              ),
              initialRoute: '/',
              onGenerateRoute: RouteGenerator.generateRoute,
            ),
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}

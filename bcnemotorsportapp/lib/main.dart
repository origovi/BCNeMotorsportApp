import 'dart:io';

import 'package:bcnemotorsportapp/Constants.dart';
import 'package:bcnemotorsportapp/providers/CloudDataProvider.dart';
import 'package:bcnemotorsportapp/providers/SignInPovider.dart';
import 'package:bcnemotorsportapp/routeGenerator.dart';
import 'package:bcnemotorsportapp/services/MessagingService.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await MessagingService.mainInitialization();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
    // needed to avoid app rotating landscape
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    if (Platform.isAndroid) {
      // needed to run app at highest framerate possible (ANDROID)
      FlutterDisplayMode.setHighRefreshRate();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<SignInProvider>(
          create: (context) => SignInProvider(context),
        ),
        ChangeNotifierProvider<CloudDataProvider>(
          create: (context) => CloudDataProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'BCNeMotorsportApp',
        theme: ThemeData(
          primarySwatch: TeamColor.materialTeamColor,
        ),
        initialRoute: '/',
        onGenerateRoute: RouteGenerator.generateRoute,
        supportedLocales: [const Locale('en', 'GB')],
        localizationsDelegates: GlobalMaterialLocalizations.delegates,
      ),
    );
  }
}

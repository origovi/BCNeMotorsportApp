import 'package:bcnemotorsportapp/Constants.dart';
import 'package:bcnemotorsportapp/providers/CloudDataProvider.dart';
import 'package:bcnemotorsportapp/providers/SignInPovider.dart';
import 'package:bcnemotorsportapp/routeGenerator.dart';
import 'package:bcnemotorsportapp/services/MessagingService.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await MessagingService.mainInitialization();

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // needed to avoid app rotating landscape
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    // needed to run app at highest framerate possible
    FlutterDisplayMode.setHighRefreshRate();
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

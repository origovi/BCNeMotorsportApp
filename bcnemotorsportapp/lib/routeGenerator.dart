import 'package:flutter/material.dart';
import 'models/utilsAndErrors.dart';

// Every page must be imported and then a route given
import 'package:bcnemotorsportapp/pages/PageLoginOrHomeDecisor.dart';
import 'screens/ScreenLogin.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      // Initial screen (root)
      case '/':
        return MaterialPageRoute(builder: (_) => PageLoginOrHomeDecisor());

      // EXAMPLE WITH ARGUMENTS
      // case '/new-debt':
      //   return MaterialPageRoute(
      //     builder: (_) => PageNewDebt(args),
      //   );

      // case '/home':
      //   // Comprovar si el tipus es adequat
      //   return MaterialPageRoute(
      //     builder: (_) => ScreenHome(),
      //   );

      // case '/settings':
      //   return MaterialPageRoute(builder: (_) => PageSettings());

      // case '/about':
      //   return MaterialPageRoute(builder: (_) => PageAbout());
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return PageError("Page Not Found");
    });
  }
}

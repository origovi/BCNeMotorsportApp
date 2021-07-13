import 'package:bcnemotorsportapp/pages/PageDisplayItem.dart';
import 'package:bcnemotorsportapp/pages/PageError.dart';
import 'package:bcnemotorsportapp/pages/PageEvent.dart';
import 'package:bcnemotorsportapp/pages/PageNewAnnouncement.dart';
import 'package:bcnemotorsportapp/pages/PageNewEvent.dart';
import 'package:bcnemotorsportapp/pages/PageNewMember.dart';
import 'package:flutter/material.dart';

// Every page must be imported and then a route given
import 'package:bcnemotorsportapp/Decisor.dart';
import 'package:bcnemotorsportapp/pages/PageSection.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
      print(settings.name);

    switch (settings.name) {
      // Initial screen (root)
      case '/':
        return MaterialPageRoute(builder: (_) => DecisorScreen());

      case '/team/section':
        return MaterialPageRoute(builder: (_) => PageSection(args));
        
      case '/team/newMember':
        return MaterialPageRoute(builder: (_) => PageNewMember());

      case '/calendar/newEvent':
        return MaterialPageRoute(builder: (_) => PageNewEvent());

      case '/calendar/newAnnouncement':
        return MaterialPageRoute(builder: (_) => PageNewAnnouncement());
        
      case '/calendar/event':
        return MaterialPageRoute(builder: (_) => PageEvent(args));

      case '/pageDisplayItem':
        Map<String, dynamic> args2 = new Map<String, dynamic>.from(args);
        return MaterialPageRoute(
          builder: (_) => PageDisplayItem(
            args2['child'],
            heroTag: args2['heroTag'],
            title: args2['title'],
            actions: args2['actions'],
          ),
        );

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

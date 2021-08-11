import 'package:bcnemotorsportapp/pages/PageDisplayItem.dart';
import 'package:bcnemotorsportapp/pages/PageError.dart';
import 'package:bcnemotorsportapp/pages/calendar/PageEvent.dart';
import 'package:bcnemotorsportapp/pages/calendar/PageNewAnnouncement.dart';
import 'package:bcnemotorsportapp/pages/calendar/PageNewEvent.dart';
import 'package:bcnemotorsportapp/pages/team/PageMember.dart';
import 'package:bcnemotorsportapp/pages/team/PageNewMember.dart';
import 'package:bcnemotorsportapp/pages/team/PageNewSection.dart';
import 'package:bcnemotorsportapp/pages/toDo/PageNewToDo.dart';
import 'package:bcnemotorsportapp/pages/toDo/PageToDo.dart';
import 'package:flutter/material.dart';

// Every page must be imported and then a route given
import 'package:bcnemotorsportapp/Decisor.dart';
import 'package:bcnemotorsportapp/pages/team/PageSection.dart';

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
      
      case '/team/member':
        Map<String, dynamic> aux = Map<String, dynamic>.from(args);
        return MaterialPageRoute(builder: (_) => PageMember(aux['person'], aux['setStateParent']));

      case '/team/newMember':
        return MaterialPageRoute(builder: (_) => PageNewMember());
  
      case '/team/newSection':
        return MaterialPageRoute(builder: (_) => PageNewSection());
      
      case '/calendar/newEvent':
        return MaterialPageRoute(builder: (_) => PageNewEvent());

      case '/calendar/newAnnouncement':
        return MaterialPageRoute(builder: (_) => PageNewAnnouncement());
        
      case '/calendar/event':
        return MaterialPageRoute(builder: (_) => PageEvent(args));

      case '/toDo/newToDo':
        return MaterialPageRoute(builder: (_) => PageNewToDo());

      case '/toDo/toDo':
        return MaterialPageRoute(builder: (_) => PageToDo(args));

      case '/pageDisplayItem':
        Map<String, dynamic> aux = new Map<String, dynamic>.from(args);
        return MaterialPageRoute(
          builder: (_) => PageDisplayItem(
            aux['child'],
            heroTag: aux['heroTag'],
            title: aux['title'],
            actions: aux['actions'],
          ),
        );

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

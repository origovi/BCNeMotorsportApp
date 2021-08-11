import 'package:bcnemotorsportapp/Constants.dart';
import 'package:bcnemotorsportapp/models/utilsAndErrors.dart';
import 'package:bcnemotorsportapp/providers/CloudDataProvider.dart';
import 'package:bcnemotorsportapp/screens/ScreenCalendar.dart';
import 'package:bcnemotorsportapp/screens/ScreenTeam.dart';
import 'package:bcnemotorsportapp/screens/ScreenToDo.dart';
import 'package:bcnemotorsportapp/screens/ScreenTesting.dart';
import 'package:bcnemotorsportapp/services/MessagingService.dart';
import 'package:bcnemotorsportapp/services/OneSignalService.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PageHome extends StatefulWidget {
  PageHome();
  @override
  _PageHomeState createState() => _PageHomeState();
}

class _PageHomeState extends State<PageHome> {
  int _currentSubsection;

  @override
  void initState() {
    super.initState();
    _currentSubsection = 0;
    Provider.of<CloudDataProvider>(context, listen: false).setContext(context);
    MessagingService.homeInitialization(
        context, Provider.of<CloudDataProvider>(context, listen: false).user.memberSectionIds);
    //OneSignalService.homeInitialization();
  }

  @override
  Widget build(BuildContext context) {
    changeSystemUi(navBarColor: Colors.grey[50], navBarBrightness: Brightness.dark);
    List<Widget> sections = [ScreenCalendar(), ScreenToDo(), /*ScreenTesting(), */ScreenTeam()];
    //final user = Provider.of<User>(context);
    // if (user != null && user.emailVerified)
    //   Provider.of<DebtsStatus>(context, listen: false).signIn(user);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      //backgroundColor: Colors.white,
      //floatingActionButton: FloatingButtonPers(position: _currentSubsection),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          setState(() {
            _currentSubsection = index;
          });
        },
        currentIndex: _currentSubsection,
        selectedItemColor: TeamColor.teamColor,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            label: "Next events",
            icon: Icon(Icons.calendar_today_outlined),
            activeIcon: Icon(Icons.calendar_today),
          ),
          BottomNavigationBarItem(
            label: "To Do",
            icon: Icon(Icons.task_alt), // task_alt, check_box, checklist_rtl
          ),
          // BottomNavigationBarItem(
          //   label: "Testing",
          //   icon: Icon(Icons.rv_hookup), // directions_car, rv_hookup, sports_motorsports
          // ),
          BottomNavigationBarItem(
            label: "Team",
            icon: Icon(Icons.groups_outlined),
            activeIcon: Icon(Icons.groups),
          )
        ],
      ),
      //body: Subsection(_currentSubsection),
      body: sections[_currentSubsection],
    );
  }
}

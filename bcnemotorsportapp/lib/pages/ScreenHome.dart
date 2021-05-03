import 'package:bcnemotorsportapp/Constants.dart';
import 'package:bcnemotorsportapp/models/utilsAndErrors.dart';
import 'package:bcnemotorsportapp/providers/CloudDataProvider.dart';
import 'package:bcnemotorsportapp/screens/ScreenCalendar.dart';
import 'package:bcnemotorsportapp/screens/ScreenTeam.dart';
import 'package:bcnemotorsportapp/screens/ScreenToDo.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ScreenHome extends StatefulWidget {
  ScreenHome();
  @override
  _ScreenHomeState createState() => _ScreenHomeState();
}

class _ScreenHomeState extends State<ScreenHome> {
  int _currentSubsection;

  @override
  void initState() {
    super.initState();
    _currentSubsection = 0;
  }

  @override
  Widget build(BuildContext context) {
    //final user = Provider.of<User>(context);
    // if (user != null && user.emailVerified)
    //   Provider.of<DebtsStatus>(context, listen: false).signIn(user);
    return Scaffold(
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
        items: [
          BottomNavigationBarItem(
            label: "Next events",
            icon: Icon(Icons.calendar_today),
          ),
          BottomNavigationBarItem(
            label: "To Do",
            icon: Icon(Icons.view_list_outlined),
          ),
          BottomNavigationBarItem(
            label: "Team",
            icon: Icon(Icons.supervisor_account_outlined),
            activeIcon: Icon(Icons.supervisor_account),
          )
        ],
      ),
      //body: Subsection(_currentSubsection),
      body: RefreshIndicator(
        child: ScrollConfiguration(
          behavior: NoGlowEffect(),
          child: sections[_currentSubsection],
        ),
        onRefresh: Provider.of<CloudDataProvider>(context, listen: false).refreshData,
      ),
    );
  }
}

List<Widget> sections = [ScreenCalendar(), ScreenToDo(), ScreenTeam()];

import 'package:bcnemotorsportapp/Constants.dart';
import 'package:flutter/material.dart';

class ScreenWithLogo extends StatelessWidget {
  final Widget theWidget;
  ScreenWithLogo(this.theWidget);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TeamColor.teamColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/white_team_logo.png',
              scale: 1.5,
            ),
            Container(height: 200,
              child: Center(child: theWidget),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:bcnemotorsportapp/Constants.dart';
import 'package:bcnemotorsportapp/models/utilsAndErrors.dart';
import 'package:flutter/material.dart';

class ScreenWithLogo extends StatelessWidget {
  final Widget theWidget;
  const ScreenWithLogo(this.theWidget);

  @override
  Widget build(BuildContext context) {
    changeSystemUi(navBarColor: TeamColor.teamColor, statusBarBrightness: Brightness.light, navBarBrightness: Brightness.light);
    return Scaffold(
      backgroundColor: TeamColor.teamColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Image.asset(
                'assets/white_team_logo.png',
                scale: 0.5,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              height: 200,
              child: ScrollConfiguration(
                behavior: NoGlowEffect(),
                child: ListView(
                  children: [
                    Align(alignment: Alignment.topCenter, child: theWidget),
                  ],
                  padding: EdgeInsets.zero,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

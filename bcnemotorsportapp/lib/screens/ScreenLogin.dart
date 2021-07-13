import 'package:bcnemotorsportapp/Constants.dart';
import 'package:bcnemotorsportapp/screens/ScreenWithLogo.dart';
import 'package:bcnemotorsportapp/models/utilsAndErrors.dart';
import 'package:bcnemotorsportapp/providers/SignInPovider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class ScreenLogin extends StatelessWidget {
  final bool loading;
  const ScreenLogin({@required this.loading});

  @override
  Widget build(BuildContext context) {
    Widget theWidget;
    if (loading) {
      theWidget = CircularProgressIndicator(
        backgroundColor: Colors.white,
      );
    } else {
      theWidget = ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: StadiumBorder(),
          primary: Colors.white,
          onPrimary: TeamColor.teamColor,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            FaIcon(FontAwesomeIcons.google, size: 20),
            SizedBox(width: 10),
            Text("LOGIN"),
          ],
        ),
        onPressed: () async {
          var hasAccess = await Provider.of<SignInProvider>(context, listen: false).login();
          if (!hasAccess) {
            Popup.warningPopup(context,
                title: Phrases.intruderTitle, message: Phrases.intruderMessage);
          }
        },
      );
    }
    return ScreenWithLogo(theWidget);
  }
}

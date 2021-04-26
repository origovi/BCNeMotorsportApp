import 'package:bcnemotorsportapp/providers/SignInPovider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ScreenTeam extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextButton(
        child: Text("Logout"),
        onPressed: () async {
          await Provider.of<SignInProvider>(context, listen: false).logout();
        },
      ),
    );
  }
}

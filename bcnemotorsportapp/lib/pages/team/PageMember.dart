import 'package:bcnemotorsportapp/models/team/Person.dart';
import 'package:bcnemotorsportapp/models/utilsAndErrors.dart';
import 'package:bcnemotorsportapp/providers/CloudDataProvider.dart';
import 'package:bcnemotorsportapp/screens/ScreenMember.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PageMember extends StatelessWidget {
  final Person person;
  final void Function(void Function()) setStateParent;

  const PageMember(this.person, this.setStateParent);

  @override
  Widget build(BuildContext context) {
    changeSystemUi(statusBarBrightness: Brightness.dark, milliDelay: 500);
    return Material(
      child: SafeArea(
        child: ScreenMember(
          person,
          (_){},
          isMe: person.dbId == Provider.of<CloudDataProvider>(context, listen: false).dbUId,
        ),
      ),
    );
  }
}

import 'package:bcnemotorsportapp/Constants.dart';
import 'package:bcnemotorsportapp/models/popupMenu.dart';
import 'package:bcnemotorsportapp/providers/CloudDataProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ScreenTesting extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bool isTeamLeader = Provider.of<CloudDataProvider>(context, listen: false).isTeamLeader;
    return Scaffold(
      appBar: AppBar(
        title: Text("Testing"),
        brightness: Brightness.dark,
      ),
      floatingActionButton: Visibility(
        visible: isTeamLeader,
        child: FloatingActionButton(
          child: Icon(Icons.add),
          backgroundColor: TeamColor.teamColor,
          onPressed: () {},
        ),
      ),
      body: ListView(
        children: [Text("hola")],
      ),
    );
  }
}

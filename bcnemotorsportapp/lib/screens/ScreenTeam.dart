import 'package:bcnemotorsportapp/models/PopupMenu.dart';
import 'package:bcnemotorsportapp/providers/CloudDataProvider.dart';
import 'package:bcnemotorsportapp/providers/SignInPovider.dart';
import 'package:bcnemotorsportapp/services/DatabaseService.dart';
import 'package:bcnemotorsportapp/widgets/SectionCard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ScreenTeam extends StatefulWidget {
  @override
  _ScreenTeamState createState() => _ScreenTeamState();
}

class _ScreenTeamState extends State<ScreenTeam> {
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: NestedScrollView(
        floatHeaderSlivers: true,
        controller: _scrollController,
        headerSliverBuilder: (context, innerBoxScrolled) {
          return [
            SliverAppBar(
                title: Text("Our team"),
                floating: true,
                pinned: true,
                forceElevated: innerBoxScrolled,
                actions: [
                  PopupMenuButton<String>(
                    onSelected: (value) async {
                      int index = TeamScreenPopupMenu.choices.indexOf(value);
                      if (index == 0)
                        print("obrir finestra de config.");
                      else
                        await Provider.of<SignInProvider>(context, listen: false).logout();
                    },
                    itemBuilder: (_) {
                      return TeamScreenPopupMenu.choices
                          .map((String choice) => PopupMenuItem<String>(
                                value: choice,
                                child: Text(choice),
                              ))
                          .toList();
                    },
                  )
                ],
                bottom: TabBar(
                  indicatorColor: Colors.white,
                  tabs: [
                    Tab(
                      icon: Icon(Icons.list),
                    ),
                    Tab(
                      icon: Icon(Icons.account_circle),
                    ),
                  ],
                ))
          ];
        },
        body: TabBarView(
          children: [
            StreamBuilder<QuerySnapshot>(
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text("Error:\n" + snapshot.error.toString()),
                  );
                }
                switch (snapshot.connectionState) {
                  case ConnectionState.active:
                    List<Map<String, dynamic>> teamSnapMap =
                        snapshot.data.docs.map((e) => e.data()).toList();
                    Provider.of<CloudDataProvider>(context, listen: false)
                        .newSectionData(teamSnapMap);
                    return _SectionGrid(teamSnapMap);
                    break;
                  default:
                    return _SectionGrid(
                      Provider.of<CloudDataProvider>(context, listen: false).sectionData,
                    );
                }
              },
              stream: DatabaseService.teamStream(),
            ),
            ListView(
              padding:
                  EdgeInsets.only(top: MediaQuery.of(context).padding.top, right: 10, left: 10),
              children: [
                Container(
                  child: TextButton(
                    child: Text("edede"),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}

class _SectionGrid extends StatelessWidget {
  final List<Map<String, dynamic>> _data;

  _SectionGrid(this._data);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.all(10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: _data.length,
      itemBuilder: (context, index) {
        return SectionCard(_data[index]['name'], _data[index]['about']);
      },
    );
  }
}

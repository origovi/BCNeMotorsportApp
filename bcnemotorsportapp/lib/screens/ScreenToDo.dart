import 'package:bcnemotorsportapp/Constants.dart';
import 'package:bcnemotorsportapp/models/popupMenu.dart';
import 'package:bcnemotorsportapp/providers/CloudDataProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ScreenToDo extends StatefulWidget {
  @override
  _ScreenToDoState createState() => _ScreenToDoState();
}

class _ScreenToDoState extends State<ScreenToDo> with SingleTickerProviderStateMixin {
  TabController _tabController;
  int tabIndex;

  @override
  void initState() {
    super.initState();
    tabIndex = 0;
    _tabController = TabController(initialIndex: 0, length: 2, vsync: this);
    _tabController.addListener(() {
      if (_tabController.index != tabIndex) {
        setState(() {
          tabIndex = _tabController.index;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add), onPressed: () {}, backgroundColor: TeamColor.teamColor),
      body: NestedScrollView(
        floatHeaderSlivers: true,
        headerSliverBuilder: (context, innderBoxScrolled) {
          return [
            SliverAppBar(
              title: Text(tabIndex == 0 ? "My ToDo" : "Section ToDo"),
              brightness: Brightness.dark,
              floating: true,
              pinned: true,
              forceElevated: innderBoxScrolled,
              actions: [
                PopupMenuButton<String>(
                  tooltip: "Sort by",
                  icon: Icon(Icons.sort),
                  onSelected: (_) {},
                  itemBuilder: (_) {
                    return SortToDo.choices
                        .map((String choice) => PopupMenuItem<String>(
                              value: choice,
                              child: Row(
                                children: [
                                  Text(choice),
                                  Spacer(),
                                  Icon(Icons.check, color: Colors.black),
                                ],
                              ),
                            ))
                        .toList();
                  },
                )
              ],
              bottom: TabBar(
                controller: _tabController,
                indicatorColor: Colors.white,
                tabs: [
                  Tab(
                    icon: Icon(Icons.list),
                  ),
                  Tab(
                    icon: Icon(Icons.ac_unit),
                  )
                ],
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            ListView(
              children: [
                Container(
                  height: 5000,
                )
              ],
            ),
            Container(),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}

import 'package:bcnemotorsportapp/Constants.dart';
import 'package:bcnemotorsportapp/models/popupMenu.dart';
import 'package:bcnemotorsportapp/models/toDo/ToDoData.dart';
import 'package:bcnemotorsportapp/providers/CloudDataProvider.dart';
import 'package:bcnemotorsportapp/widgets/toDo/ToDoCard.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ScreenToDo extends StatefulWidget {
  @override
  _ScreenToDoState createState() => _ScreenToDoState();
}

class _ScreenToDoState extends State<ScreenToDo> with SingleTickerProviderStateMixin {
  TabController _tabController;
  int tabIndex;
  String sortState;
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

  void _newToDo(BuildContext context) {
    Navigator.of(context).pushNamed('/toDo/newToDo').then((value) {
      if (value != null) {
        
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ToDoData data = Provider.of<CloudDataProvider>(context, listen: false).toDoAllData;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add_task), onPressed: () => _newToDo(context), backgroundColor: TeamColor.teamColor),
      body: NestedScrollView(
        floatHeaderSlivers: true,
        headerSliverBuilder: (context, innderBoxScrolled) {
          return [
            SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              sliver: SliverSafeArea(
                top: false,
                sliver: SliverAppBar(
                  title: Text(tabIndex == 0 ? "My ToDo" : "Section ToDo"),
                  brightness: Brightness.dark,
                  floating: true,
                  pinned: true,
                  snap: true,
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
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            ListView.builder(
              padding: const EdgeInsets.all(Sizes.sideMargin),
              itemCount: data.myToDos.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 15),
                  child: ToDoCard(data.myToDos[index]),
                );
              },
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

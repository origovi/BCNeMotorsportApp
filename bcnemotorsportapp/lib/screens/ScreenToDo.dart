import 'package:bcnemotorsportapp/Constants.dart';
import 'package:bcnemotorsportapp/models/popupMenu.dart';
import 'package:bcnemotorsportapp/models/toDo/ToDo.dart';
import 'package:bcnemotorsportapp/models/utilsAndErrors.dart';
import 'package:bcnemotorsportapp/providers/CloudDataProvider.dart';
import 'package:bcnemotorsportapp/screens/ScreenMyToDos.dart';
import 'package:bcnemotorsportapp/screens/ScreenSectionsToDo.dart';
import 'package:bcnemotorsportapp/services/MessagingService.dart';
import 'package:bcnemotorsportapp/widgets/toDo/ToDoCard.dart';
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
    Navigator.of(context).pushNamed('/toDo/newToDo').then((value) async {
      if (value != null) {
        final provider = Provider.of<CloudDataProvider>(context, listen: false);
        List<dynamic> res = List<dynamic>.from(value);
        ToDo newToDo = res[0];
        Popup.loadingPopup(context);
        await provider.newToDo(newToDo);
        if (res[1]) {
          List<String> fcmTokensToNotify = List<String>.from(res[2]);
          // the fcmToken of someone may be empty
          fcmTokensToNotify.removeWhere((element) => element == null);
          if (fcmTokensToNotify.isNotEmpty)
            MessagingService.postNotification(
              context,
              title: "You have a new ToDo, created by: ${provider.user.completeName}",
              body: newToDo.name,
              destTokens: fcmTokensToNotify,
            );
        }
        Navigator.of(context).pop();
        snackDatabaseUpdated(context);
      }
    });
  }

  List<ToDo> _sortToDos(List<ToDo> initialData) {
    switch (sortState) {
      case SortToDo.mImportantFirst:
        initialData.sort((t1, t2) {
          return t1.importanceLevel.compareTo(t2.importanceLevel);
        });
        break;
      case SortToDo.lImportantFirst:
        initialData.sort((t1, t2) {
          return t2.importanceLevel.compareTo(t1.importanceLevel);
        });
        break;
      case SortToDo.newest:
        initialData.sort((t1, t2) {
          if (t1.whenAdded.isBefore(t2.whenAdded))
            return 1;
          else
            return -1;
        });
        break;
      case SortToDo.oldest:
        initialData.sort((t1, t2) {
          if (t1.whenAdded.isBefore(t2.whenAdded))
            return -1;
          else
            return 1;
        });
        break;
      case SortToDo.deadlineCloser:
        initialData.sort((t1, t2) {
          if (!t1.hasDeadline && !t2.hasDeadline) return 0;
          if (t1.hasDeadline && !t2.hasDeadline)
            return -1;
          else if (!t1.hasDeadline && t2.hasDeadline)
            return 1;
          else if (t1.deadline.isBefore(t2.deadline))
            return -1;
          else
            return 1;
        });
        break;
      case SortToDo.deadlineFurther:
        initialData.sort((t1, t2) {
          if (!t1.hasDeadline && !t2.hasDeadline) return 0;
          if (t1.hasDeadline && !t2.hasDeadline)
            return -1;
          else if (!t1.hasDeadline && t2.hasDeadline)
            return 1;
          else if (t1.deadline.isBefore(t2.deadline))
            return 1;
          else
            return -1;
        });
        break;
    }
    return initialData;
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CloudDataProvider>(context, listen: false);
    List<ToDo> myToDosSorted =
        _sortToDos(provider.toDoData.myToDos);
    List<ToDo> sectionToDosExcMineSorted = _sortToDos(provider.toDoData.sectionToDosExcMine);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add_task),
          onPressed: () => _newToDo(context),
          backgroundColor: TeamColor.teamColor),
      body: NestedScrollView(
        floatHeaderSlivers: true,
        headerSliverBuilder: (context, innerBoxScrolled) {
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
                  forceElevated: innerBoxScrolled,
                  actions: [
                    PopupMenuButton<String>(
                      tooltip: "Sort by",
                      icon: Icon(Icons.sort),
                      onSelected: (selectedValue) {
                        setState(() {
                          sortState = selectedValue;
                        });
                      },
                      itemBuilder: (_) {
                        return SortToDo.choices
                            .map((String choice) => PopupMenuItem<String>(
                                  value: choice,
                                  child: Row(
                                    children: [
                                      Text(choice),
                                      Spacer(),
                                      if (sortState == choice)
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
                        icon: Icon(Icons.checklist_outlined),
                      ),
                      Tab(
                        icon: Icon(Icons.group),
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
            ScreenMyToDos(myToDosSorted),
            ScreenSectionsToDo(sectionToDosExcMineSorted),
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

import 'package:bcnemotorsportapp/models/popupMenu.dart';
import 'package:bcnemotorsportapp/models/team/Person.dart';
import 'package:bcnemotorsportapp/models/utilsAndErrors.dart';
import 'package:bcnemotorsportapp/providers/CloudDataProvider.dart';
import 'package:bcnemotorsportapp/providers/SignInPovider.dart';
import 'package:bcnemotorsportapp/screens/ScreenMe.dart';
import 'package:bcnemotorsportapp/services/DatabaseService.dart';
import 'package:bcnemotorsportapp/widgets/Buttons.dart';
import 'package:bcnemotorsportapp/widgets/team/SectionGrid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ScreenTeam extends StatefulWidget {
  @override
  _ScreenTeamState createState() => _ScreenTeamState();
}

class _ScreenTeamState extends State<ScreenTeam> {
  ScrollController _scrollController;
  TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _textController = TextEditingController();
  }

  void _editTeam({@required bool access}) {
    final provider = Provider.of<CloudDataProvider>(context, listen: false);
    String selfDbId = provider.dbUId;

    List<Person> allUserList = List<Person>.from(provider.personList);
    List<Person> addList = [];

    _textController.clear();

    Future<void> saveChanges() async {
      Popup.loadingPopup(context);

      final List<Person> originalList = provider.personList;
      List<Person> removeList = [];

      originalList.forEach((element) {
        if (!allUserList.contains(element)) removeList.add(element);
      });

      await provider.updateAppAccess(addList, removeList);

      snackDatabaseUpdated(context);

      setState(() {
        Navigator.of(context).pop();
      });
    }

    Popup.fancyPopup(
      context: context,
      barrierDismissible: false,
      children: [
        StatefulBuilder(builder: (contextBuilder, setStateBuilder) {
          void newMember() {
            Navigator.of(context).pushNamed("/team/newMember").then((value) {
              if (value != null) {
                setStateBuilder(() {
                  addList.add(value);
                });
              }
            });
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "  Team Members:",
                style: TextStyle(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              Divider(thickness: 1.5),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 7),
                height: 250,
                child: ListView.separated(
                  separatorBuilder: (context, personIndex) {
                    return Divider(
                      thickness: 1,
                    );
                  },
                  itemCount: allUserList.length + addList.length,
                  itemBuilder: (context, personIndex) {
                    if (personIndex < allUserList.length) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(allUserList[personIndex].email),
                              Text(
                                allUserList[personIndex].completeName,
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                          IconButton(
                            tooltip: allUserList[personIndex].dbId != selfDbId
                                ? "Remove this member"
                                : "You cannot remove yourself",
                            iconSize: 20,
                            icon: Icon(Icons.clear),
                            onPressed: allUserList[personIndex].dbId != selfDbId
                                ? () {
                                    Popup.twoOptionsPopup(
                                      context,
                                      message:
                                          "${allUserList[personIndex].completeName} will NO LONGER BE a member of the team. All data related to him WILL BE DELETED. Changes need to be saved after.",
                                      text1: "Bye bye",
                                      color1: Colors.red,
                                      onPressed1: () {
                                        setStateBuilder(
                                            () => allUserList.removeAt(personIndex));
                                        Navigator.of(context).pop();
                                      },
                                    );
                                  }
                                : null,
                          ),
                        ],
                      );
                    } else {
                      personIndex -= allUserList.length;
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(addList[personIndex].email,
                                  style: TextStyle(fontWeight: FontWeight.bold)),
                              Text(
                                addList[personIndex].completeName,
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                          IconButton(
                            tooltip: "Remove this member",
                            iconSize: 15,
                            icon: Icon(Icons.clear),
                            onPressed: () {
                              setStateBuilder(() => addList.removeAt(personIndex));
                            },
                          ),
                        ],
                      );
                    }
                  },
                ),
              ),
              Divider(thickness: 1.5),
              // TEXT INPUT
              Center(child: FlatIconButton(onPressed: newMember)),
              // BOTTOM BUTTONS
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                    onPressed: () async {
                      Navigator.of(context).pop();
                      await saveChanges();
                    },
                    child: Text(
                      "Save",
                    ),
                  ),
                  TextButton(
                    onPressed: Navigator.of(context).pop,
                    child: Text(
                      "Cancel",
                      style: TextStyle(color: Colors.grey[800]),
                    ),
                  ),
                ],
              ),
            ],
          );
        }),
      ],
    );
  }

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
                brightness: Brightness.dark,
                title: Text("Our team"),
                floating: true,
                pinned: true,
                forceElevated: innerBoxScrolled,
                actions: [
                  Visibility(
                    visible: Provider.of<CloudDataProvider>(context, listen: false).isTeamLeader,
                    child: PopupMenuButton<String>(
                      tooltip: "Manage Team",
                      icon: Icon(Icons.edit),
                      onSelected: (value) async {
                        if (value == TeamScreenEdit.manageAccess)
                          _editTeam(access: true);
                        else if (value == TeamScreenEdit.manageSections) print("manage sections");
                      },
                      itemBuilder: (_) {
                        return TeamScreenEdit.choices
                            .map((String choice) => PopupMenuItem<String>(
                                  value: choice,
                                  child: Text(choice),
                                ))
                            .toList();
                      },
                    ),
                  ),
                  PopupMenuButton<String>(
                    onSelected: (value) async {
                      if (value == TeamScreenPopupMenu.config)
                        print("obrir finestra de config.");
                      else if (value == TeamScreenPopupMenu.logout)
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
                  ),
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
            ListView(
              padding: const EdgeInsets.all(10),
              children: [
                SectionGrid(
                  data: Provider.of<CloudDataProvider>(context, listen: false).sectionsData,
                  shrinkWrap: true,
                ),
              ],
            ),
            ScreenMe(Provider.of<CloudDataProvider>(context, listen: false).user, setState),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _textController.dispose();
    super.dispose();
  }
}

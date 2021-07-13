import 'package:bcnemotorsportapp/models/team/Person.dart';
import 'package:bcnemotorsportapp/models/team/Section.dart';
import 'package:bcnemotorsportapp/models/utilsAndErrors.dart';
import 'package:bcnemotorsportapp/providers/CloudDataProvider.dart';
import 'package:bcnemotorsportapp/widgets/Buttons.dart';
import 'package:bcnemotorsportapp/widgets/team/MemberTile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PageSection extends StatefulWidget {
  final Section _data;

  PageSection(this._data);

  @override
  _PageSectionState createState() => _PageSectionState();
}

class _PageSectionState extends State<PageSection> {
  List<Person> _onlyMembers;
  List<Person> _chiefs;
  bool _amIChief;
  bool _amITeamLeader;

  bool _hasAbout;
  bool _aboutCanSaveAgain;
  TextEditingController _noteController;
  FocusNode _aboutFocus;
  String _newTempAbout;

  TextEditingController _newMemberController;

  @override
  void initState() {
    super.initState();
    _onlyMembers = [];
    _chiefs = [];
    _amIChief = widget._data.isChief(Provider.of<CloudDataProvider>(context, listen: false).dbUId);
    _amITeamLeader = Provider.of<CloudDataProvider>(context, listen: false).isTeamLeader;
    final cloudDataProvider = Provider.of<CloudDataProvider>(context, listen: false);
    // we fill up the _members list
    widget._data.onlyMemberIds
        .forEach((element) => _onlyMembers.add(cloudDataProvider.personById(element)));
    // we fill up the _chiefs list
    widget._data.chiefIds.forEach((element) => _chiefs.add(cloudDataProvider.personById(element)));

    _hasAbout = widget._data.hasAbout;
    _aboutCanSaveAgain = true;
    if (_hasAbout)
      _noteController = TextEditingController.fromValue(TextEditingValue(text: widget._data.about));
    else
      _noteController = TextEditingController();
    _aboutFocus = FocusNode();

    _newMemberController = TextEditingController();
  }

  Future<void> _saveAbout() async {
    await Future.delayed(Duration(seconds: 3));
    await Provider.of<CloudDataProvider>(context, listen: false)
        .updateSectionAbout(widget._data.sectionId, _newTempAbout);
    //snackDatabaseUpdated(context);
    _aboutCanSaveAgain = true;
  }

  void _editMembers(bool chief) {
    List<Person> referenceList;
    if (chief)
      referenceList = _chiefs;
    else
      referenceList = _onlyMembers;

    List<Person> newOnlyMembers = List<Person>.from(referenceList);

    List<Person> possiblePersonList = [];
    _newMemberController.clear();

    Future<void> saveChanges() async {
      Popup.loadingPopup(context);

      List<String> addList = [];
      List<String> removeList = [];

      for (Person person in newOnlyMembers) {
        if (!referenceList.contains(person)) {
          addList.add(person.dbId);
          // necessary to update page
          referenceList.add(person);
          // removes person from onlymember if it has been added to chief
          if (chief) _onlyMembers.remove(person);
        }
      }

      for (Person person in referenceList) {
        if (!newOnlyMembers.contains(person)) removeList.add(person.dbId);
      }

      // necessary to update page
      removeList.forEach(
        (elementRem) => referenceList.removeWhere((elementRef) {
          if (elementRem == elementRef.dbId) {
            if (chief) _onlyMembers.add(elementRef);
            return true;
          } else
            return false;
        }),
      );

      if (addList.isNotEmpty || removeList.isNotEmpty) {
        await Provider.of<CloudDataProvider>(context, listen: false).updateSectionMembers(
            sectionId: widget._data.sectionId, add: addList, remove: removeList, chief: chief);
        snackDatabaseUpdated(context);
      }
      setState(() {
        Navigator.of(context).pop();
      });
    }

    void updatePossiblePersonList(String text, void Function(void Function()) setStateBuilder) {
      List<Person> excludeList = List<Person>.from(newOnlyMembers);
      if (!chief) excludeList.addAll(_chiefs);
      setStateBuilder(() {
        possiblePersonList = Provider.of<CloudDataProvider>(context, listen: false)
            .personsThatCoincideCompleteName(text, exclude: excludeList);
      });
    }

    Popup.fancyPopup(
      context: context,
      barrierDismissible: false,
      children: [
        StatefulBuilder(builder: (contextBuilder, setStateBuilder) {
          return Stack(
            children: [
              Column(
                children: [
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      chief ? "  Chiefs:" : "  Members:",
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  Divider(thickness: 1.5),
                  Visibility(
                    visible: newOnlyMembers.isNotEmpty,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 7),
                      height: 200,
                      child: ListView.separated(
                        separatorBuilder: (context, personIndex) {
                          return Divider(
                            thickness: 1,
                          );
                        },
                        itemCount: newOnlyMembers.length,
                        itemBuilder: (context, personIndex) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(newOnlyMembers[personIndex].completeName),
                                  Text(
                                    newOnlyMembers[personIndex].email,
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontStyle: FontStyle.italic,
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                              IconButton(
                                iconSize: 20,
                                icon: Icon(Icons.clear),
                                onPressed: () {
                                  Popup.twoOptionsPopup(
                                    context,
                                    message:
                                        "${newOnlyMembers[personIndex].name} will no longer be ${chief ? "chief" : "a member"} of ${widget._data.name}. Changes need to be saved after.",
                                    text1: "Bye bye",
                                    color1: Colors.red,
                                    onPressed1: () {
                                      setStateBuilder(() => newOnlyMembers.removeAt(personIndex));
                                      Navigator.of(context).pop();
                                    },
                                  );
                                },
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                  // TEXT TO SHOW WHEN NO MEMBERS
                  Visibility(
                    visible: newOnlyMembers.isEmpty,
                    child: Container(
                      height: 200,
                      padding: EdgeInsets.symmetric(horizontal: 7),
                      child: Center(
                        child: Text(
                          (referenceList.isNotEmpty)
                              ? "All users removed! Click save to apply changes"
                              : "Add somebody as a member",
                          style: TextStyle(color: Colors.grey[500], fontSize: 12),
                        ),
                      ),
                    ),
                  ),
                  // TEXT INPUT
                  TextField(
                    controller: _newMemberController,
                    keyboardType: TextInputType.name,
                    textCapitalization: TextCapitalization.words,
                    onChanged: (value) => updatePossiblePersonList(value.trim(), setStateBuilder),
                    decoration: InputDecoration(
                      hintText: "Person name",
                      hintStyle: TextStyle(fontSize: 12),
                      isDense: true,
                      filled: true,
                    ),
                  ),
                  SizedBox(height: 10),
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
              ),
              // SEARCH PERSONS BOX
              Positioned(
                bottom: 100,
                child: Visibility(
                  visible: _newMemberController.text.isNotEmpty && possiblePersonList.isNotEmpty,
                  child: Container(
                    width: 250,
                    height: 100,
                    child: Card(
                      elevation: 5,
                      child: ListView.builder(
                        reverse: true,
                        itemCount: possiblePersonList.length,
                        itemBuilder: (context, possiblePersonIndex) {
                          return InkWell(
                            onTap: () {
                              setStateBuilder(() {
                                newOnlyMembers.add(possiblePersonList[possiblePersonIndex]);
                                _newMemberController.clear();
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(possiblePersonList[possiblePersonIndex].completeName),
                                  Text(
                                    possiblePersonList[possiblePersonIndex].email,
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontStyle: FontStyle.italic,
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        }),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget._data.name),
        brightness: Brightness.dark,
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 8),
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                // ABOUT, NOT VISIBLE IF EMPTY OR NOT SET
                Visibility(
                  visible: _hasAbout,
                  child: Material(
                    borderRadius: BorderRadius.circular(5),
                    elevation: 5.0,
                    child: TextField(
                      readOnly: !_amIChief && !_amITeamLeader,
                      controller: _noteController,
                      focusNode: _aboutFocus,
                      onChanged: (text) {
                        _newTempAbout = text.trim();
                        if (_aboutCanSaveAgain) {
                          _aboutCanSaveAgain = false;
                          _saveAbout();
                        }
                      },
                      keyboardType: TextInputType.multiline,
                      textCapitalization: TextCapitalization.sentences,
                      minLines: 3,
                      maxLines: null,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(
                            width: 0.0,
                            style: BorderStyle.none,
                          ),
                        ),
                        filled: true,
                        hintText: "What do you do in your section?",
                      ),
                    ),
                  ),
                ),
                // ADD ABOUT, NOT VISIBLE IF NOT CHIEF
                Visibility(
                  visible: !_hasAbout && (_amIChief || _amITeamLeader),
                  child: Center(
                    child: FlatIconButton(
                      text: "Add About",
                      onPressed: () {
                        setState(() {
                          _aboutFocus.requestFocus();
                          _hasAbout = true;
                        });
                      },
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 30, left: 3, right: 3),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "CHIEF" + ((widget._data.numChiefs > 1) ? "S" : ""),
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                          Visibility(
                            visible: _amITeamLeader,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(7),
                              onTap: () => _editMembers(true),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 7),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Icon(
                                      Icons.edit,
                                      size: 15,
                                      color: Colors.grey[600],
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      "Manage Chiefs",
                                      style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: List.generate(
                        _chiefs.length,
                        (index) {
                          return MemberTile(
                              person: _chiefs[index], sectionId: widget._data.sectionId);
                        },
                      ),
                    ),
                    Visibility(
                      visible: _chiefs.isEmpty,
                      child: Container(
                        height: 100,
                        child: Center(
                          child: Text(
                            "The section is uncommanded, don't burn it down, please.",
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 30, left: 3, right: 3),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "MEMBERS",
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                          Visibility(
                            visible: _amIChief || _amITeamLeader,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(7),
                              onTap: () => _editMembers(false),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 7),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Icon(
                                      Icons.edit,
                                      size: 15,
                                      color: Colors.grey[600],
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      "Manage Members",
                                      style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: List.generate(
                        _onlyMembers.length,
                        (index) {
                          return MemberTile(
                              person: _onlyMembers[index], sectionId: widget._data.sectionId);
                        },
                      ),
                    ),
                    Visibility(
                      visible: _onlyMembers.isEmpty,
                      child: Container(
                        height: 100,
                        child: Center(
                          child: Text(
                            "Nobody is in here...",
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _noteController.dispose();
    _aboutFocus.dispose();
    _newMemberController.dispose();
    super.dispose();
  }
}

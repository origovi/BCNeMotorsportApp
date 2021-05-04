import 'package:bcnemotorsportapp/models/team/Person.dart';
import 'package:bcnemotorsportapp/models/team/Section.dart';
import 'package:bcnemotorsportapp/models/utilsAndErrors.dart';
import 'package:bcnemotorsportapp/providers/CloudDataProvider.dart';
import 'package:bcnemotorsportapp/providers/SignInPovider.dart';
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
  List<Person> _members;
  List<Person> _chiefs;
  bool _amIChief;

  bool _hasAbout;
  bool _aboutCanSaveAgain;
  TextEditingController _noteController;
  FocusNode _aboutFocus;
  String _newTempAbout;

  @override
  void initState() {
    super.initState();
    _members = [];
    _chiefs = [];
    _amIChief = widget._data.isChief(Provider.of<CloudDataProvider>(context, listen: false).dbUId);
    final cloudDataProvider = Provider.of<CloudDataProvider>(context, listen: false);
    // we fill up the _members list
    widget._data.memberIds
        .forEach((element) => _members.add(cloudDataProvider.personById(element)));
    // we fill up the _chiefs list
    widget._data.chiefIds.forEach((element) => _chiefs.add(cloudDataProvider.personById(element)));

    _hasAbout = widget._data.hasAbout;
    _aboutCanSaveAgain = true;
    if (_hasAbout)
      _noteController = TextEditingController.fromValue(TextEditingValue(text: widget._data.about));
    else
      _noteController = TextEditingController();
    _aboutFocus = FocusNode();
  }

  Future<void> _saveAbout() async {
    await Future.delayed(Duration(seconds: 3));
    await Provider.of<CloudDataProvider>(context, listen: false)
        .updateSectionAbout(widget._data.sectionId, _newTempAbout);
    //snackDatabaseUpdated(context);
    _aboutCanSaveAgain = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget._data.name)),
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
                      readOnly: !_amIChief,
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
                  visible: !_hasAbout && _amIChief,
                  child: Center(
                    child: FlatButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.add),
                          Text(" Add description"),
                        ],
                      ),
                      onPressed: () {
                        setState(() {
                          _aboutFocus.requestFocus();
                          _hasAbout = true;
                        });
                      },
                    ),
                  ),
                ),
                // IF SOMEBODY IS IN HERE
                _members.length > 0
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 30, left: 3),
                            child: widget._data.numChiefs > 0
                                ? Text(
                                    "CHIEF" + ((widget._data.numChiefs > 1) ? "S" : ""),
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  )
                                : Center(
                                    child: Text(
                                      "The section is uncommanded, don't burn it down, please",
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                          ),
                          Column(
                            children: List.generate(
                              _chiefs.length,
                              (index) {
                                return MemberTile(
                                    _chiefs[index], _chiefs[index].role(widget._data.sectionId));
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 30, left: 3),
                            child: Text(
                              "MEMBERS",
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          Column(
                            children: List.generate(
                              _members.length,
                              (index) {
                                if (!widget._data.isChief(_members[index].dbId))
                                  return MemberTile(_members[index],
                                      _members[index].role(widget._data.sectionId));
                                else
                                  return SizedBox(width: 0, height: 0);
                              },
                            ),
                          ),
                        ],
                      )
                    // WHAT HAPPENS WHEN NOBODY IS IN HERE
                    : Padding(
                        padding: const EdgeInsets.only(top: 30, left: 3),
                        child: Center(
                          child: Text(
                            "This is what I would call a phantom section, maybe more productive than others...",
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
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
    super.dispose();
  }
}

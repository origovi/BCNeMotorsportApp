import 'package:bcnemotorsportapp/models/team/Person.dart';
import 'package:bcnemotorsportapp/models/team/Section.dart';
import 'package:bcnemotorsportapp/providers/CloudDataProvider.dart';
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
  @override
  void initState() {
    _members = [];
    _chiefs = [];
    final provider = Provider.of<CloudDataProvider>(context, listen: false);
    // we fill up the _members list
    widget._data.memberIds.forEach((element) => _members.add(provider.personById(element)));
    // we fill up the _chiefs list
    widget._data.chiefIds.forEach((element) => _chiefs.add(provider.personById(element)));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget._data.name)),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 8),
          children: [
            Center(child: Text(widget._data.about)),
            Padding(
              padding: const EdgeInsets.only(top: 30, left: 3),
              child: Text(
                "CHIEF" + ((widget._data.numChiefs > 1) ? "S" : ""),
                style: TextStyle(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
            Column(
              children: List.generate(
                _chiefs.length,
                (index) {
                    return MemberTile(_chiefs[index], _chiefs[index].role(widget._data.sectionId));
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
                  if(!widget._data.isChief(_members[index].dbId)) return MemberTile(_members[index], _members[index].role(widget._data.sectionId));
                  else return SizedBox(width: 0, height: 0);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

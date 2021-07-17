import 'package:bcnemotorsportapp/Constants.dart';
import 'package:bcnemotorsportapp/models/team/Section.dart';
import 'package:bcnemotorsportapp/models/toDo/ToDo.dart';
import 'package:bcnemotorsportapp/providers/CloudDataProvider.dart';
import 'package:bcnemotorsportapp/widgets/toDo/SectionToDo.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ScreenSectionsToDo extends StatelessWidget {
  final List<ToDo> data;
  const ScreenSectionsToDo(this.data);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CloudDataProvider>(context, listen: false);
    List<Section> userSections = provider.userSections;
    return Visibility(
      visible: userSections.isNotEmpty,
      child: ListView.builder(
        padding: EdgeInsets.only(top: Sizes.sideMargin),
        itemCount: userSections.length,
        itemBuilder: (context, index) {
          return SectionToDo(
            sectionName: userSections[index].name,
            // tots els toDos que tenen com a minim una persona com a membre de userSections[index]
            sectionToDos: data
                .where((toDo) => toDo.personIds.any((personId) => (personId != provider.dbUId &&
                    userSections[index].memberIds.contains(personId))))
                .toList(),
          );
        },
      ),
      replacement: Center(
        child: Text(
          "No ToDos to show here. WTF you are not a member of any section?",
          style: TextStyle(
            color: Colors.grey[600],
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}

import 'package:bcnemotorsportapp/Constants.dart';
import 'package:bcnemotorsportapp/models/toDo/ToDo.dart';
import 'package:bcnemotorsportapp/providers/CloudDataProvider.dart';
import 'package:bcnemotorsportapp/widgets/toDo/PersonToDo.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SectionToDo extends StatelessWidget {
  final String sectionName;
  final List<ToDo> sectionToDos;

  const SectionToDo({@required this.sectionName, @required this.sectionToDos});

  List<PersonToDo> buildPersonToDos(BuildContext context) {
    final provider = Provider.of<CloudDataProvider>(context, listen: false);
    List<PersonToDo> res = [];
    // set to remove repeated
    Set<String> differentPersons = {};
    sectionToDos.forEach((element) {
      differentPersons.addAll(element.personIds);
    });
    // remove the user as we dont want users todos
    differentPersons.remove(provider.dbUId);
    differentPersons.forEach((differentPerson) {
      List<ToDo> personToDos = [];
      sectionToDos.forEach((sectionToDo) {
        if (sectionToDo.personIds.contains(differentPerson)) {
          personToDos.add(sectionToDo);
        }
      });
      String personName = provider.personById(differentPerson).completeName;
      res.add(PersonToDo(personName, personToDos));
    });
    res.sort((pt1, pt2)=> pt1.personName.compareTo(pt2.personName));
    return res;
  }

  @override
  Widget build(BuildContext context) {
    List<PersonToDo> personToDos = buildPersonToDos(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Sizes.sideMargin),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      " $sectionName:",
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Divider(thickness: 1.5),
                  SizedBox(height: 10),
                ],
              ),
            ),
          ] +
          personToDos,
    );
  }
}

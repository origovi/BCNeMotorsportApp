import 'package:bcnemotorsportapp/models/team/Person.dart';
import 'package:bcnemotorsportapp/models/toDo/ToDo.dart';
import 'package:bcnemotorsportapp/providers/CloudDataProvider.dart';
import 'package:bcnemotorsportapp/widgets/NiceBox.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ToDoCard extends StatefulWidget {
  final ToDo toDo;

  const ToDoCard(this.toDo);
  @override
  _ToDoCardState createState() => _ToDoCardState();
}

class _ToDoCardState extends State<ToDoCard> {
  List<Person> personList;
  @override
  void initState() {
    super.initState();
    personList = widget.toDo.personIds.map((e) => Provider.of<CloudDataProvider>(context, listen: false).personById(e)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return NiceBox(
      child: Column(
        children: [
          Text(widget.toDo.name),
          Text(widget.toDo.description),
          Column(children: List.generate(personList.length, (index) => Text(personList[index].completeName)),)
        ],
      ),
    );
  }
}
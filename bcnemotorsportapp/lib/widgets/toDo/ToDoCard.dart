import 'dart:async';

import 'package:bcnemotorsportapp/models/team/Person.dart';
import 'package:bcnemotorsportapp/models/toDo/ToDo.dart';
import 'package:bcnemotorsportapp/models/utilsAndErrors.dart';
import 'package:bcnemotorsportapp/providers/CloudDataProvider.dart';
import 'package:bcnemotorsportapp/widgets/NiceBox.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ToDoCard extends StatefulWidget {
  final ToDo toDo;
  final double height;
  final double width;

  const ToDoCard(this.toDo, {this.height = 120, this.width});
  @override
  _ToDoCardState createState() => _ToDoCardState();
}

class _ToDoCardState extends State<ToDoCard> {
  List<Person> personList;
  Timer reloadTimer;
  @override
  void initState() {
    super.initState();
    personList = widget.toDo.personIds
        .map((e) => Provider.of<CloudDataProvider>(context, listen: false).personById(e))
        .toList();
    // timer to rebuild the widget every 5 seconds to update toDo progress
    reloadTimer = Timer.periodic(Duration(seconds: 5), (timer) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: widget.width,
      child: NiceBox(
        progress: widget.toDo.deadlineProgress,
        progressColor: widget.toDo.deadlineProgressColor,
        onTap: () {},
        radius: 25,
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        color: widget.toDo.color,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  formatDate(widget.toDo.whenAdded, short: true, yearWhenNecessary: true),
                  style: TextStyle(fontSize: 11),
                ),
                Text(
                  widget.toDo.hasDeadline
                      ? "Deadline is ${formatDate(widget.toDo.deadline, short: true, yearWhenNecessary: true)}"
                      : "",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
                ),
              ],
            ),
            Text(
              widget.toDo.name,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
              Text(
                widget.toDo.hasDescription ? widget.toDo.description : "",
                style: TextStyle(fontStyle: FontStyle.italic),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            Text(
              personList.map((e) => e.completeName).join(", "),
              style: TextStyle(fontWeight: FontWeight.w500),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    reloadTimer.cancel();
    super.dispose();
  }
}

import 'package:bcnemotorsportapp/Constants.dart';
import 'package:bcnemotorsportapp/models/toDo/ToDo.dart';
import 'package:bcnemotorsportapp/widgets/toDo/ToDoWidget.dart';
import 'package:flutter/material.dart';
import 'package:sliver_tools/sliver_tools.dart';

class ToDoSection extends StatelessWidget {
  final String sectionTitle;
  final List<ToDo> toDoDataList;

  const ToDoSection(this.sectionTitle, this.toDoDataList);

  @override
  Widget build(BuildContext context) {
    return MultiSliver(
      pushPinnedChildren: true,
      children: [
        FloatingSeparator(sectionTitle),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, i) {
              return ToDoWidget();
            },
            childCount: 10,
          ),
        ),
      ],
    );
  }
}

class FloatingSeparator extends StatelessWidget {
  final String text;

  const FloatingSeparator(this.text);

  @override
  Widget build(BuildContext context) {
    return SliverPinnedHeader(
      child: Container(
        height: MediaQuery.of(context).padding.top,
        color: TeamColor.teamColor,
        child: Center(child: Text(text ?? "", style: TextStyle(color: Colors.white))),
      ),
    );
  }
}

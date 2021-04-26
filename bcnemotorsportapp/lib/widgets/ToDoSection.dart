import 'package:bcnemotorsportapp/Constants.dart';
import 'package:bcnemotorsportapp/models/ToDoData.dart';
import 'package:bcnemotorsportapp/widgets/ToDo.dart';
import 'package:flutter/material.dart';
import 'package:sliver_tools/sliver_tools.dart';

class ToDoSection extends StatelessWidget {
  final String sectionTitle;
  final List<ToDoData> toDoDataList;

  ToDoSection(this.sectionTitle, this.toDoDataList);

  @override
  Widget build(BuildContext context) {
    return MultiSliver(
      pushPinnedChildren: true,
      children: [
        FloatingSeparator(sectionTitle),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, i) {
              return ToDo();
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

  FloatingSeparator(this.text);

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

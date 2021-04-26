import 'package:bcnemotorsportapp/providers/CloudDataProvider.dart';
import 'package:bcnemotorsportapp/widgets/ToDoSection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ScreenToDo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final toDoData = Provider.of<CloudDataProvider>(context).getToDoData();
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          title: Text("AVUI ES DIA DE TREBALL"),
        ),
        // necessary to avoid the other
        FloatingSeparator(null),
        ToDoSection("hola", []),
        ToDoSection("adeu", []),
      ],
    );
  }
}

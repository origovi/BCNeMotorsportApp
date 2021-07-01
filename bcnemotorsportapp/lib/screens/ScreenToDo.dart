import 'package:bcnemotorsportapp/models/PopupMenu.dart';
import 'package:bcnemotorsportapp/providers/CloudDataProvider.dart';
import 'package:bcnemotorsportapp/widgets/toDo/ToDoSection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ScreenToDo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final toDoData = Provider.of<CloudDataProvider>(context, listen: false).getToDoData();
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          brightness: Brightness.dark,
          title: Text("AVUI ES DIA DE TREBALL"),
          actions: [
            PopupMenuButton<String>(
              tooltip: "Sort by",
              icon: Icon(Icons.sort),
              onSelected: (_){},
              itemBuilder: (_) {
                return SortToDo.choices
                    .map((String choice) => PopupMenuItem<String>(
                          value: choice,
                          child: Row(
                            children: [
                              Text(choice),
                              Spacer(),
                              Icon(Icons.check, color: Colors.black),
                            ],
                          ),
                        ))
                    .toList();
              },
            ),
          ],
        ),
        // necessary to avoid the other
        FloatingSeparator(null),
        ToDoSection("hola", []),
        ToDoSection("adeu", []),
      ],
    );
  }
}
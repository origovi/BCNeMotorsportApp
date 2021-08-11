import 'package:bcnemotorsportapp/Constants.dart';
import 'package:bcnemotorsportapp/models/toDo/ToDo.dart';
import 'package:bcnemotorsportapp/widgets/toDo/ToDoCard.dart';
import 'package:flutter/material.dart';

class ScreenMyToDos extends StatelessWidget {
  final List<ToDo> data;

  const ScreenMyToDos(this.data);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: data.isNotEmpty,
      child: ListView.builder(
        padding: const EdgeInsets.all(Sizes.sideMargin),
        itemCount: data.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(bottom: 15),
            child: ToDoCard(data[index]),
          );
        },
      ),
      replacement: Center(
        child: Text(
          "You have no ToDos here. I won't tell anybody.",
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

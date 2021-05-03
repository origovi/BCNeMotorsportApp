import 'package:flutter/material.dart';

class ToDo extends StatefulWidget {
  @override
  _ToDoState createState() => _ToDoState();
}

class _ToDoState extends State<ToDo> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 150 ,
          color: Colors.red[300],
        ),
        Container(
          width: 50,
          height: 10,
          color: Colors.blue[300],
        ),
      ],
    );
  }
}
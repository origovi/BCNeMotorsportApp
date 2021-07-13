import 'package:flutter/material.dart';

class ToDoWidget extends StatefulWidget {
  @override
  _ToDoWidgetState createState() => _ToDoWidgetState();
}

class _ToDoWidgetState extends State<ToDoWidget> {
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
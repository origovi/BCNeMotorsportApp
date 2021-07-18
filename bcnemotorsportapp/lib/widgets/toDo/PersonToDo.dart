import 'package:bcnemotorsportapp/Constants.dart';
import 'package:bcnemotorsportapp/models/toDo/ToDo.dart';
import 'package:bcnemotorsportapp/widgets/toDo/ToDoCard.dart';
import 'package:flutter/material.dart';

class PersonToDo extends StatelessWidget {
  final String personName;
  final List<ToDo> toDos;
  const PersonToDo(this.personName, this.toDos);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: Sizes.sideMargin * 2),
          child: Text(personName),
        ),
        SizedBox(
          height: 150,
          child: ListView.separated(
            itemCount: toDos.length,
            //physics: ClampingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            separatorBuilder: (context, index) {
              return SizedBox(width: 0);
            },
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: Sizes.sideMargin),
                child: ToDoCard(toDos[index], width: 315),
              );
            },
          ),
        ),
        SizedBox(height: 15),
      ],
    );
  }
}

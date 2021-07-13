import 'dart:ui';

import 'package:bcnemotorsportapp/Constants.dart';
import 'package:flutter/material.dart';

class FlatIconButton extends StatelessWidget {
  final void Function() onPressed;
  final String text;
  final Widget icon;
  final bool border;

  const FlatIconButton({@required this.onPressed, this.text = "Add", this.icon = const Icon(Icons.add), this.border = false});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        primary: Colors.black,
        side: border ? BorderSide(color: Colors.black) : null,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            this.icon,
            Text(" ${this.text}"),
          ],
        ),
      ),
      onPressed: onPressed,
    );
  }
}

class ElevatedTextButton extends StatelessWidget {
  final void Function() onTap;
  final String text;
  final bool isTeamColor;

  const ElevatedTextButton({@required this.onTap, this.text = "Add", this.isTeamColor = true});

  @override
  Widget build(BuildContext context) {
    return Ink(
      decoration: BoxDecoration(
        color: this.isTeamColor ? TeamColor.teamColor : Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.6),
            spreadRadius: 5,
            blurRadius: 15,
          )
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(30),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 40),
          child: Text(
            "Save",
            style: TextStyle(
              color: this.isTeamColor ? Colors.white : Colors.black,
              fontWeight: FontWeight.w400,
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }
}

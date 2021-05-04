import 'package:flutter/material.dart';

class NiceBox extends StatelessWidget {
  final Widget child;
  final int radius;
  final void Function() onTap;

  NiceBox({this.child, this.radius=10, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Ink(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey[300],
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3),
          )
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 7, horizontal: 12),
          child: child,
        ),
        onTap: onTap,
      ),
    );
  }
}
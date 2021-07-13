import 'package:flutter/material.dart';

class NiceBox extends StatelessWidget {
  final Widget child;
  final double radius;
  final Color color;
  final EdgeInsets padding;
  final void Function() onTap;
  final void Function() onLongPress;
  final void Function(TapDownDetails) onTapDown;
  final bool topCircular;
  final bool bottomCircular;

  const NiceBox({
    this.child,
    this.radius = 10,
    this.onTap,
    this.onLongPress,
    this.onTapDown,
    this.color = Colors.white,
    this.padding = const EdgeInsets.symmetric(vertical: 7, horizontal: 12),
    this.topCircular = true,
    this.bottomCircular = true,
  });

  @override
  Widget build(BuildContext context) {
    Decoration decoration = BoxDecoration(
      color: color,
      borderRadius: BorderRadius.vertical(
        top: topCircular ? Radius.circular(radius) : Radius.zero,
        bottom: bottomCircular ? Radius.circular(radius) : Radius.zero,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.grey[300],
          spreadRadius: 5,
          blurRadius: 7,
          offset: Offset(0, 3),
        )
      ],
    );
    Widget mainChild = InkWell(
      onTapDown: onTapDown,
      onLongPress: onLongPress,
      onTap: onTap,
      borderRadius: BorderRadius.vertical(
        top: topCircular ? Radius.circular(radius) : Radius.zero,
        bottom: bottomCircular ? Radius.circular(radius) : Radius.zero,
      ),
      child: Padding(
        padding: padding,
        child: child,
      ),
    );
    // chapuza per fer arreglar un problema amb el lliscant del calendari
    if (this.onTap == null)
      return Container(
        decoration: decoration,
        child: mainChild,
      );
    else
      return Ink(
        decoration: decoration,
        child: mainChild,
      );
  }
}

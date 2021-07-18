import 'package:flutter/material.dart';

class NiceBox extends StatelessWidget {
  final Widget child;
  final double radius;
  final double progress;
  final Color color;
  final Color progressColor;
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
    this.color,
    this.padding = const EdgeInsets.symmetric(vertical: 7, horizontal: 12),
    this.topCircular = true,
    this.bottomCircular = true,
    this.progress = 0.0,
    this.progressColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    Decoration decoration = BoxDecoration(
      gradient: progress == 0.0
          ? null
          : LinearGradient(
              colors: [this.progressColor, this.progressColor, this.color, this.color],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              stops: [0.0, this.progress, this.progress, 1.0],
            ),
      color: color ?? Colors.white,
      borderRadius: BorderRadius.vertical(
        top: topCircular ? Radius.circular(radius) : Radius.zero,
        bottom: bottomCircular ? Radius.circular(radius) : Radius.zero,
      ),
      boxShadow: [
        BoxShadow(
          color: color == null ? Colors.grey[300] : color.withOpacity(0.3),
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
      child: Stack(
        children: [
          Padding(
            child: child,
            padding: padding,
          ),
        ],
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

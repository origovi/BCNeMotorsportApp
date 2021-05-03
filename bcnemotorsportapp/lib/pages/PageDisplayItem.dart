import 'package:flutter/material.dart';

class PageDisplayItem extends StatelessWidget {
  final Widget child;
  final String title;
  final String heroTag;

  PageDisplayItem(this.child, {this.title, this.heroTag});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: title == null
          ? null
          : AppBar(
              backgroundColor: Colors.black,
              title: Text(title),
            ),
      body: Center(
        child: heroTag != null
            ? Hero(
                tag: heroTag,
                child: child,
              )
            : child,
      ),
    );
  }
}

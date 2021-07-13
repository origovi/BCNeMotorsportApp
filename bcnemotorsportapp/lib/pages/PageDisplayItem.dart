import 'package:flutter/material.dart';

class PageDisplayItem extends StatelessWidget {
  final Widget child;
  final String title;
  final String heroTag;
  final List<Widget> actions;

  const PageDisplayItem(this.child, {this.title, this.heroTag, this.actions});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      appBar: title == null
          ? null
          : AppBar(
              backgroundColor: Colors.black.withOpacity(0.7),
              title: Text(title),
              actions: actions,
              elevation: 0,
              brightness: Brightness.dark,
            ),
      body: heroTag != null
          ? Hero(
              tag: heroTag,
              child: child,
            )
          : child,
    );
  }
}

import 'package:flutter/material.dart';

class PageEvent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              IconButton(
                icon: Icon(Icons.close),
                onPressed: () {},
              ),
            ],
          )
        ],
      ),
    );
  }
}

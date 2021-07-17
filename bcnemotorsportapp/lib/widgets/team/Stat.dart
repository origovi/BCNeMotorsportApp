import 'package:flutter/material.dart';

class Stat extends StatelessWidget {
  final String name;
  final int count;

  const Stat(this.name, this.count);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      child: Card(
        child: Column(
          children: [
            SizedBox(height: 5),
            Text(name, textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w500),),
            SizedBox(height: 10),
            Text(count.toString(), style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
            SizedBox(height: 5),
          ],
        ),
      ),
    );
  }
}

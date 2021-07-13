import 'package:bcnemotorsportapp/Constants.dart';
import 'package:bcnemotorsportapp/models/team/Section.dart';
import 'package:bcnemotorsportapp/widgets/NiceBox.dart';
import 'package:flutter/material.dart';

class SectionCard extends StatelessWidget {
  final Section data;

  const SectionCard(this.data);

  @override
  Widget build(BuildContext context) {
    return NiceBox(
      color: TeamColor.teamColor,
      padding: const EdgeInsets.only(top: 15, left: 18, right: 18),
      radius: 30,
      onTap: () => Navigator.of(context).pushNamed('/team/section', arguments: data),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              data.name,
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 20, color: Colors.white),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
            SizedBox(height: 15),
            Text(
              data.about ?? "",
              style: TextStyle(color: Colors.grey[350]),
              overflow: TextOverflow.ellipsis,
              maxLines: 6,
            ),
          ],
        ),
    );
  }
}

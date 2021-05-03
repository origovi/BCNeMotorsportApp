import 'package:bcnemotorsportapp/Constants.dart';
import 'package:bcnemotorsportapp/models/team/Section.dart';
import 'package:flutter/material.dart';

class SectionCard extends StatelessWidget {
  final Section data;

  SectionCard(this.data);

  @override
  Widget build(BuildContext context) {
    return Ink(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: TeamColor.teamColor,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
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
                data.about,
                style: TextStyle(color: Colors.grey[350]),
                overflow: TextOverflow.ellipsis,
                maxLines: 6,
              ),
            ],
          ),
        ),
        onTap: () => Navigator.of(context).pushNamed('/section', arguments: data),
      ),
    );
  }
}

import 'package:bcnemotorsportapp/models/team/Person.dart';
import 'package:bcnemotorsportapp/widgets/NiceRectangle.dart';
import 'package:bcnemotorsportapp/widgets/ShowImage.dart';
import 'package:flutter/material.dart';

class MemberTile extends StatelessWidget {
  final Person _p;
  final String _role;

  MemberTile(this._p, this._role);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: NiceRectangle(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ShowImage(
              _p.dbId + '.jpg',
              displayTitle: _p.completeName,
              displayable: true,
            ),
            SizedBox(width: 20),
            Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _p.completeName,
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.fade,
                  ),
                  Text(_role),
                  Text(
                    _p.email,
                    style: TextStyle(color: Colors.grey[500]),
                  ),
                ],
              ),
          ],
        ),
        onTap: () {},
      ),
    );
  }
}

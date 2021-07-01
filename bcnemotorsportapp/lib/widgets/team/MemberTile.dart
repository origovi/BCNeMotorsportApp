import 'package:bcnemotorsportapp/models/PopupMenu.dart';
import 'package:bcnemotorsportapp/models/team/Person.dart';
import 'package:bcnemotorsportapp/models/utilsAndErrors.dart';
import 'package:bcnemotorsportapp/providers/CloudDataProvider.dart';
import 'package:bcnemotorsportapp/widgets/NiceBox.dart';
import 'package:bcnemotorsportapp/widgets/ShowImage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class MemberTile extends StatefulWidget {
  final Person _p;
  final String _role;
  final String _sectionId;

  MemberTile({@required Person person, @required String sectionId})
      : _p = person,
        _role = person.role(sectionId),
        _sectionId = sectionId;

  @override
  _MemberTileState createState() => _MemberTileState();
}

class _MemberTileState extends State<MemberTile> {
  String _role;
  // know where to show the popupmenu
  Offset _tapPosition;

  // used to change role
  TextEditingController _roleTextController;

  @override
  void initState() {
    super.initState();
    _role = widget._p.role(widget._sectionId);

    if (widget._role == null)
      _roleTextController = TextEditingController();
    else
      _roleTextController = TextEditingController.fromValue(TextEditingValue(text: _role));
  }

  void _showMenu(BuildContext context) {
    // define function used to send mail to selected user
    Future<void> sendMail() async {
      await launch("mailto:${widget._p.email}");
    }

    Future<void> changeRole() async {
      Popup.fancyPopup(
        context: context,
        columnCrossAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Your Role",
            style: TextStyle(
              color: Colors.grey[600],
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
          TextField(
            controller: _roleTextController,
            autofocus: true,
            inputFormatters: [
              FilteringTextInputFormatter.deny(RegExp('\n')),
            ],
            maxLength: 40,
            keyboardType: TextInputType.multiline,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide(
                  width: 0.0,
                  style: BorderStyle.none,
                ),
              ),
              filled: true,
              hintText: "Your job at the section",
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
                child: Text("Update"),
                onPressed: () async {
                  Navigator.of(context).pop();
                  setState(() {
                    _role = _roleTextController.text.trim();
                  });
                  await Provider.of<CloudDataProvider>(context, listen: false)
                      .updatePersonRoleInSection(
                    widget._p.dbId,
                    widget._sectionId,
                    _roleTextController.text.trim(),
                  );
                  snackDatabaseUpdated(context);
                },
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text("Cancel", style: TextStyle(color: Colors.grey[800])),
              ),
            ],
          ),
        ],
      );
    }

    final RenderBox overlay = Overlay.of(context).context.findRenderObject();

    showMenu(
      context: context,
      position: RelativeRect.fromRect(
          _tapPosition & const Size(40, 40), // smaller rect, the touch area
          Offset.zero & overlay.size // Bigger rect, the entire screen
          ),
      items: (Provider.of<CloudDataProvider>(context, listen: false).dbUId == widget._p.dbId)
          ? TeamScreenMemberTilePopupMenu.choicesOwn
              .map((String choice) => PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  ))
              .toList()
          : TeamScreenMemberTilePopupMenu.choices
              .map((String choice) => PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  ))
              .toList(),
    ).then((value) {
      if (value == TeamScreenMemberTilePopupMenu.SendEmail) {
        sendMail();
      } else if (value == TeamScreenMemberTilePopupMenu.ChangeRole) {
        changeRole();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: NiceBox(
        onTapDown: (details) => _tapPosition = details.globalPosition,
        onLongPress: () => _showMenu(context),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ShowImage(
              widget._p.profilePhotoName,
              displayTitle: widget._p.completeName,
              displayable: true,
            ),
            SizedBox(width: 20),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget._p.completeName,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.fade,
                  maxLines: 1,
                ),
                (_role == null || _role.trim() == "")
                    ? Text(
                        "Role to be set",
                        style: TextStyle(color: Colors.grey[500], fontStyle: FontStyle.italic),
                      )
                    : Text(_role),
                Text(
                  widget._p.email,
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _roleTextController.dispose();
    super.dispose();
  }
}

import 'package:bcnemotorsportapp/models/calendar/Announcement.dart';
import 'package:bcnemotorsportapp/models/popupMenu.dart';
import 'package:bcnemotorsportapp/models/utilsAndErrors.dart';
import 'package:bcnemotorsportapp/providers/CloudDataProvider.dart';
import 'package:bcnemotorsportapp/widgets/NiceBox.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NoticeBoard extends StatefulWidget {
  final List<Announcement> _data;
  final List<TextEditingController> _bodyControllers;
  NoticeBoard(this._data, {Key key})
      : _bodyControllers =
            List.generate(_data.length, (index) => TextEditingController(text: _data[index].body)),
        super(key: key);

  @override
  _NoticeBoardState createState() => _NoticeBoardState();
}

class _NoticeBoardState extends State<NoticeBoard> {
  // know where to show the popupmenu
  Offset _tapPosition;
  void _showMenu(BuildContext context, String announcementId) {
    final RenderBox overlay = Overlay.of(context).context.findRenderObject();
    final BuildContext contextHome = Provider.of<CloudDataProvider>(context, listen: false).context;
    showMenu(
      context: context,
      position: RelativeRect.fromRect(
          _tapPosition & const Size(40, 40), // smaller rect, the touch area
          Offset.zero & overlay.size // Bigger rect, the entire screen
          ),
      items: AnnouncementPopupMenu.choices
          .map((String choice) => PopupMenuItem<String>(
                value: choice,
                child: Text(choice),
              ))
          .toList(),
    ).then((value) {
      if (value == AnnouncementPopupMenu.delete) {
        Popup.twoOptionsPopup(
          contextHome,
          message: "This announcement will be deleted forever. Forever is a long time :(",
          text1: "Delete",
          color1: Colors.red,
          onPressed1: () async {
            Popup.loadingPopup(contextHome);
            await Provider.of<CloudDataProvider>(context, listen: false)
                .deleteAnnouncement(announcementId);
            Navigator.of(contextHome).pop();
            snackDatabaseUpdated(contextHome);
            Navigator.of(contextHome).pop();
          },
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 25.0),
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: 15),
        children: <Widget>[
              Center(
                child: Text(
                  "Latest News",
                  style: TextStyle(fontSize: 25),
                ),
              ),
              SizedBox(height: 15),
              if (widget._data.isEmpty)
                Center(
                  child: Text(
                    "There are no announcements :(",
                    style: TextStyle(color: Colors.grey[500]),
                  ),
                ),
            ] +
            List.generate(widget._data.length, (index) {
              Announcement anno = widget._data[index];
              bool sameYear = DateTime.now().year == anno.whenAdded.year;
              bool sameMonth = sameYear && DateTime.now().month == anno.whenAdded.month;
              return Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 7),
                    decoration: BoxDecoration(
                      color: Colors.grey[500],
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                      formatEventDate(anno.whenAdded,
                          year: !sameYear, month: !sameMonth, short: !sameYear),
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: NiceBox(
                      onTapDown: (details) => _tapPosition = details.globalPosition,
                      onLongPress: () => _showMenu(context, anno.id),
                      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            anno.title,
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (!anno.global)
                            Text(
                              Provider.of<CloudDataProvider>(context, listen: false)
                                      .sectionById(anno.sectionId)
                                      .name ??
                                  "Section not found",
                              style: TextStyle(color: Colors.grey[500]),
                            ),
                          Divider(),
                          TextField(
                            readOnly: true,
                            maxLines: null,
                            controller: widget._bodyControllers[index],
                            decoration: InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: BorderSide(
                                  width: 0.0,
                                  style: BorderStyle.none,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }),
      ),
    );
  }
}

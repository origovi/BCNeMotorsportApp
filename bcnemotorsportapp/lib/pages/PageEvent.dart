import 'package:bcnemotorsportapp/models/calendar/Event.dart';
import 'package:bcnemotorsportapp/models/utilsAndErrors.dart';
import 'package:bcnemotorsportapp/providers/CloudDataProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PageEvent extends StatelessWidget {
  final Event event;
  const PageEvent(this.event);

  void _delete(BuildContext context) {
    Popup.twoOptionsPopup(
      context,
      message: "This event will be deleted forever. Forever is a long time :(",
      text1: "Delete",
      color1: Colors.red,
      onPressed1: () async {
        Popup.loadingPopup(context);
        await Provider.of<CloudDataProvider>(context, listen: false).deleteEvent(this.event.id);
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        snackDatabaseUpdated(context);
        Navigator.of(context).pop();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    //changeSystemUi(statusBrightness: Brightness.dark, milliDelay: 500);
    final provider = Provider.of<CloudDataProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close),
          tooltip: "Close this page",
          onPressed: Navigator.of(context).pop,
        ),
        iconTheme: IconThemeData(color: Colors.black),
        actions: [
          Visibility(
            visible: provider.isTeamLeader ||
                (!event.global && provider.user.chiefSectionIds.contains(event.sectionId)),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  tooltip: "Edit this event",
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  tooltip: "Delete this event",
                  onPressed: () => _delete(context),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: event.color,
                  ),
                ),
                SizedBox(width: 15),
                Text(
                  event.name,
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 30),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 20),
                SizedBox(width: 15),
                Text(
                    formatDates(event.from, event.to, event.allDay),
                    style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Icon(Icons.visibility, size: 20),
                SizedBox(width: 15),
                Text(
                  event.global ? "Everyone" : Provider.of<CloudDataProvider>(context, listen: false).sectionById(event.sectionId).name ?? "Section not found",
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            SizedBox(height: 10),
            if (event.hasNote)
              Column(
                children: [
                  SizedBox(height: 10),
                  TextField(
                    maxLines: 4,
                    readOnly: true,
                    controller: TextEditingController.fromValue(TextEditingValue(text: event.note)),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(
                          width: 0.0,
                          style: BorderStyle.none,
                        ),
                      ),
                      filled: true,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

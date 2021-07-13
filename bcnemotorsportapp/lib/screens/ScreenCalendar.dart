import 'package:bcnemotorsportapp/models/calendar/Announcement.dart';
import 'package:bcnemotorsportapp/models/calendar/Event.dart';
import 'package:bcnemotorsportapp/models/popupMenu.dart';
import 'package:bcnemotorsportapp/models/team/Section.dart';
import 'package:bcnemotorsportapp/models/utilsAndErrors.dart';
import 'package:bcnemotorsportapp/providers/CloudDataProvider.dart';
import 'package:bcnemotorsportapp/services/MessagingService.dart';
import 'package:bcnemotorsportapp/widgets/NiceBox.dart';
import 'package:bcnemotorsportapp/widgets/calendar/Calendar.dart';
import 'package:bcnemotorsportapp/widgets/calendar/NoticeBoard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

class ScreenCalendar extends StatefulWidget {
  @override
  _ScreenCalendarState createState() => _ScreenCalendarState();
}

class _ScreenCalendarState extends State<ScreenCalendar> {
  @override
  void initState() {
    super.initState();
  }

  void newEvent(BuildContext context) {
    Navigator.of(context).pushNamed("/calendar/newEvent").then((value) async {
      if (value != null) {
        List<dynamic> res = List<dynamic>.from(value);
        Event newEvent = res[0];
        Popup.loadingPopup(context);
        await Provider.of<CloudDataProvider>(context, listen: false).newEvent(newEvent);
        if (res[1]) {
          MessagingService.postNotification(
            context,
            title: "New event: ${newEvent.name}",
            body: newEvent.scheduleMessage,
            topic: newEvent.global ? "global" : newEvent.sectionId,
          );
        }
        Navigator.of(context).pop();
        snackDatabaseUpdated(context);
      }
    });
  }

  void newAnnouncement(BuildContext context) {
    Navigator.of(context).pushNamed("/calendar/newAnnouncement").then((value) async {
      if (value != null) {
        List<dynamic> res = List<dynamic>.from(value);
        Announcement newAnnouncement = res[0];
        Popup.loadingPopup(context);
        await Provider.of<CloudDataProvider>(context, listen: false).newAnnouncement(newAnnouncement);
        if (res[1]) {
          MessagingService.postNotification(
            context,
            title: "New announcement",
            body: newAnnouncement.title,
            topic: newAnnouncement.global ? "global" : newAnnouncement.sectionId,
          );
        }
        Navigator.of(context).pop();
        snackDatabaseUpdated(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final cloudDataProvider = Provider.of<CloudDataProvider>(context, listen: false);
    Widget calendarWidgetsAux = Stack(
      children: [
        Calendar(cloudDataProvider.calendarData, key: UniqueKey()),
        DraggableScrollableSheet(
          initialChildSize: 0.085,
          minChildSize: 0.085,
          maxChildSize: 0.9,
          expand: true,
          builder: (context, scrollController) {
            return NiceBox(
              padding: EdgeInsets.zero,
              radius: 25,
              bottomCircular: false,
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  NoticeBoard(
                    cloudDataProvider.calendarData.announcements,
                    key: UniqueKey(),
                  ),
                  SingleChildScrollView(
                    controller: scrollController,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(500),
                          color: Colors.grey[400],
                        ),
                        height: 5,
                        width: 50,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
    return ScrollConfiguration(
      behavior: NoGlowEffect(),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Next events"),
          brightness: Brightness.dark,
          actions: [
            Visibility(
              visible: cloudDataProvider.isTeamLeader || cloudDataProvider.isChief,
              child: PopupMenuButton<String>(
                tooltip: "Visibility",
                icon: Icon(Icons.add),
                onSelected: (value) {
                  switch (value) {
                    case NewCalendar.newEvent:
                      newEvent(context);
                      break;
                    case NewCalendar.newAnnouncement:
                      //MessagingService.postNotification(context, 'hola', 'que tal', 'global');
                      newAnnouncement(context);
                      break;
                    default:
                  }
                },
                itemBuilder: (_) {
                  return NewCalendar.choices
                      .map(
                        (String choice) => PopupMenuItem<String>(
                          value: choice,
                          child: Text(choice),
                        ),
                      )
                      .toList();
                },
              ),
            ),
            PopupMenuButton<String>(
              tooltip: "Visibility",
              icon: Icon(Icons.visibility),
              onSelected: (value) {
                if (value == "Global") {
                  cloudDataProvider.calendarData
                      .filterCalendar(global: !cloudDataProvider.calendarData.global);
                  setState(() {});
                } else {
                  List<String> selectedSectionIds =
                      cloudDataProvider.calendarData.selectedSectionIds;

                  // add to the list value (if it wasnt), otherwise, remove it
                  if (!selectedSectionIds.remove(value)) selectedSectionIds.add(value);

                  cloudDataProvider.calendarData.filterCalendar(sectionIds: selectedSectionIds);
                  setState(() {});
                }
              },
              itemBuilder: (_) {
                List<Section> choices;
                if (cloudDataProvider.isTeamLeader)
                  choices = cloudDataProvider.sectionsData.dataList;
                else
                  choices = cloudDataProvider.userSections;
                return [
                      PopupMenuItem<String>(
                        value: "Global",
                        child: Row(
                          children: [
                            Text("Global"),
                            Spacer(),
                            if (cloudDataProvider.calendarData.global)
                              Icon(Icons.check, color: Colors.grey[600]),
                          ],
                        ),
                      )
                    ] +
                    choices
                        .map(
                          (Section choice) => PopupMenuItem<String>(
                            value: choice.sectionId,
                            child: Row(
                              children: [
                                Text(choice.name),
                                Spacer(),
                                if (cloudDataProvider.calendarData.selectedSectionIds
                                    .contains(choice.sectionId))
                                  Icon(Icons.check, color: Colors.grey[600]),
                              ],
                            ),
                          ),
                        )
                        .toList();
              },
            ),
          ],
        ),
        body: calendarWidgetsAux,
      ),
    );
  }
}

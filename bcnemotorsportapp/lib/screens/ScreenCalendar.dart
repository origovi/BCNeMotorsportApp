import 'package:bcnemotorsportapp/models/calendar/CalendarData.dart';
import 'package:bcnemotorsportapp/models/utilsAndErrors.dart';
import 'package:bcnemotorsportapp/providers/CloudDataProvider.dart';
import 'package:bcnemotorsportapp/widgets/NiceBox.dart';
import 'package:bcnemotorsportapp/widgets/calendar/Calendar.dart';
import 'package:bcnemotorsportapp/widgets/calendar/LlistaEvents.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ScreenCalendar extends StatelessWidget {
  void newEvent(BuildContext context) {
    Navigator.of(context).pushNamed("/calendar/newEvent").then((value) {
      if (value != null) {
        print(value);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: NoGlowEffect(),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Next events"),
          brightness: Brightness.dark,
          actions: [
            Visibility(
              visible: Provider.of<CloudDataProvider>(context, listen: false).isTeamLeader ||
                  Provider.of<CloudDataProvider>(context, listen: false).isChief,
              child: TextButton.icon(
                onPressed: () => newEvent(context),
                icon: Icon(Icons.add),
                label: Text("New Event"),
                style: TextButton.styleFrom(primary: Colors.white),
              ),
            ),
            SizedBox(
              width: 10,
            )
          ],
        ),
        body: content(Provider.of<CloudDataProvider>(context, listen: false).calendarData),
      ),
    );
  }

  Widget content(CalendarData data) => Stack(
        children: [
          Calendar(data),
          DraggableScrollableSheet(
            initialChildSize: 0.08,
            minChildSize: 0.08,
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
                    LlistaEvents(data, scrollController),
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
}

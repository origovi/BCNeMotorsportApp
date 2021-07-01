import 'package:bcnemotorsportapp/Constants.dart';
import 'package:bcnemotorsportapp/models/calendar/CalendarData.dart';
import 'package:bcnemotorsportapp/widgets/NiceBox.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class LlistaEvents extends StatelessWidget {
  final CalendarData _data;
  final ScrollController _scrollController;

  LlistaEvents(this._data, this._scrollController);

  @override
  Widget build(BuildContext context) {
    // List l = List.filled(40, "h");
    // return ListView.builder(
    //   controller: _scrollController,
    //   itemCount: l.length,
    //   itemBuilder: (context, index) {
    //     return ListTile(title: Text("Num $index"));
    //   },
    // );
    return Padding(
      padding: const EdgeInsets.only(top: 25.0),
      child: SfCalendar(
        scheduleViewSettings: ScheduleViewSettings(
          monthHeaderSettings: MonthHeaderSettings(
            height: 50,
            backgroundColor: TeamColor.teamColor,
          ),
          weekHeaderSettings: WeekHeaderSettings()
        ),
        dataSource: _data,
        firstDayOfWeek: 1,
        minDate: DateTime.now(),
        view: CalendarView.schedule,
      ),
    );
  }
}

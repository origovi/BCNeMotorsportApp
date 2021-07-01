import 'package:bcnemotorsportapp/models/calendar/CalendarData.dart';
import 'package:bcnemotorsportapp/providers/CloudDataProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class Calendar extends StatelessWidget {
  final CalendarData data;

  Calendar(this.data);

  void tap(CalendarTapDetails td) {
    if (td.appointments != null) {}
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10, bottom: 30),
      child: SfCalendar(
        dataSource: data,
        firstDayOfWeek: 1,
        view: CalendarView.month,
        allowedViews: [CalendarView.day, CalendarView.month],
        allowViewNavigation: true,
        onTap: tap,
        monthViewSettings: MonthViewSettings(
          showAgenda: true,
          appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
          appointmentDisplayCount: 3,
        ),
      ),
    );
  }
}

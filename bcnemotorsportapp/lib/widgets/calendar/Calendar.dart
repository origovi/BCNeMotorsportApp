import 'package:bcnemotorsportapp/Constants.dart';
import 'package:bcnemotorsportapp/models/calendar/CalendarData.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class Calendar extends StatelessWidget {
  final CalendarData data;
  const Calendar(this.data, {Key key}) : super(key: key);

  void tap(BuildContext context, CalendarTapDetails td) {
    if (td.appointments != null && td.appointments.isNotEmpty) {
      print("num appointments: " + td.appointments.length.toString());
      if (td.targetElement == CalendarElement.appointment)
        Navigator.of(context).pushNamed("/calendar/event", arguments: td.appointments[0]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10, bottom: 30),
      child: SfCalendar(
        dataSource: data,
        firstDayOfWeek: 1,
        view: CalendarView.month,
        allowedViews: [CalendarView.day, CalendarView.month, CalendarView.schedule],
        scheduleViewSettings: ScheduleViewSettings(
          hideEmptyScheduleWeek: true,
          monthHeaderSettings: MonthHeaderSettings(
            height: 50,
            backgroundColor: TeamColor.teamColor,
          ),
          weekHeaderSettings: WeekHeaderSettings(),
        ),
        minDate: DateTime.now().subtract(Duration(days: 360)),
        maxDate: DateTime.now().add(Duration(days: 360)),
        onTap: (onTap) => tap(context, onTap),
        showDatePickerButton: true,
        monthViewSettings: MonthViewSettings(
          showAgenda: true,
          appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
          appointmentDisplayCount: 3,
        ),
      ),
    );
  }
}

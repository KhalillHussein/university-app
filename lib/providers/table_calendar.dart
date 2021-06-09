import 'package:flutter/foundation.dart';

import 'package:table_calendar/table_calendar.dart';

import '../models/index.dart';
import '../util/index.dart';

class TableCalendarProvider with ChangeNotifier {
  List<Timetable> selectedEvents;
  CalendarFormat calendarFormat = CalendarFormat.week;
  DateTime focusedDay = DateTime.now();
  DateTime selectedDay;

  final List<Timetable> timetableList;

  TableCalendarProvider(this.timetableList) {
    selectedDay = focusedDay;
    selectedEvents = getEventsForDay(selectedDay);
  }

  Timetable get maxDay =>
      timetableList.reduce((a, b) => a.date.isAfter(b.date) ? a : b);

  Timetable get minDay =>
      timetableList.reduce((a, b) => a.date.isBefore(b.date) ? a : b);

  List<Timetable> getEventsForDay(DateTime day) {
    return [
      for (final item in timetableList)
        if (item.date.isSameDate(day)) item
    ];
  }

  void onDaySelected(DateTime selDay, DateTime focDay) {
    if (!isSameDay(selectedDay, selDay)) {
      selectedDay = selDay;
      focusedDay = focDay;
      selectedEvents = getEventsForDay(selDay);
      notifyListeners();
    }
  }

  void onPageChanged(DateTime focDay) {
    focusedDay = focDay;
    selectedDay = focDay;
    selectedEvents = getEventsForDay(focDay);
    notifyListeners();
  }

  Future<void> setCalendarFormat() async {
    calendarFormat == CalendarFormat.month
        ? calendarFormat = CalendarFormat.week
        : calendarFormat = CalendarFormat.month;
    notifyListeners();
  }
}

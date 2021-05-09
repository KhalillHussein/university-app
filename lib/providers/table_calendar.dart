import 'package:flutter/foundation.dart';

import 'package:table_calendar/table_calendar.dart';

import '../models/index.dart';

import '../util/index.dart';

class TableCalendarProvider with ChangeNotifier {
  List<Timetable> selectedEvents;
  CalendarFormat calendarFormat = CalendarFormat.week;
  DateTime focusedDay = DateTime.now();
  DateTime selectedDay;

  List<Timetable> timetableList = [];

  TableCalendarProvider() {
    selectedDay = focusedDay;
    selectedEvents = getEventsForDay(selectedDay);
    // init();
  }

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
    notifyListeners();
  }

  Future<void> setCalendarFormat() async {
    calendarFormat == CalendarFormat.month
        ? calendarFormat = CalendarFormat.week
        : calendarFormat = CalendarFormat.month;
    // final SharedPreferences prefs = await SharedPreferences.getInstance();
    // prefs.setInt('format', calendarFormat.index);
    notifyListeners();
  }
  //
  // Future<void> init() async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   final int formatIndex = prefs.getInt('format') ?? CalendarFormat.week.index;
  //   calendarFormat = CalendarFormat.values[formatIndex];
  //   notifyListeners();
  // }
}

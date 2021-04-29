// import 'package:flutter/material.dart';
//
// import 'package:google_fonts/google_fonts.dart';
// import 'package:grouped_list/grouped_list.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
//
// import '../../models/index.dart';
// import '../../repositories/index.dart';
// import '../widgets/index.dart';
//
// class TimetableScreen extends StatelessWidget {
//   final String keyword;
//
//   const TimetableScreen(this.keyword);
//
//   static const route = '/timetable';
//
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<TimetableRepository>(
//       builder: (ctx, model, _) => SimplePage(
//         title: keyword,
//         body: _buildListView(
//           context,
//           model.getBy(keyword),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildListView(BuildContext context, List<Timetable> timetable) {
//     return GroupedListView<Timetable, DateTime>(
//       floatingHeader: true,
//       addAutomaticKeepAlives: false,
//       elements: timetable,
//       groupBy: (element) =>
//           DateTime(element.date.year, element.date.month, element.date.day),
//       groupSeparatorBuilder: (groupByValue) =>
//           _buildSeparator(context, groupByValue),
//       shrinkWrap: true,
//       indexedItemBuilder: (context, schedule, index) => TimetableCard(
//         id: schedule.id,
//         lesson: schedule.lesson,
//         subject: schedule.subject,
//         subjectType: schedule.subjectType,
//         name: schedule.name,
//         aud: schedule.aud,
//         cafedra: schedule.cafedra,
//       ),
//     );
//   }
//
//   Widget _buildSeparator(BuildContext context, DateTime date) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
//       child: Row(children: <Widget>[
//         Expanded(
//           child: Container(
//             margin: const EdgeInsets.only(left: 10.0, right: 20.0),
//             child: Divider(
//               thickness: 1.2,
//               height: 36,
//             ),
//           ),
//         ),
//         Text(
//           '${toBeginningOfSentenceCase(DateFormat.EEEE('Ru').format(date))}, ${DateFormat.MMMMd('Ru').format(date)}',
//           textAlign: TextAlign.center,
//           style: GoogleFonts.rubikTextTheme(
//             Theme.of(context).textTheme,
//           ).caption,
//           textScaleFactor: 1.2,
//         ),
//         Expanded(
//           child: Container(
//               margin: const EdgeInsets.only(left: 20.0, right: 10.0),
//               child: Divider(
//                 thickness: 1.2,
//                 height: 36,
//               )),
//         ),
//       ]),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
//
// import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
// import 'package:provider/provider.dart';
// import 'package:row_collection/row_collection.dart';
// import 'package:table_calendar/table_calendar.dart';
//
// import '../../models/index.dart';
// import '../../repositories/index.dart';
// import '../widgets/index.dart';
//
// class TimetableScreen extends StatefulWidget {
//   final List<Timetable> timetableList;
//
//   const TimetableScreen(this.timetableList);
//
//   static const route = '/timetable';
//
//   @override
//   _TimetableScreenState createState() => _TimetableScreenState();
// }
//
// class _TimetableScreenState extends State<TimetableScreen> {
//   ValueNotifier<List<Timetable>> _selectedEvents;
//   CalendarFormat _calendarFormat = CalendarFormat.week;
//   RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOff;
//   DateTime _focusedDay = DateTime.now();
//   DateTime _selectedDay;
//
//   @override
//   void initState() {
//     super.initState();
//     _selectedDay = _focusedDay;
//     _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay));
//   }
//
//   @override
//   void dispose() {
//     _selectedEvents.dispose();
//     super.dispose();
//   }
//
//   List<Timetable> _getEventsForDay(DateTime day) {
//     return [
//       for (final item in widget.timetableList)
//         if (item.date.isAtSameMomentAs(day)) item
//     ];
//   }
//
//   void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
//     if (!isSameDay(_selectedDay, selectedDay)) {
//       setState(() {
//         _selectedDay = selectedDay;
//         _focusedDay = focusedDay;
//         _rangeSelectionMode = RangeSelectionMode.toggledOff;
//       });
//       _selectedEvents.value = _getEventsForDay(selectedDay);
//     }
//   }
//
//   void _setCalendarType() {
//     setState(() {
//       _calendarFormat = CalendarFormat.month;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<TimetableRepository>(
//       builder: (ctx, model, _) => Scaffold(
//         appBar: AppBar(
//           elevation: 0.0,
//           title: InkWell(
//             onTap: () {
//               setState(() {
//                 _calendarFormat == CalendarFormat.month
//                     ? _calendarFormat = CalendarFormat.week
//                     : _calendarFormat = CalendarFormat.month;
//               });
//             },
//             child: Container(
//               alignment: Alignment.centerLeft,
//               height: kToolbarHeight,
//               child: Row(
//                 children: [
//                   Text(
//                     toBeginningOfSentenceCase(
//                       DateFormat.yMMMM('Ru').format(_focusedDay),
//                     ),
//                   ),
//                   Icon(
//                     Icons.arrow_drop_down,
//                     size: 25,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           actions: [
//             IconButton(
//               icon: Stack(
//                 children: [
//                   Icon(
//                     MdiIcons.calendarBlank,
//                     size: 28,
//                   ),
//                   Positioned(
//                     left: 7.5,
//                     top: 10,
//                     child: Text(
//                       '${DateTime.now().day}',
//                       style: Theme.of(context)
//                           .textTheme
//                           .bodyText1
//                           .copyWith(fontWeight: FontWeight.w600),
//                       textScaleFactor: 0.8,
//                     ),
//                   )
//                 ],
//               ),
//               splashRadius: 20,
//               onPressed: () => _onDaySelected(DateTime.now(), DateTime.now()),
//             ),
//           ],
//         ),
//         body: Column(
//           children: [
//             Card(
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(0.0),
//                 ),
//                 color: Theme.of(context).primaryColor,
//                 margin: EdgeInsets.only(bottom: 8),
//                 elevation: 4,
//                 child: Padding(
//                   padding: const EdgeInsets.only(bottom: 8.0),
//                   child: _buildHeader(),
//                 )),
//             Expanded(child: _buildBody()),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildHeader() {
//     return TableCalendar<Timetable>(
//       locale: 'ru_RU',
//       headerVisible: false,
//       availableCalendarFormats: const {
//         CalendarFormat.month: 'Месяц',
//         CalendarFormat.twoWeeks: '2 недели',
//         CalendarFormat.week: 'Неделя'
//       },
//       formatAnimationDuration: Duration(milliseconds: 400),
//       availableGestures: AvailableGestures.horizontalSwipe,
//       selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
//       eventLoader: (day) => _getEventsForDay(day),
//       calendarFormat: _calendarFormat,
//       onDaySelected: _onDaySelected,
//       rangeSelectionMode: _rangeSelectionMode,
//       onFormatChanged: (format) {
//         if (_calendarFormat != format) {
//           setState(() {
//             _calendarFormat = format;
//           });
//         }
//       },
//       onPageChanged: (focusedDay) {
//         setState(() {
//           _focusedDay = focusedDay;
//         });
//       },
//       calendarBuilders: CalendarBuilders(
//           singleMarkerBuilder: (ctx, day, element) => Container(
//                 margin: EdgeInsets.all(1.3),
//                 decoration: BoxDecoration(
//                   color: element.subjectType.toLowerCase().contains('лек')
//                       ? Theme.of(context).brightness == Brightness.dark
//                           ? Color(0xFF2C9ED4)
//                           : Color(0xFF039BE5)
//                       : element.subjectType.toLowerCase().contains('пз')
//                           ? Theme.of(context).brightness == Brightness.dark
//                               ? Color(0xFF89B3F7)
//                               : Color(0xFF4285F4)
//                           : element.subjectType.toLowerCase().contains('лр')
//                               ? Theme.of(context).brightness == Brightness.dark
//                                   ? Color(0xFF4AB884)
//                                   : Color(0xFF009688)
//                               : Theme.of(context).errorColor,
//                   shape: BoxShape.circle,
//                 ),
//                 width: 4,
//                 height: 4,
//               )),
//       headerStyle: HeaderStyle(
//         formatButtonVisible: false,
//         leftChevronVisible: false,
//         rightChevronVisible: false,
//         titleTextStyle: Theme.of(context).textTheme.headline6,
//         headerPadding: EdgeInsets.symmetric(horizontal: 55, vertical: 15),
//       ),
//       daysOfWeekStyle: DaysOfWeekStyle(
//           weekdayStyle:
//               Theme.of(context).textTheme.caption.copyWith(fontSize: 15)),
//       calendarStyle: CalendarStyle(
//         markersMaxCount: 6,
//         outsideDaysVisible: false,
//         todayDecoration: BoxDecoration(
//           shape: BoxShape.circle,
//           color: Theme.of(context).accentColor,
//         ),
//         selectedDecoration: BoxDecoration(
//           shape: BoxShape.circle,
//           color: Theme.of(context).disabledColor.withOpacity(0.2),
//         ),
//       ),
//       startingDayOfWeek: StartingDayOfWeek.monday,
//       firstDay: DateTime.utc(2010, 10, 16),
//       lastDay: DateTime.utc(2030, 3, 14),
//       focusedDay: _focusedDay,
//     );
//   }
//
//   Widget _buildBody() {
//     return ValueListenableBuilder<List<Timetable>>(
//         valueListenable: _selectedEvents,
//         builder: (context, value, _) {
//           return ListView.separated(
//             separatorBuilder: (ctx, index) => Separator.spacer(space: 7),
//             shrinkWrap: true,
//             itemCount: value.length,
//             itemBuilder: (context, index) => TimetableCard(
//               id: value[index].id,
//               lesson: value[index].lesson,
//               subject: value[index].subject,
//               subjectType: value[index].subjectType,
//               name: value[index].name,
//               aud: value[index].aud,
//               cafedra: value[index].cafedra,
//             ),
//           );
//         });
//   }
// }

import 'dart:math';

import 'package:big_tip/big_tip.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:row_collection/row_collection.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../models/index.dart';
import '../../repositories/index.dart';
import '../widgets/index.dart';

const Duration _kExpand = Duration(milliseconds: 350);

class TimetableScreen extends StatefulWidget {
  final List<Timetable> timetableList;

  const TimetableScreen(this.timetableList);

  static const route = '/timetable';

  @override
  _TimetableScreenState createState() => _TimetableScreenState();
}

class _TimetableScreenState extends State<TimetableScreen>
    with SingleTickerProviderStateMixin<TimetableScreen> {
  ValueNotifier<List<Timetable>> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.week;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOff;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay;

  static final Animatable<double> _easeOutTween =
      CurveTween(curve: Curves.easeOut);
  static final Animatable<double> _easeInTween =
      CurveTween(curve: Curves.easeIn);
  static final Animatable<double> _halfTween =
      Tween<double>(begin: 0.0, end: -0.5);

  Animation<double> _iconTurns;

  AnimationController _controller;
  bool _isExpanded = false;

  @override
  void initState() {
    _controller = AnimationController(duration: _kExpand, vsync: this);
    _iconTurns = _controller.drive(_halfTween.chain(_easeInTween));
    if (_isExpanded) _controller.value = 1.0;

    super.initState();
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay));
  }

  @override
  void dispose() {
    _controller.dispose();
    _selectedEvents.dispose();
    super.dispose();
  }

  void _handleTap() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse().then<void>((void value) {
          if (!mounted) return;
          setState(() {
            // Rebuild without widget.children.
          });
        });
      }
    });
  }

  List<Timetable> _getEventsForDay(DateTime day) {
    return [
      for (final item in widget.timetableList)
        if (item.date.isAtSameMomentAs(day)) item
    ];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
      });
      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TimetableRepository>(
      builder: (ctx, model, _) => Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          title: InkWell(
            onTap: () {
              _handleTap();

              setState(() {
                _calendarFormat == CalendarFormat.month
                    ? _calendarFormat = CalendarFormat.week
                    : _calendarFormat = CalendarFormat.month;
              });
            },
            child: Container(
              alignment: Alignment.centerLeft,
              height: kToolbarHeight,
              child: Row(
                children: [
                  Text(
                    toBeginningOfSentenceCase(
                      DateFormat.yMMMM('Ru').format(_focusedDay),
                    ),
                  ),
                  RotationTransition(
                    turns: _iconTurns,
                    child: const Icon(Icons.arrow_drop_down),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            IconButton(
              icon: Stack(
                children: [
                  Icon(
                    MdiIcons.calendarBlank,
                    size: 28,
                  ),
                  Positioned(
                    left: 7.5,
                    top: 10,
                    child: Text(
                      '${DateTime.now().day}',
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          .copyWith(fontWeight: FontWeight.w600),
                      textScaleFactor: 0.8,
                    ),
                  )
                ],
              ),
              splashRadius: 20,
              onPressed: () => _onDaySelected(DateTime.now(), DateTime.now()),
            ),
          ],
        ),
        body: Column(
          children: [
            Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(8.0),
                    bottomRight: Radius.circular(8.0),
                  ),
                ),
                color: Theme.of(context).primaryColor,
                margin: EdgeInsets.only(bottom: 8),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: _buildHeader(),
                )),
            Expanded(child: _buildBody()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return TableCalendar<Timetable>(
      locale: 'ru_RU',
      headerVisible: false,
      availableCalendarFormats: const {
        CalendarFormat.month: 'Месяц',
        CalendarFormat.twoWeeks: '2 недели',
        CalendarFormat.week: 'Неделя'
      },
      formatAnimationCurve: Curves.easeInOut,
      formatAnimationDuration: Duration(milliseconds: 400),
      availableGestures: AvailableGestures.horizontalSwipe,
      selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
      eventLoader: (day) => _getEventsForDay(day),
      calendarFormat: _calendarFormat,
      onDaySelected: _onDaySelected,
      rangeSelectionMode: _rangeSelectionMode,
      onFormatChanged: (format) {
        if (_calendarFormat != format) {
          setState(() {
            _calendarFormat = format;
          });
        }
      },
      onPageChanged: (focusedDay) {
        setState(() {
          _focusedDay = focusedDay;
        });
      },
      calendarBuilders: CalendarBuilders(
          singleMarkerBuilder: (ctx, day, element) => Container(
                margin: EdgeInsets.all(1.3),
                decoration: BoxDecoration(
                  color: element.subjectType.toLowerCase().contains('лек')
                      ? Theme.of(context).brightness == Brightness.dark
                          ? Color(0xFF2C9ED4)
                          : Color(0xFF039BE5)
                      : element.subjectType.toLowerCase().contains('пз')
                          ? Theme.of(context).brightness == Brightness.dark
                              ? Color(0xFF89B3F7)
                              : Color(0xFF4285F4)
                          : element.subjectType.toLowerCase().contains('лр')
                              ? Theme.of(context).brightness == Brightness.dark
                                  ? Color(0xFF4AB884)
                                  : Color(0xFF009688)
                              : Theme.of(context).errorColor,
                  shape: BoxShape.circle,
                ),
                width: 4,
                height: 4,
              )),
      headerStyle: HeaderStyle(
        formatButtonVisible: false,
        leftChevronVisible: false,
        rightChevronVisible: false,
        titleTextStyle: Theme.of(context).textTheme.headline6,
        headerPadding: EdgeInsets.symmetric(horizontal: 55, vertical: 15),
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
          weekdayStyle:
              Theme.of(context).textTheme.caption.copyWith(fontSize: 15)),
      calendarStyle: CalendarStyle(
        markersMaxCount: 6,
        outsideDaysVisible: false,
        todayDecoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).accentColor,
        ),
        selectedDecoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).disabledColor.withOpacity(0.2),
        ),
      ),
      startingDayOfWeek: StartingDayOfWeek.monday,
      firstDay: DateTime.utc(2010, 10, 16),
      lastDay: DateTime.utc(2030, 3, 14),
      focusedDay: _focusedDay,
    );
  }

  Widget _buildBody() {
    return ValueListenableBuilder<List<Timetable>>(
      valueListenable: _selectedEvents,
      builder: (context, value, _) => _selectedEvents.value.isNotEmpty
          ? ListView.separated(
              separatorBuilder: (ctx, index) => Separator.spacer(space: 7),
              shrinkWrap: true,
              itemCount: value.length,
              itemBuilder: (context, index) => TimetableCard(
                id: value[index].id,
                lesson: value[index].lesson,
                subject: value[index].subject,
                subjectType: value[index].subjectType,
                name: value[index].name,
                aud: value[index].aud,
                cafedra: value[index].cafedra,
              ),
            )
          : BigTip(
              title: Text('Занятия отсутствуют'),
              child: Icon(MdiIcons.bed),
            ),
    );
  }
}

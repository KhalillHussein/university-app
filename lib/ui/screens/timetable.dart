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

import 'package:big_tip/big_tip.dart';
import 'package:expand_widget/expand_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mtusiapp/providers/index.dart';
import 'package:mtusiapp/util/index.dart';

import 'package:provider/provider.dart';
import 'package:row_collection/row_collection.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../models/index.dart';
import '../../repositories/index.dart';
import '../../util/colors.dart';
import '../widgets/index.dart';

const Duration _kExpand = Duration(milliseconds: 350);

// class TimetableScreen extends StatefulWidget {
//   final List<Timetable> timetableList;
//
//   final Categories category;
//
//   const TimetableScreen(this.timetableList, this.category);
//
//   static const route = '/timetable';
//
//   @override
//   _TimetableScreenState createState() => _TimetableScreenState();
// }
//
// class _TimetableScreenState extends State<TimetableScreen>
//     with SingleTickerProviderStateMixin<TimetableScreen> {
//   ValueNotifier<List<Timetable>> _selectedEvents;
//   CalendarFormat _calendarFormat = CalendarFormat.week;
//   DateTime _focusedDay = DateTime.now();
//   DateTime _selectedDay;
//
//   static final Animatable<double> _easeInTween =
//       CurveTween(curve: Curves.easeIn);
//   static final Animatable<double> _halfTween =
//       Tween<double>(begin: 0.0, end: -0.5);
//
//   Animation<double> _iconTurns;
//
//   AnimationController _controller;
//   bool _isExpanded = false;
//
//   @override
//   void initState() {
//     _controller = AnimationController(duration: _kExpand, vsync: this);
//     _iconTurns = _controller.drive(_halfTween.chain(_easeInTween));
//     if (_isExpanded) _controller.value = 1.0;
//
//     super.initState();
//     _selectedDay = _focusedDay;
//     _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay));
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     _selectedEvents.dispose();
//     super.dispose();
//   }
//
//   void _handleTap() {
//     setState(() {
//       _isExpanded = !_isExpanded;
//       if (_isExpanded) {
//         _controller.forward();
//       } else {
//         _controller.reverse().then<void>((void value) {
//           if (!mounted) return;
//           setState(() {});
//         });
//       }
//     });
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
//       });
//       _selectedEvents.value = _getEventsForDay(selectedDay);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<TimetableRepository>(
//       builder: (ctx, model, _) => Scaffold(
//         appBar: AppBar(
//           elevation: 0.0,
//           leading: IconButton(
//             splashRadius: 20,
//             icon: const Icon(MdiIcons.menu),
//             onPressed: Scaffold.of(context).openDrawer,
//           ),
//           title: _buildTitle(),
//           actions: [
//             _buildTimingIconButton(),
//             _buildTodayIconButton(),
//           ],
//         ),
//         body: Column(
//           children: [
//             Card(
//                 shape: RoundedRectangleBorder(),
//                 color: Theme.of(context).primaryColor,
//                 margin: const EdgeInsets.only(bottom: 4),
//                 elevation: 4,
//                 child: Padding(
//                   padding: const EdgeInsets.only(bottom: 8.0),
//                   child: _TableCalendar(),
//                 )),
//             Expanded(child: _buildBody()),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildTitle() {
//     return InkWell(
//       onTap: () {
//         _handleTap();
//
//         setState(() {
//           _calendarFormat == CalendarFormat.month
//               ? _calendarFormat = CalendarFormat.week
//               : _calendarFormat = CalendarFormat.month;
//         });
//       },
//       child: Container(
//         alignment: Alignment.centerLeft,
//         height: kToolbarHeight,
//         child: Row(
//           children: [
//             Text(
//               toBeginningOfSentenceCase(
//                 DateFormat.yMMMM('Ru').format(_focusedDay),
//               ),
//               style: Theme.of(context).textTheme.headline6,
//             ),
//             RotationTransition(
//               turns: _iconTurns,
//               child: Icon(
//                 Icons.arrow_drop_down,
//                 color: Theme.of(context).brightness == Brightness.dark
//                     ? Color(0xFF969BA0)
//                     : Color(0xFF757575),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildTimingIconButton() {
//     return IconButton(
//       icon: Icon(
//         Icons.alarm,
//         size: 26,
//       ),
//       splashRadius: 20,
//       tooltip: 'Звонки',
//       onPressed: () => showBottomDialog(
//         context: context,
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Separator.spacer(space: 25),
//             Text(
//               'РАСПИСАНИЕ ЗВОНКОВ',
//               maxLines: 1,
//               textAlign: TextAlign.center,
//               overflow: TextOverflow.ellipsis,
//               style: Theme.of(context).textTheme.headline6.copyWith(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 18,
//                   ),
//             ),
//             Separator.spacer(space: 20),
//             _Timing(),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildTodayIconButton() {
//     return IconButton(
//       tooltip: 'Сегодня',
//       icon: Stack(
//         alignment: Alignment.center,
//         children: [
//           Icon(
//             Icons.calendar_today,
//             size: 26,
//           ),
//           Positioned(
//             top: 9,
//             child: Text(
//               '${DateTime.now().day}',
//               style: Theme.of(context).textTheme.bodyText1.copyWith(
//                     fontWeight: FontWeight.w600,
//                   ),
//               textScaleFactor: 0.85,
//             ),
//           )
//         ],
//       ),
//       splashRadius: 20,
//       onPressed: () => _onDaySelected(DateTime.now(), DateTime.now()),
//     );
//   }
//
//   Widget _buildHeader() {
//     return TableCalendar<Timetable>(
//       locale: 'ru_RU',
//       headerVisible: false,
//       formatAnimationCurve: Curves.easeOut,
//       formatAnimationDuration: const Duration(milliseconds: 350),
//       availableGestures: AvailableGestures.horizontalSwipe,
//       selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
//       eventLoader: (day) => _getEventsForDay(day),
//       calendarFormat: _calendarFormat,
//       onDaySelected: _onDaySelected,
//       onPageChanged: (focusedDay) {
//         setState(() {
//           _focusedDay = focusedDay;
//           _selectedDay = focusedDay;
//         });
//       },
//       calendarBuilders: CalendarBuilders(
//         selectedBuilder: (ctx, date, _) => Center(
//           child: Container(
//             alignment: Alignment.center,
//             width: 40,
//             height: 40,
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               color: date.year == DateTime.now().year &&
//                       date.month == DateTime.now().month &&
//                       date.day == DateTime.now().day
//                   ? Theme.of(context).accentColor
//                   : Theme.of(context).textTheme.caption.color.withOpacity(0.2),
//             ),
//             child: Text(
//               '${date.day}',
//               textScaleFactor: 1.13,
//               style: TextStyle(color: Colors.white),
//             ),
//           ),
//         ),
//         singleMarkerBuilder: (ctx, day, element) => Container(
//           margin: const EdgeInsets.all(1.3),
//           decoration: BoxDecoration(
//             color: element.subjectType.toLowerCase().contains('лек')
//                 ? Theme.of(context).brightness == Brightness.dark
//                     ? kDarkLectureColor
//                     : kLightLectureColor
//                 : element.subjectType.toLowerCase().contains('пз')
//                     ? Theme.of(context).brightness == Brightness.dark
//                         ? kDarkPracticeColor
//                         : kLightPracticeColor
//                     : element.subjectType.toLowerCase().contains('лр')
//                         ? Theme.of(context).brightness == Brightness.dark
//                             ? kDarkLaboratoryColor
//                             : kLightLaboratoryColor
//                         : Theme.of(context).errorColor,
//             shape: BoxShape.circle,
//           ),
//           width: 4,
//           height: 4,
//         ),
//       ),
//       daysOfWeekStyle: DaysOfWeekStyle(
//         weekdayStyle:
//             Theme.of(context).textTheme.caption.copyWith(fontSize: 15),
//       ),
//       calendarStyle: CalendarStyle(
//         markersMaxCount: 6,
//         outsideDaysVisible: false,
//         todayDecoration: BoxDecoration(
//           shape: BoxShape.circle,
//           color: Theme.of(context).accentColor,
//         ),
//         selectedDecoration: BoxDecoration(
//           shape: BoxShape.circle,
//           color: Theme.of(context).accentColor.withOpacity(0.3),
//         ),
//       ),
//       startingDayOfWeek: StartingDayOfWeek.monday,
//       firstDay: DateTime.now().subtract(Duration(days: 365)),
//       lastDay: DateTime.now().add(Duration(days: 365)),
//       focusedDay: _focusedDay,
//     );
//   }
//
//   Widget _buildBody() {
//     return ValueListenableBuilder<List<Timetable>>(
//       valueListenable: _selectedEvents,
//       builder: (context, value, _) => _selectedEvents.value.isNotEmpty
//           ? ListView.separated(
//               separatorBuilder: (ctx, index) => Separator.spacer(space: 7),
//               padding: const EdgeInsets.symmetric(vertical: 10),
//               shrinkWrap: true,
//               itemCount: value.length,
//               itemBuilder: (context, index) {
//                 switch (widget.category) {
//                   case Categories.group:
//                     return TimetableCard(
//                       lessonNumber: value[index].lesson,
//                       title: value[index].subject,
//                       subjectType: value[index].subjectType,
//                       trailing: value[index].name,
//                       subtitle: value[index].aud,
//                       header: value[index].cafedra,
//                     );
//                     break;
//                   case Categories.lecturer:
//                     return TimetableCard(
//                       lessonNumber: value[index].lesson,
//                       title: value[index].subject,
//                       subjectType: value[index].subjectType,
//                       trailing: value[index].group,
//                       subtitle: value[index].aud,
//                       header: value[index].cafedra,
//                       trailingIcon: MdiIcons.accountGroup,
//                     );
//                     break;
//                   case Categories.auditory:
//                     return TimetableCard(
//                       lessonNumber: value[index].lesson,
//                       title: value[index].subject,
//                       subjectType: value[index].subjectType,
//                       trailing: value[index].name,
//                       subtitle: value[index].group,
//                       header: value[index].cafedra,
//                       subtitleIcon: MdiIcons.accountGroup,
//                     );
//                     break;
//                   default:
//                     return TimetableCard(
//                       lessonNumber: value[index].lesson,
//                       title: value[index].subject,
//                       subjectType: value[index].subjectType,
//                       trailing: value[index].name,
//                       subtitle: value[index].aud,
//                       header: value[index].cafedra,
//                     );
//                     break;
//                 }
//               })
//           : SingleChildScrollView(
//               child: BigTip(
//                 title: const Text('В этот день нет занятий'),
//               ),
//             ),
//     );
//   }
// }

class TimetableScreen extends StatefulWidget {
  final List<Timetable> timetableList;

  final Categories category;

  const TimetableScreen(this.timetableList, this.category);

  static const route = '/timetable';

  @override
  _TimetableScreenState createState() => _TimetableScreenState();
}

class _TimetableScreenState extends State<TimetableScreen>
    with SingleTickerProviderStateMixin<TimetableScreen> {
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
  }

  @override
  void dispose() {
    _controller.dispose();
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
          setState(() {});
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        leading: IconButton(
          splashRadius: 20,
          tooltip: 'Меню',
          icon: const Icon(MdiIcons.menu),
          onPressed: Scaffold.of(context).openDrawer,
        ),
        title: _buildTitle(),
        actions: [
          _buildTimingIconButton(),
          _buildTodayIconButton(context),
          _buildIconMore(),
        ],
      ),
      body: Column(
        children: [
          Card(
            shape: RoundedRectangleBorder(),
            color: Theme.of(context).primaryColor,
            margin: const EdgeInsets.only(bottom: 4),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: _TableCalendar(
                timetableList: widget.timetableList,
              ),
            ),
          ),
          Expanded(child: _buildBody()),
        ],
      ),
    );
  }

  Widget _buildIconMore() {
    return PopupMenuButton<String>(
        tooltip: 'Еще',
        itemBuilder: (context) => const [
              PopupMenuItem(
                value: 'Поиск',
                child: Text('Поиск'),
              ),
              PopupMenuItem(
                value: 'Настройки',
                child: Text('Настройки'),
              ),
            ],
        onSelected: (text) {});
  }

  Widget _buildTitle() {
    final TableCalendarProvider calendar =
        context.watch<TableCalendarProvider>();
    return InkWell(
      onTap: () {
        _handleTap();
        calendar.setCalendarFormat();
      },
      child: Container(
        alignment: Alignment.centerLeft,
        height: kToolbarHeight,
        child: Row(
          children: [
            Text(
              toBeginningOfSentenceCase(
                DateFormat.yMMMM('Ru').format(calendar.focusedDay),
              ),
              style: Theme.of(context).textTheme.headline6,
            ),
            RotationTransition(
              turns: _iconTurns,
              child: Icon(
                Icons.arrow_drop_down,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Color(0xFF969BA0)
                    : Color(0xFF757575),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimingIconButton() {
    return IconButton(
      icon: const Icon(
        Icons.alarm,
        size: 26,
      ),
      splashRadius: 20,
      tooltip: 'Звонки',
      onPressed: () => showBottomDialog(
        context: context,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Separator.spacer(space: 25),
            Text(
              'РАСПИСАНИЕ ЗВОНКОВ',
              maxLines: 1,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.headline6.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
            ),
            Separator.spacer(space: 20),
            _Timing(),
          ],
        ),
      ),
    );
  }

  Widget _buildTodayIconButton(BuildContext context) {
    return IconButton(
      tooltip: 'Сегодня',
      icon: Stack(
        alignment: Alignment.center,
        children: [
          const Icon(
            Icons.calendar_today,
            size: 26,
          ),
          Positioned(
            top: 9,
            child: Text(
              '${DateTime.now().day}',
              style: Theme.of(context).textTheme.bodyText1.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
              textScaleFactor: 0.85,
            ),
          )
        ],
      ),
      splashRadius: 20,
      onPressed: () => context
          .read<TableCalendarProvider>()
          .onDaySelected(DateTime.now(), DateTime.now()),
    );
  }

  Widget _buildBody() {
    return Consumer<TableCalendarProvider>(
      builder: (context, calendarData, _) => calendarData
              .selectedEvents.isNotEmpty
          ? ListView.separated(
              separatorBuilder: (ctx, index) => Separator.spacer(space: 7),
              padding: const EdgeInsets.symmetric(vertical: 10),
              shrinkWrap: true,
              itemCount: calendarData.selectedEvents.length,
              itemBuilder: (context, index) {
                switch (widget.category) {
                  case Categories.group:
                    return TimetableCard(
                      lessonNumber: calendarData.selectedEvents[index].lesson,
                      title: calendarData.selectedEvents[index].subject,
                      subjectType:
                          calendarData.selectedEvents[index].subjectType,
                      trailing: calendarData.selectedEvents[index].name,
                      subtitle: calendarData.selectedEvents[index].aud,
                      header: calendarData.selectedEvents[index].cafedra,
                    );
                    break;
                  case Categories.lecturer:
                    return TimetableCard(
                      lessonNumber: calendarData.selectedEvents[index].lesson,
                      title: calendarData.selectedEvents[index].subject,
                      subjectType:
                          calendarData.selectedEvents[index].subjectType,
                      trailing: calendarData.selectedEvents[index].group,
                      subtitle: calendarData.selectedEvents[index].aud,
                      header: calendarData.selectedEvents[index].cafedra,
                      trailingIcon: MdiIcons.accountGroup,
                    );
                    break;
                  case Categories.auditory:
                    return TimetableCard(
                      lessonNumber: calendarData.selectedEvents[index].lesson,
                      title: calendarData.selectedEvents[index].subject,
                      subjectType:
                          calendarData.selectedEvents[index].subjectType,
                      trailing: calendarData.selectedEvents[index].name,
                      subtitle: calendarData.selectedEvents[index].group,
                      header: calendarData.selectedEvents[index].cafedra,
                      subtitleIcon: MdiIcons.accountGroup,
                    );
                    break;
                  default:
                    return TimetableCard(
                      lessonNumber: calendarData.selectedEvents[index].lesson,
                      title: calendarData.selectedEvents[index].subject,
                      subjectType:
                          calendarData.selectedEvents[index].subjectType,
                      trailing: calendarData.selectedEvents[index].name,
                      subtitle: calendarData.selectedEvents[index].aud,
                      header: calendarData.selectedEvents[index].cafedra,
                    );
                    break;
                }
              })
          : SingleChildScrollView(
              child: BigTip(
                title: const Text('В этот день нет занятий'),
              ),
            ),
    );
  }
}

class _TableCalendar extends StatelessWidget {
  final List<Timetable> timetableList;

  const _TableCalendar({
    @required this.timetableList,
  }) : assert(timetableList != null);

  @override
  Widget build(BuildContext context) {
    return Consumer<TableCalendarProvider>(
      builder: (ctx, calendar, _) => TableCalendar<Timetable>(
        locale: 'ru_RU',
        headerVisible: false,
        formatAnimationCurve: Curves.easeOut,
        formatAnimationDuration: const Duration(milliseconds: 350),
        availableGestures: AvailableGestures.horizontalSwipe,
        selectedDayPredicate: (day) => isSameDay(calendar.selectedDay, day),
        eventLoader: (day) => calendar.getEventsForDay(day),
        calendarFormat: calendar.calendarFormat,
        onDaySelected: calendar.onDaySelected,
        onPageChanged: calendar.onPageChanged,
        calendarBuilders: CalendarBuilders(
          selectedBuilder: _selectedBuilder,
          singleMarkerBuilder: _singleMarkerBuilder,
        ),
        daysOfWeekStyle: DaysOfWeekStyle(
          weekdayStyle:
              Theme.of(context).textTheme.caption.copyWith(fontSize: 15),
        ),
        calendarStyle: CalendarStyle(
          markersMaxCount: 6,
          outsideDaysVisible: false,
          todayDecoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).accentColor,
          ),
          selectedDecoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).accentColor.withOpacity(0.3),
          ),
        ),
        startingDayOfWeek: StartingDayOfWeek.monday,
        firstDay: DateTime.now().subtract(Duration(days: 365)),
        lastDay: DateTime.now().add(Duration(days: 365)),
        focusedDay: calendar.focusedDay,
      ),
    );
  }

  Widget _selectedBuilder(BuildContext ctx, DateTime date, DateTime _) {
    return Center(
      child: Container(
        alignment: Alignment.center,
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: date.year == DateTime.now().year &&
                  date.month == DateTime.now().month &&
                  date.day == DateTime.now().day
              ? Theme.of(ctx).accentColor
              : Theme.of(ctx).textTheme.caption.color.withOpacity(0.2),
        ),
        child: Text(
          '${date.day}',
          textScaleFactor: 1.13,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _singleMarkerBuilder(
      BuildContext ctx, DateTime day, Timetable element) {
    return Container(
      margin: const EdgeInsets.all(1.3),
      decoration: BoxDecoration(
        color: element.subjectType.toLowerCase().contains('лек')
            ? Theme.of(ctx).brightness == Brightness.dark
                ? kDarkLectureColor
                : kLightLectureColor
            : element.subjectType.toLowerCase().contains('пз')
                ? Theme.of(ctx).brightness == Brightness.dark
                    ? kDarkPracticeColor
                    : kLightPracticeColor
                : element.subjectType.toLowerCase().contains('лр')
                    ? Theme.of(ctx).brightness == Brightness.dark
                        ? kDarkLaboratoryColor
                        : kLightLaboratoryColor
                    : Theme.of(ctx).errorColor,
        shape: BoxShape.circle,
      ),
      width: 4,
      height: 4,
    );
  }
}

class _Timing extends StatefulWidget {
  @override
  _TimingState createState() => _TimingState();
}

class _TimingState extends State<_Timing> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Wrap(
            spacing: 6,
            children: [
              for (int i = 0; i < Doc.doc.timing.length; i++)
                ChoiceChip(
                  shape: RoundedRectangleBorder(
                    // side: BorderSide(color: Theme.of(context).accentColor),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  selected: _selectedIndex == i,
                  label: Text(
                    Doc.doc.timing[i]['group'],
                    textScaleFactor: 1.1,
                  ),
                  labelStyle: Theme.of(context).textTheme.caption.copyWith(
                      color: _selectedIndex == i
                          ? Theme.of(context).accentColor
                          : Theme.of(context).textTheme.caption.color),
                  elevation: 0,
                  pressElevation: 5,
                  backgroundColor:
                      Theme.of(context).brightness == Brightness.light
                          ? Theme.of(context).disabledColor.withOpacity(0.1)
                          : Theme.of(context).cardColor,
                  selectedColor: Theme.of(context).accentColor.withOpacity(0.3),
                  onSelected: (bool selected) {
                    setState(() {
                      if (selected) {
                        _selectedIndex = i;
                      }
                    });
                  },
                ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: CardCell(
            child: Column(children: <Widget>[
              if (Doc.doc.timing[_selectedIndex]['shift'].contains('1'))
                RowLayout(
                  children: [
                    RowText(
                        '1 пара',
                        Doc.doc.timing[_selectedIndex]['first']
                            .reduce((a, b) => '$a, $b')),
                    Separator.divider(),
                    RowText(
                        '2 пара',
                        Doc.doc.timing[_selectedIndex]['second']
                            .reduce((a, b) => '$a, $b')),
                    Separator.divider(),
                    RowText(
                        '3 пара',
                        Doc.doc.timing[_selectedIndex]['third']
                            .reduce((a, b) => '$a, $b')),
                  ],
                ),
              if (Doc.doc.timing[_selectedIndex]['shift'].contains('2'))
                RowLayout(
                  children: [
                    RowText(
                        '4 пара',
                        Doc.doc.timing[_selectedIndex]['four']
                            .reduce((a, b) => '$a, $b')),
                    Separator.divider(),
                    RowText(
                        '5 пара',
                        Doc.doc.timing[_selectedIndex]['five']
                            .reduce((a, b) => '$a, $b')),
                    Separator.divider(),
                    RowText(
                        '6 пара',
                        Doc.doc.timing[_selectedIndex]['six']
                            .reduce((a, b) => '$a, $b')),
                    ExpandChild(
                      child: RowLayout(
                        children: [
                          Text(
                            'СУББОТА',
                            style:
                                Theme.of(context).textTheme.headline6.copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                          ),
                          RowText(
                              '1 пара',
                              Doc.doc.timing[_selectedIndex]['first']
                                  .reduce((a, b) => '$a, $b')),
                          Separator.divider(),
                          RowText(
                              '2 пара',
                              Doc.doc.timing[_selectedIndex]['second']
                                  .reduce((a, b) => '$a, $b')),
                          Separator.divider(),
                          RowText(
                              '3 пара',
                              Doc.doc.timing[_selectedIndex]['third']
                                  .reduce((a, b) => '$a, $b')),
                        ],
                      ),
                    ),
                  ],
                ),
            ]),
          ),
        ),
      ],
    );
  }
}

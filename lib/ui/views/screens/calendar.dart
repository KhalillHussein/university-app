import 'package:flutter/material.dart';

import 'package:big_tip/big_tip.dart';
import 'package:expand_widget/expand_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:row_collection/row_collection.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../models/index.dart';
import '../../../providers/index.dart';
import '../../../repositories/index.dart';
import '../../../util/index.dart';
import '../../widgets/index.dart';
import '../screens/index.dart';

const Duration _kExpand = Duration(milliseconds: 350);

class CalendarScreen extends StatefulWidget {
  static const route = '/timetable';

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen>
    with SingleTickerProviderStateMixin<CalendarScreen> {
  static final Animatable<double> _easeInTween =
      CurveTween(curve: Curves.easeIn);
  static final Animatable<double> _halfTween =
      Tween<double>(begin: 0.0, end: -0.5);

  Animation<double> _iconTurns;

  AnimationController _controller;
  bool _isExpanded;

  @override
  void initState() {
    _controller = AnimationController(duration: _kExpand, vsync: this);
    _iconTurns = _controller.drive(_halfTween.chain(_easeInTween));
    _isExpanded = context.read<TableCalendarProvider>().calendarFormat ==
        CalendarFormat.month;
    if (_isExpanded) _controller.value = 1.0;
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BasicPage(
      titleWidget: _buildTitle(),
      actions: [
        _buildTimingIconButton(),
        _buildTodayIconButton(context),
        _buildIconMore(),
      ],
      elevation: 0.0,
      body: ListView(
        children: [
          Card(
            shape: const RoundedRectangleBorder(),
            color: Theme.of(context).primaryColor,
            margin: const EdgeInsets.only(bottom: 1),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: _CalendarHeader(),
            ),
          ),
          _buildBody()
        ],
      ),
    ).contentTab<TimetableRepository>(context);
  }

  Widget _buildIconMore() {
    final model = context.read<TimetableRepository>();
    return PopupMenuButton<String>(
        tooltip: 'Еще',
        itemBuilder: (context) => [
              PopupMenuItem(
                value: 'search',
                child: Row(
                  children: [
                    const Icon(Icons.search),
                    Separator.spacer(),
                    Text('Поиск').scalable(),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'settings',
                child: Row(
                  children: [
                    const Icon(Icons.settings_outlined),
                    Separator.spacer(),
                    Text('Настройки').scalable(),
                  ],
                ),
              ),
            ],
        onSelected: (text) {
          switch (text) {
            case 'search':
              showSearchTimetable(context, model);
              break;
            case 'settings':
              Navigator.pushNamed(context, SettingsScreen.route);
              break;
          }
        });
  }

  Widget _buildTitle() {
    return Consumer<TableCalendarProvider>(
      builder: (ctx, calendar, child) {
        calendar.calendarFormat == CalendarFormat.month
            ? _controller.forward()
            : _controller.reverse().then<void>((void value) {
                if (!mounted) return;
              });
        return InkWell(
          onTap: calendar.setCalendarFormat,
          child: Container(
            alignment: Alignment.centerLeft,
            height: kToolbarHeight,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Row(
                children: [
                  Text(
                    toBeginningOfSentenceCase(
                      DateFormat.yMMMM('Ru').format(calendar.focusedDay),
                    ),
                    // style: Theme.of(context).textTheme.headline6,
                  ),
                  child
                ],
              ),
            ),
          ),
        );
      },
      child: RotationTransition(
        turns: _iconTurns,
        child: Icon(
          Icons.arrow_drop_down,
          color: Theme.of(context).brightness == Brightness.dark
              ? Color(0xFF969BA0)
              : Color(0xFF757575),
        ),
      ),
    );
  }

  Widget _buildTimingIconButton() {
    return IconButton(
      icon: const Icon(
        Icons.alarm,
      ),
      splashRadius: 20,
      tooltip: 'Звонки',
      onPressed: () => showBottomDialog(
        context: context,
        title: 'РАСПИСАНИЕ ЗВОНКОВ',
        children: [
          _Timing(),
        ],
      ),
    );
  }

  Widget _buildTodayIconButton(BuildContext context) {
    return IconButton(
      tooltip: 'Сегодня',
      icon: const Icon(
        Icons.today,
      ),
      splashRadius: 20,
      onPressed: () => context
          .read<TableCalendarProvider>()
          .onDaySelected(DateTime.now(), DateTime.now()),
    );
  }

  Widget _buildBody() {
    return Consumer2<TableCalendarProvider, TimetableRepository>(
        builder: (context, calendar, model, _) {
      return SingleChildScrollView(
        child: Column(
          children: [
            if (model.databaseFetch) Message<TimetableRepository>(),
            if (calendar.selectedEvents.isNotEmpty)
              ListView.separated(
                  physics: NeverScrollableScrollPhysics(),
                  separatorBuilder: (ctx, index) => Separator.spacer(space: 7),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  shrinkWrap: true,
                  itemCount: calendar.selectedEvents.length,
                  itemBuilder: (context, index) {
                    switch (model.getCategory(model.userCategory)) {
                      case Categories.group:
                        return TimetableCard(
                          lessonNumber: calendar.selectedEvents[index].lesson,
                          title: calendar.selectedEvents[index].subject,
                          subjectType:
                              calendar.selectedEvents[index].subjectType,
                          trailing: calendar.selectedEvents[index].name,
                          subtitle: calendar.selectedEvents[index].aud,
                          header: calendar.selectedEvents[index].cafedra,
                        );
                        break;
                      case Categories.lecturer:
                        return TimetableCard(
                          lessonNumber: calendar.selectedEvents[index].lesson,
                          title: calendar.selectedEvents[index].subject,
                          subjectType:
                              calendar.selectedEvents[index].subjectType,
                          trailing: calendar.selectedEvents[index].group,
                          subtitle: calendar.selectedEvents[index].aud,
                          header: calendar.selectedEvents[index].cafedra,
                          trailingIcon: MdiIcons.accountGroup,
                        );
                        break;
                      case Categories.auditory:
                        return TimetableCard(
                          lessonNumber: calendar.selectedEvents[index].lesson,
                          title: calendar.selectedEvents[index].subject,
                          subjectType:
                              calendar.selectedEvents[index].subjectType,
                          trailing: calendar.selectedEvents[index].name,
                          subtitle: calendar.selectedEvents[index].group,
                          header: calendar.selectedEvents[index].cafedra,
                          subtitleIcon: MdiIcons.accountGroup,
                        );
                        break;
                      default:
                        return TimetableCard(
                          lessonNumber: calendar.selectedEvents[index].lesson,
                          title: calendar.selectedEvents[index].subject,
                          subjectType:
                              calendar.selectedEvents[index].subjectType,
                          trailing: calendar.selectedEvents[index].name,
                          subtitle: calendar.selectedEvents[index].aud,
                          header: calendar.selectedEvents[index].cafedra,
                        );
                        break;
                    }
                  }),
            if (calendar.selectedEvents.isEmpty)
              BigTip(
                title: Text(
                  'В этот день нет занятий',
                  style: GoogleFonts.rubikTextTheme(
                    Theme.of(context).textTheme,
                  ).headline5,
                  textScaleFactor: 0.8,
                ).scalable(),
              ),
          ],
        ),
      );
    });
  }
}

class _CalendarHeader extends StatelessWidget {
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
            color: Theme.of(context).accentColor.withOpacity(0.3),
          ),
        ),
        startingDayOfWeek: StartingDayOfWeek.monday,
        firstDay: DateTime.now().subtract(Duration(days: 40)),
        lastDay: DateTime.now().add(Duration(days: 40)),
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
          color: date.isSameDate(DateTime.now())
              ? Theme.of(ctx).accentColor.withOpacity(0.3)
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

  Color getColor(BuildContext context, {String subjectType}) {
    if (subjectType.toLowerCase().contains('лек')) {
      return Theme.of(context).colorScheme.lecture;
    }
    if (subjectType.toLowerCase().contains('пз')) {
      return Theme.of(context).colorScheme.practice;
    }
    if (subjectType.toLowerCase().contains('лр')) {
      return Theme.of(context).colorScheme.laboratory;
    }
    if (subjectType.toLowerCase().contains('кон')) {
      return Theme.of(context).colorScheme.consultation;
    }
    return Theme.of(context).colorScheme.exam;
  }

  Widget _singleMarkerBuilder(
      BuildContext ctx, DateTime day, Timetable element) {
    return Container(
      margin: const EdgeInsets.all(1.3),
      decoration: BoxDecoration(
        color: getColor(ctx, subjectType: element.subjectType),
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
        Wrap(
          spacing: 6,
          children: [
            for (int i = 0; i < timing.length; i++)
              ChoiceChip(
                shape: RoundedRectangleBorder(
                  // side: BorderSide(color: Theme.of(context).accentColor),
                  borderRadius: BorderRadius.circular(5),
                ),
                selected: _selectedIndex == i,
                label: Text(
                  timing[i]['group'],
                ).scalable(),
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
        Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.all(Radius.circular(10)),
              border: Border.all(
                color: Theme.of(context).dividerColor,
                width: 2,
              )),
          child: Column(children: <Widget>[
            if (timing[_selectedIndex]['shift'].contains('1'))
              RowLayout(
                children: [
                  RowText(
                      '1 пара',
                      timing[_selectedIndex]['first']
                          .reduce((a, b) => '$a\n$b')),
                  Separator.divider(),
                  RowText(
                      '2 пара',
                      timing[_selectedIndex]['second']
                          .reduce((a, b) => '$a\n$b')),
                  Separator.divider(),
                  RowText(
                      '3 пара',
                      timing[_selectedIndex]['third']
                          .reduce((a, b) => '$a\n$b')),
                ],
              ),
            if (timing[_selectedIndex]['shift'].contains('2'))
              RowLayout(
                children: [
                  RowText(
                      '4 пара',
                      timing[_selectedIndex]['four']
                          .reduce((a, b) => '$a\n$b')),
                  Separator.divider(),
                  RowText(
                      '5 пара',
                      timing[_selectedIndex]['five']
                          .reduce((a, b) => '$a\n$b')),
                  Separator.divider(),
                  RowText('6 пара',
                      timing[_selectedIndex]['six'].reduce((a, b) => '$a\n$b')),
                  ExpandChild(
                    child: RowLayout(
                      children: [
                        Text(
                          'СУББОТА',
                          style: Theme.of(context).textTheme.headline6.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                        ),
                        RowText(
                            '1 пара',
                            timing[_selectedIndex]['first']
                                .reduce((a, b) => '$a\n$b')),
                        Separator.divider(),
                        RowText(
                            '2 пара',
                            timing[_selectedIndex]['second']
                                .reduce((a, b) => '$a\n$b')),
                        Separator.divider(),
                        RowText(
                            '3 пара',
                            timing[_selectedIndex]['third']
                                .reduce((a, b) => '$a\n$b')),
                      ],
                    ),
                  ),
                ],
              ),
          ]),
        ),
      ],
    );
  }
}

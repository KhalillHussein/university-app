import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

import '../../models/index.dart';
import '../../repositories/index.dart';
import '../../ui/widgets/index.dart';

class TimetablePage extends StatelessWidget {
  final List<String> _tabs = [
    'ДВ-11',
    'ДИ-11',
    'ДИ-12',
    'ДВ-21',
    'ДИ-21',
    'ДИ-22',
    'ДП-31',
    'ДЗ-31',
    'ДС-31',
    'В-31',
    'ДП-41',
    'ДЗ-41',
    'ЗС-41',
    'ЗС-42',
    'М-41',
    'С-41',
  ];

  @override
  Widget build(BuildContext context) {
    return BasicPageNoScaffold<TimetableRepository>(
      body: DefaultTabController(
        length: _tabs.length,
        child: Column(
          children: [
            Container(
              color: Theme.of(context).cardTheme.color,
              child: TabBar(
                isScrollable: true,
                unselectedLabelColor:
                    Theme.of(context).textTheme.bodyText1.color,
                labelColor: Theme.of(context).accentColor,
                indicatorColor: Theme.of(context).accentColor,
                tabs: List<Widget>.generate(
                  _tabs.length,
                  (int index) {
                    return Tab(text: _tabs[index]);
                  },
                ),
              ),
            ),
            Expanded(
              flex: 6,
              child: TabBarView(
                children: List<Widget>.generate(_tabs.length, (int index) {
                  return Consumer<TimetableRepository>(
                    builder: (ctx, model, _) => _buildListView(
                      context,
                      model.getByGroup(_tabs[index]),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListView(BuildContext context, List<Timetable> timetable) {
    return GroupedListView<Timetable, DateTime>(
      floatingHeader: true,
      addAutomaticKeepAlives: false,
      // useStickyGroupSeparators: true,
      elements: timetable,
      groupBy: (element) =>
          DateTime(element.date.year, element.date.month, element.date.day),
      groupSeparatorBuilder: (groupByValue) =>
          _buildSeparator(context, groupByValue),
      shrinkWrap: true,
      indexedItemBuilder: (context, schedule, index) => TimetableCard(
        id: schedule.id,
        lesson: schedule.lesson,
        subject: schedule.subject,
        subjectType: schedule.subjectType,
        name: schedule.name,
        aud: schedule.aud,
      ),
    );
  }

  // Widget _buildSeparator(BuildContext context, dynamic date) {
  //   return Padding(
  //     padding: const EdgeInsets.all(10.0),
  //     child: SizedBox(
  //       height: 30,
  //       child: Align(
  //         child: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: <Widget>[
  //             Expanded(
  //               child: Container(
  //                 decoration: BoxDecoration(
  //                   boxShadow: [
  //                     BoxShadow(
  //                       color: Colors.black12,
  //                       spreadRadius: 1,
  //                       blurRadius: 2,
  //                       offset: Offset(0, 1), // changes position of shadow
  //                     ),
  //                   ],
  //                   color: Theme.of(context).canvasColor,
  //                   border: Border.all(
  //                     width: 0.5,
  //                     color: Theme.of(context).dividerColor,
  //                   ),
  //                   borderRadius: BorderRadius.all(Radius.circular(20.0)),
  //                 ),
  //                 child: Padding(
  //                   padding:
  //                       const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
  //                   child: Text(
  //                     '${toBeginningOfSentenceCase(DateFormat.EEEE('Ru').format(date))}, ${DateFormat('dd.MM.yyyy').format(date)}',
  //                     textAlign: TextAlign.center,
  //                     style:
  //                         TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget _buildSeparator(BuildContext context, DateTime date) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
      child: Text(
        '${toBeginningOfSentenceCase(DateFormat.EEEE('Ru').format(date))}, ${DateFormat('dd.MM.yyyy').format(date)}',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    );
  }
}

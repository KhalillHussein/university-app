import 'dart:math';

import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:expandable/expandable.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

///TODO: REFACTORING REQUIRED
class Progress extends StatelessWidget {
  final List<Map<String, dynamic>> _disciplines = [
    {
      'discipline': 'Иностранный язык',
      'lecturer': 'Светличная Н.О.',
      'percent': 0.95,
    },
    {
      'discipline': 'Информатика',
      'lecturer': 'Швидченко С.А.',
      'percent': 0.76,
    },
    {
      'discipline': 'Физика',
      'lecturer': 'Конкин Б.Б.',
      'percent': 0.83,
    },
    {
      'discipline': 'Теория вероятности',
      'lecturer': 'Ефимов С.В.',
      'percent': 0.67,
    },
    {
      'discipline': 'Математика',
      'lecturer': 'Ефимов С.В.',
      'percent': 0.89,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _disciplines.length,
      itemBuilder: (ctx, index) => ExpandableNotifier(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 8.0),
          child: Card(
            color: Theme.of(context).cardColor,
            child: ScrollOnExpand(
              child: ExpandablePanel(
                theme: ExpandableThemeData(
                  headerAlignment: ExpandablePanelHeaderAlignment.center,
                  iconColor: Theme.of(context).iconTheme.color,
                  tapBodyToCollapse: true,
                ),
                collapsed: SizedBox(),
                header: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text(
                    _disciplines[index]['discipline'],
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ),
                expanded: _buildExpanded(
                    context,
                    _disciplines[index]['lecturer'],
                    _disciplines[index]['percent']),
                builder: (_, __, expanded) {
                  return Expandable(
                    expanded: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: expanded,
                    ),
                    collapsed: SizedBox(),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildExpanded(BuildContext context, String lecturer, double percent) {
    // final List<charts.Series<Task, String>> _seriesPieData = [
    //   charts.Series(
    //     domainFn: (Task task, _) => task.task,
    //     measureFn: (Task task, _) => task.taskvalue,
    //     colorFn: (Task task, _) =>
    //         charts.ColorUtil.fromDartColor(task.colorval),
    //     id: 'Segments',
    //     data: [
    //       Task('1 Модуль', 22, Colors.blue),
    //       Task('2 Модуль', 44, Colors.red),
    //       Task('3 Модуль', 33, Colors.lightGreen),
    //     ],
    //     labelAccessorFn: (Task row, _) => '${row.taskvalue}',
    //   ),
    // ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 5.0, bottom: 5),
          child: Text(
            'Преподаватель: $lecturer',
            style: TextStyle(
                color: Theme.of(context).textTheme.bodyText2.color,
                fontSize: 15),
          ),
        ),
        Row(
          children: [
            Card(
              elevation: 2,
              color: Theme.of(context).appBarTheme.color,
              child: Stack(
                children: [
                  SizedBox(
                    height: 150,
                    width: 155,
                    child: CircularPercentIndicator(
                      radius: 120.0,
                      lineWidth: 13.0,
                      animation: true,
                      percent: percent,
                      center: Text(
                        '${percent * 100}%',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      circularStrokeCap: CircularStrokeCap.round,
                      progressColor: Theme.of(context).primaryColor,
                    ),
                    // charts.PieChart(
                    //   _seriesPieData,
                    //   animate: true,
                    //   animationDuration: Duration(seconds: 1),
                    //   defaultRenderer: charts.ArcRendererConfig(
                    //     arcWidth: 10,
                    //     strokeWidthPx: 0.0,
                    //     // startAngle: 4 / 5 * pi,
                    //     // arcLength: 7 / 5 * pi,
                    //     layoutPaintOrder: charts.LayoutViewPaintOrder.bar,
                    //   ),
                    // ),
                  ),
                  SizedBox(
                    height: 150,
                    width: 155,
                    child: Center(
                      child: Text(
                        '$percent%',
                        style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.blue,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    color: Theme.of(context).appBarTheme.color,
                    elevation: 2.0,
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Модуль 1',
                            style: TextStyle(
                                color:
                                    Theme.of(context).textTheme.bodyText2.color,
                                fontSize: 13),
                          ),
                          Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                color: Color(0xFF4AA552),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            child: Text(
                              '49 из 50',
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyText2
                                      .color,
                                  fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    color: Theme.of(context).appBarTheme.color,
                    elevation: 2.0,
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Модуль 2',
                            style: TextStyle(
                                color:
                                    Theme.of(context).textTheme.bodyText2.color,
                                fontSize: 13),
                          ),
                          Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                color: Color(0xFF4AA552),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            child: Text(
                              '49 из 50',
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyText2
                                      .color,
                                  fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    color: Theme.of(context).appBarTheme.color,
                    elevation: 2.0,
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Пропущено',
                            style: TextStyle(
                                color:
                                    Theme.of(context).textTheme.bodyText2.color,
                                fontSize: 13),
                          ),
                          Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                color: Color(0xFF4AA552),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            child: Text(
                              '1 из 20ч',
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyText2
                                      .color,
                                  fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Card(
                color: Theme.of(context).appBarTheme.color,
                elevation: 2.0,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Отметка 5',
                        style: TextStyle(
                            color: Theme.of(context).textTheme.bodyText2.color,
                            fontSize: 14),
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        decoration: BoxDecoration(
                            color: Color(0xFFA5D631),
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: Text(
                          '60%',
                          style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.bodyText2.color,
                              fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Card(
                color: Theme.of(context).appBarTheme.color,
                elevation: 2.0,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Отметка 4',
                        style: TextStyle(
                            color: Theme.of(context).textTheme.bodyText2.color,
                            fontSize: 14),
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        decoration: BoxDecoration(
                            color: Color(0xFFF7E642),
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: Text(
                          '30%',
                          style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.bodyText2.color,
                              fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Card(
                color: Theme.of(context).appBarTheme.color,
                elevation: 2.0,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Отметка 3',
                        style: TextStyle(
                            color: Theme.of(context).textTheme.bodyText2.color,
                            fontSize: 14),
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        decoration: BoxDecoration(
                            color: Color(0xFFFFAD31),
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: Text(
                          '10%',
                          style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.bodyText2.color,
                              fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Card(
                color: Theme.of(context).appBarTheme.color,
                elevation: 2.0,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Отметка 2',
                        style: TextStyle(
                            color: Theme.of(context).textTheme.bodyText2.color,
                            fontSize: 14),
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 12),
                        decoration: BoxDecoration(
                            color: Color(0xFFEE3A19),
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: Text(
                          '0%',
                          style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.bodyText2.color,
                              fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class Task {
  String task;
  double taskvalue;
  Color colorval;

  Task(this.task, this.taskvalue, this.colorval);
}

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

import '../widgets/index.dart';

///TODO: REFACTORING REQUIRED
class Progress extends StatefulWidget {
  @override
  _ProgressState createState() => _ProgressState();
}

class _ProgressState extends State<Progress> {

  List<charts.Series<Task, String>> _seriesPieData;
  final List<String> _disciplines = [
    'ИНО',
    'Информатика',
    'Физика',
    'Теория вероятности',
    'Математика',
  ];

  @override
  void initState() {
    super.initState();
    _seriesPieData = List<charts.Series<Task, String>>();
    _generateData();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _disciplines.length,
      itemBuilder: (ctx, index) => ExpandableNotifier(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 8.0),
          child: Card(
            elevation: 1.0,
            color: Theme.of(context).appBarTheme.color,
            child: ScrollOnExpand(
              child: ExpandablePanel(
                theme: ExpandableThemeData(
                  headerAlignment: ExpandablePanelHeaderAlignment.center,
                  iconColor: Theme.of(context).iconTheme.color,
                  tapBodyToCollapse: true,
                ),
                header: Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text(
                    _disciplines[index],
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
                expanded: _buildExpanded(),
                builder: (_, __, expanded) {
                  return Padding(
                    padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                    child: Expandable(
                      expanded: expanded,
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  _generateData() {
    final List<Task> piedata = [
      Task('Завершенность предмета', 100, Color(0xff06AAF2)),
    ];
    _seriesPieData.add(
      charts.Series(
        domainFn: (Task task, _) => task.task,
        measureFn: (Task task, _) => task.taskvalue,
        colorFn: (Task task, _) =>
            charts.ColorUtil.fromDartColor(task.colorval),
        id: 'Завершенность дисциплины',
        data: piedata,
        labelAccessorFn: (Task row, _) => '${row.taskvalue}',
      ),
    );
  }

  Widget _buildExpanded() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 5.0, bottom: 5),
          child: Text(
            'Преподаватель: Светличная Н.О',
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
                    child: charts.PieChart(
                      _seriesPieData,
                      animate: true,
                      animationDuration: Duration(seconds: 1),
                      defaultRenderer: charts.ArcRendererConfig(
                        arcWidth: 10,
                        strokeWidthPx: 0.0,
                        startAngle: 3 / 5 * pi,
                        layoutPaintOrder: charts.LayoutViewPaintOrder.point,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 150,
                    width: 155,
                    child: Center(
                      child: Text(
                        "100%",
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
                                color: Colors.green.withOpacity(0.6),
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
                                color: Colors.green.withOpacity(0.6),
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
                                color: Colors.green.withOpacity(0.6),
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
                            color: Color(0xFF4CB050),
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
                            color: Color(0xFFFDEC3E),
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
                            color: Color(0xFFFF9700),
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
                            color: Color(0xFFF44236),
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

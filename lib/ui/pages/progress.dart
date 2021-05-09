import 'package:flutter/material.dart';

import 'package:expandable/expandable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:row_collection/row_collection.dart';
import 'package:row_item/row_item.dart';

import '../../util/index.dart';

class Progress extends StatelessWidget {
  final List<Map<String, dynamic>> _disciplines = [
    {
      'discipline': 'Иностранный язык',
      'lecturer': 'Светличная Н.О.',
      'percent': 0.957,
      'first_module': '46 из 48',
      'second_module': '48 из 52',
      'passed': '6 из 100ч',
      '5': 0.7,
      '4': 0.3,
      '3': 0.0,
      '2': 0.0,
    },
    {
      'discipline': 'Информатика',
      'lecturer': 'Швидченко С.А.',
      'percent': 0.763,
      'first_module': '28 из 32',
      'second_module': '30 из 32',
      'passed': '6 из 64ч',
      '5': 0.2,
      '4': 0.65,
      '3': 0.1,
      '2': 0.05,
    },
    {
      'discipline': 'Физика',
      'lecturer': 'Конкин Б.Б.',
      'percent': 0.832,
      'first_module': '32 из 32',
      'second_module': '30 из 32',
      'passed': '2 из 64ч',
      '5': 0.55,
      '4': 0.35,
      '3': 0.1,
      '2': 0.0,
    },
    {
      'discipline': 'Теория вероятности',
      'lecturer': 'Ефимов С.В.',
      'percent': 0.676,
      'first_module': '8 из 16',
      'second_module': '12 из 16',
      'passed': '12 из 32ч',
      '5': 0.15,
      '4': 0.35,
      '3': 0.4,
      '2': 0.1,
    },
    {
      'discipline': 'Математика',
      'lecturer': 'Ефимов С.В.',
      'percent': 0.491,
      'first_module': '36 из 54',
      'second_module': '32 из 48',
      'passed': '34 из 102ч',
      '5': 0.1,
      '4': 0.32,
      '3': 0.35,
      '2': 0.23,
    },
  ];

  Color getStatusColor(BuildContext context, double percent) {
    if (percent <= 1.0 && percent >= 0.7) {
      return Theme.of(context).colorScheme.success;
    }
    if (percent < 0.7 && percent >= 0.5) {
      return Theme.of(context).colorScheme.warning;
    }
    return Theme.of(context).colorScheme.danger;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 5.0),
      itemCount: _disciplines.length,
      itemBuilder: (ctx, index) => ExpandableNotifier(
        child: _buildDisciplineCard(context, index),
      ),
    );
  }

  Widget _buildDisciplineCard(BuildContext context, int index) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(3.0),
      ),
      margin: const EdgeInsets.only(top: 12.0),
      clipBehavior: Clip.antiAlias,
      elevation: 3,
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              width: 2.0,
              color: getStatusColor(
                context,
                _disciplines[index]['percent'],
              ),
            ),
          ),
        ),
        child: ScrollOnExpand(
          child: ExpandablePanel(
            theme: ExpandableThemeData(
              headerAlignment: ExpandablePanelHeaderAlignment.center,
              iconColor: Theme.of(context).iconTheme.color,
              tapBodyToCollapse: true,
            ),
            collapsed: const SizedBox(),
            header: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _disciplines[index]['discipline'],
                    style: GoogleFonts.rubikTextTheme(
                      Theme.of(context).textTheme,
                    ).headline6,
                    textScaleFactor: 0.85,
                  ).scalable(),
                  Separator.spacer(space: 4),
                  Text(
                    'Преподаватель: ${_disciplines[index]['lecturer']}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.rubikTextTheme(
                      Theme.of(context).textTheme,
                    ).caption.copyWith(fontWeight: FontWeight.w500),
                    textScaleFactor: 1.15,
                  ).scalable(),
                ],
              ),
            ),
            expanded: _buildExpanded(context, _disciplines[index]),
            builder: (_, __, expanded) {
              return Expandable(
                expanded: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: expanded,
                ),
                collapsed: const SizedBox(),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildExpanded(BuildContext context, Map data) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: CircularPercentIndicator(
                  animationDuration: 800,
                  startAngle: 220,
                  radius: 120.0,
                  lineWidth: 12.0,
                  animation: true,
                  percent: data['percent'],
                  addAutomaticKeepAlive: false,
                  backgroundColor: Theme.of(context).dividerColor,
                  center: Text(
                    '${(data['percent'] * 100).toStringAsFixed(1)}%',
                    style: GoogleFonts.rubikTextTheme(
                      Theme.of(context).textTheme,
                    ).headline5.copyWith(
                          color: getStatusColor(
                            context,
                            data['percent'],
                          ),
                        ),
                  ),
                  progressColor: getStatusColor(
                    context,
                    data['percent'],
                  ),
                  circularStrokeCap: CircularStrokeCap.butt,
                ),
              ),
              Separator.spacer(),
              Expanded(
                child: Column(
                  children: [
                    _buildLinearProgress(context,
                        title: 'Модуль 1',
                        trailing: data['first_module'],
                        value: 0.8,
                        color: Theme.of(context).colorScheme.info),
                    Separator.spacer(),
                    _buildLinearProgress(context,
                        title: 'Модуль 2',
                        trailing: data['second_module'],
                        value: 0.9,
                        color: Theme.of(context).colorScheme.info),
                    Separator.spacer(),
                    _buildLinearProgress(context,
                        title: 'Пропущено',
                        trailing: data['passed'],
                        value: 0.9,
                        color: Theme.of(context).colorScheme.info),
                  ],
                ),
              )
            ],
          ),
          Separator.spacer(space: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    _buildLinearProgress(
                      context,
                      title: 'Отметка 5',
                      trailing: '${(data['5'] * 100).toStringAsFixed(1)}%',
                      value: data['5'],
                      color: Theme.of(context).colorScheme.info,
                    ),
                    Separator.spacer(),
                    _buildLinearProgress(
                      context,
                      title: 'Отметка 3',
                      trailing: '${(data['3'] * 100).toStringAsFixed(1)}%',
                      value: data['3'],
                      color: Theme.of(context).colorScheme.info,
                    ),
                  ],
                ),
              ),
              Separator.spacer(),
              Expanded(
                child: Column(
                  children: [
                    _buildLinearProgress(
                      context,
                      title: 'Отметка 4',
                      trailing: '${(data['4'] * 100).toStringAsFixed(1)}%',
                      value: data['4'],
                      color: Theme.of(context).colorScheme.info,
                    ),
                    Separator.spacer(),
                    _buildLinearProgress(context,
                        title: 'Отметка 2',
                        trailing: '${(data['2'] * 100).toStringAsFixed(1)}%',
                        value: data['2'],
                        color: Theme.of(context).colorScheme.info),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Widget _buildRateCard(BuildContext context,
  //     {String name, String overage, Color ovgColor}) {
  //   return Card(
  //     color: Theme.of(context).brightness == Brightness.light
  //         ? Colors.white
  //         : k04dp,
  //     elevation: 3,
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.circular(3.0),
  //     ),
  //     child: Padding(
  //       padding: const EdgeInsets.all(10),
  //       child: Row(
  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         children: [
  //           Expanded(
  //             flex: 3,
  //             child: FittedBox(
  //               alignment: Alignment.topLeft,
  //               fit: BoxFit.scaleDown,
  //               child: Text(
  //                 name,
  //               ),
  //             ),
  //           ),
  //           Expanded(
  //             flex: 2,
  //             child: Container(
  //               padding: const EdgeInsets.all(5),
  //               // decoration: BoxDecoration(
  //               //     color: ovgColor,
  //               //     borderRadius: BorderRadius.all(Radius.circular(5))),
  //               child: FittedBox(
  //                 fit: BoxFit.scaleDown,
  //                 child: Text(
  //                   overage,
  //                 ),
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget _buildLinearProgress(BuildContext context,
      {String title, String trailing, double value, Color color}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Flexible(
              fit: FlexFit.tight,
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.rubikTextTheme(
                  Theme.of(context).textTheme,
                ).bodyText1,
              ).scalable(),
            ),
            // Spacer(flex: 2),
            Text(
              trailing,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.rubikTextTheme(
                Theme.of(context).textTheme,
              ).bodyText2,
            ).scalable(),
          ],
        ),
        Separator.spacer(space: 6),
        LinearProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(color),
          backgroundColor: Theme.of(context).dividerColor,
          value: value,
        ),
      ],
    );
  }

  Widget _buildRateCard(BuildContext context,
      {String name, String overage, Color ovgColor}) {
    return Card(
      color: Theme.of(context).brightness == Brightness.light
          ? Colors.white
          : k04dp,
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(3.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: RowItem.text(
          name,
          overage,
          descriptionStyle: GoogleFonts.rubikTextTheme(
            Theme.of(context).textTheme,
          ).bodyText2.copyWith(
                color: ovgColor,
              ),
        ),
      ),
    );
  }
}

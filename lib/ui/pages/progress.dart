import 'package:flutter/material.dart';

import 'package:expandable/expandable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:row_collection/row_collection.dart';

import '../../util/index.dart';

class Progress extends StatelessWidget {
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
      itemCount: disciplinesProgress.length,
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
                disciplinesProgress[index]['percent'],
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
                    disciplinesProgress[index]['discipline'],
                    style: GoogleFonts.rubikTextTheme(
                      Theme.of(context).textTheme,
                    ).headline6,
                    textScaleFactor: 0.85,
                  ).scalable(),
                  Separator.spacer(space: 4),
                  Text(
                    'Преподаватель: ${disciplinesProgress[index]['lecturer']}',
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
            expanded: _buildExpanded(context, disciplinesProgress[index]),
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
}

import 'package:flutter/material.dart';

import 'package:expandable/expandable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mtusiapp/util/colors.dart';
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
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: ListView.builder(
        itemCount: _disciplines.length,
        itemBuilder: (ctx, index) => ExpandableNotifier(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Card(
              child: ScrollOnExpand(
                child: ExpandablePanel(
                  theme: ExpandableThemeData(
                    headerAlignment: ExpandablePanelHeaderAlignment.center,
                    iconColor: Theme.of(context).iconTheme.color,
                    tapBodyToCollapse: true,
                  ),
                  collapsed: SizedBox(),
                  header: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      _disciplines[index]['discipline'],
                      style: GoogleFonts.rubikTextTheme(
                        Theme.of(context).textTheme,
                      ).headline6,
                      textScaleFactor: 0.8,
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
                      collapsed: const SizedBox(),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRateCard(BuildContext context,
      {String name, String overage, Color ovgColor}) {
    return Card(
      color: Theme.of(context).brightness == Brightness.light
          ? Colors.white
          : k04dp,
      elevation: 2.0,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 3,
              child: Text(
                name,
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: ovgColor,
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    overage,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpanded(BuildContext context, String lecturer, double percent) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10.0, bottom: 5),
          child: Text(
            'Преподаватель: $lecturer',
            style: GoogleFonts.rubikTextTheme(
              Theme.of(context).textTheme,
            ).subtitle1,
            textScaleFactor: 0.9,
          ),
        ),
        Row(
          children: [
            Expanded(
              child: CircularPercentIndicator(
                animationDuration: 800,
                startAngle: 220,
                radius: 120.0,
                lineWidth: 12.0,
                animation: true,
                percent: percent,
                addAutomaticKeepAlive: false,
                backgroundColor: Theme.of(context).dividerColor,
                center: Text(
                  '${percent * 100}%',
                  style: GoogleFonts.rubikTextTheme(
                    Theme.of(context).textTheme,
                  ).headline6.copyWith(
                        color: Theme.of(context).accentColor,
                      ),
                ),
                progressColor: Theme.of(context).accentColor,
                circularStrokeCap: CircularStrokeCap.butt,
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildRateCard(
                    context,
                    name: 'Модуль 1',
                    overage: '49 из 50',
                    ovgColor: Color(0xFF4AA552).withOpacity(0.5),
                  ),
                  _buildRateCard(
                    context,
                    name: 'Модуль 2',
                    overage: '49 из 50',
                    ovgColor: Color(0xFF4AA552).withOpacity(0.5),
                  ),
                  _buildRateCard(
                    context,
                    name: 'Пропущено',
                    overage: '1 из 20ч',
                    ovgColor: Color(0xFF4AA552).withOpacity(0.5),
                  ),
                ],
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: _buildRateCard(
                context,
                name: 'Отметка 5',
                overage: '60%',
                ovgColor: Color(0xFFA5D631).withOpacity(0.5),
              ),
            ),
            Expanded(
              child: _buildRateCard(
                context,
                name: 'Отметка 4',
                overage: '30%',
                ovgColor: Color(0xFFF7E642).withOpacity(0.8),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: _buildRateCard(
                context,
                name: 'Отметка 3',
                overage: '10%',
                ovgColor: Color(0xFFFFAD31).withOpacity(0.8),
              ),
            ),
            Expanded(
              child: _buildRateCard(
                context,
                name: 'Отметка 2',
                overage: '0%',
                ovgColor: Color(0xFFEE3A19).withOpacity(0.8),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

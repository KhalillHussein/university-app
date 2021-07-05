import 'package:flutter/material.dart';

import 'package:expandable/expandable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:row_collection/row_collection.dart';

import '../../../util/doc.dart';
import '../../../util/extensions.dart';

class RecordBookPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GroupedListView<Map, String>(
      padding: EdgeInsets.only(bottom: 15),
      floatingHeader: true,
      addAutomaticKeepAlives: false,
      elements: semestersPerformance,
      separator: Separator.spacer(space: 6),
      groupBy: (element) => element['year'],
      groupSeparatorBuilder: (groupByValue) =>
          _buildSeparator(context, groupByValue),
      shrinkWrap: true,
      indexedItemBuilder: (context, schedule, index) =>
          ExpandableNotifier(child: _buildSemesterCard(context, index)),
    );
  }

  Widget _buildSemesterCard(BuildContext context, int index) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(3.0),
      ),
      margin: const EdgeInsets.only(top: 6.0, left: 10, right: 10),
      elevation: 3.0,
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              width: 2.0,
              color: semestersPerformance[index]['qualified'] == false
                  ? Theme.of(context).colorScheme.danger
                  : Theme.of(context).colorScheme.success,
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
              padding: const EdgeInsets.symmetric(
                vertical: 18.0,
                horizontal: 15.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Семестр ${semestersPerformance[index]['semester']}',
                        style: Theme.of(context)
                            .textTheme
                            .headline6
                            .copyWith(letterSpacing: 0.4),
                        textScaleFactor: 0.8,
                      ).scalable(),
                    ],
                  ),
                  Separator.spacer(space: 4),
                  Text(
                    '${semestersPerformance[index]['course']}, ${semestersPerformance[index]['session']}',
                    style: GoogleFonts.rubikTextTheme(
                      Theme.of(context).textTheme,
                    ).caption.copyWith(fontWeight: FontWeight.w500),
                    textScaleFactor: 1.15,
                  ).scalable(),
                ],
              ),
            ),
            expanded: _buildExpanded(
              context,
              semestersPerformance[index]['disciplines'],
            ),
            builder: (_, __, expanded) {
              return Expandable(
                expanded: expanded,
                collapsed: const SizedBox(),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildExpanded(BuildContext context, List<Map> disciplines) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: MediaQuery.of(context).size.width,
        ),
        child: FittedBox(
          child: DataTable(
            columns: [
              DataColumn(
                label: Text(
                  'Дисциплина',
                  style: Theme.of(context)
                      .textTheme
                      .caption
                      .copyWith(color: Theme.of(context).accentColor),
                  textScaleFactor: 1.3,
                ).scalable(),
              ),
              DataColumn(
                label: Text(
                  'Вид контроля',
                  style: Theme.of(context)
                      .textTheme
                      .caption
                      .copyWith(color: Theme.of(context).accentColor),
                  textScaleFactor: 1.3,
                ).scalable(),
              ),
              DataColumn(
                label: Text(
                  'Оценка',
                  style: Theme.of(context)
                      .textTheme
                      .caption
                      .copyWith(color: Theme.of(context).accentColor),
                  textScaleFactor: 1.3,
                ).scalable(),
              ),
              DataColumn(
                label: Text(
                  'Дата',
                  style: Theme.of(context)
                      .textTheme
                      .caption
                      .copyWith(color: Theme.of(context).accentColor),
                  textScaleFactor: 1.3,
                ).scalable(),
              ),
            ],
            rows: <DataRow>[
              for (final item in disciplines)
                DataRow(
                  color: item['grade'].toString().contains('2')
                      ? MaterialStateProperty.all(
                          Theme.of(context).errorColor.withOpacity(0.15))
                      : MaterialStateProperty.all(Colors.transparent),
                  cells: <DataCell>[
                    DataCell(Text(
                      item['name'],
                      maxLines: 2,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.subtitle1.copyWith(
                          fontWeight: FontWeight.w600, letterSpacing: 0.4),
                    ).scalable()),
                    DataCell(Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        item['control'],
                        style: Theme.of(context).textTheme.subtitle1,
                      ).scalable(),
                    )),
                    DataCell(Align(
                      child: Text(
                        '${item['grade']}',
                        style: Theme.of(context)
                            .textTheme
                            .subtitle1
                            .copyWith(fontWeight: FontWeight.w600),
                      ).scalable(),
                    )),
                    DataCell(Text(
                      item['date'],
                      maxLines: 2,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.subtitle1.copyWith(
                          fontWeight: FontWeight.w600, letterSpacing: 0.4),
                    ).scalable()),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSeparator(BuildContext context, String year) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      child: Row(children: <Widget>[
        Text(
          '$year уч. год',
          textAlign: TextAlign.center,
          style: GoogleFonts.rubikTextTheme(
            Theme.of(context).textTheme,
          ).caption,
          textScaleFactor: 1.2,
        ).scalable(),
        Expanded(
          child: Separator.divider(indent: 10),
        ),
      ]),
    );
  }
}

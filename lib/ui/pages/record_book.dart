import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';
import 'package:google_fonts/google_fonts.dart';

class RecordBookPage extends StatelessWidget {
  final List<Map<String, dynamic>> _semesters = [
    {
      'semester': 1,
      'disciplines': [
        {'name': 'Математика', 'control': 'Экзамен', 'grade': 2},
        {'name': 'Физика', 'control': 'Экзамен', 'grade': 4},
        {'name': 'Электротехника', 'control': 'Зачет', 'grade': 'зачтено'},
        {'name': 'Информатика', 'control': 'Экзамен', 'grade': 4},
        {'name': 'Мат. логика', 'control': 'Зачет', 'grade': 4},
      ],
    },
    {
      'semester': 2,
      'disciplines': [
        {'name': 'БЖ', 'control': 'Экзамен', 'grade': 5},
        {'name': 'Теория связи', 'control': 'Экзамен', 'grade': 4},
        {'name': 'ООП', 'control': 'Экзамен', 'grade': '3'},
        {'name': 'Теория вероятности', 'control': 'Экзамен', 'grade': 4},
        {'name': 'Мат. Логика', 'control': 'Зачет', 'grade': 4},
      ],
    },
    {
      'semester': 3,
      'disciplines': [
        {'name': 'Математика', 'control': 'Экзамен', 'grade': 5},
        {'name': 'Физика', 'control': 'Экзамен', 'grade': 4},
        {'name': 'Электротехника', 'control': 'Зачет', 'grade': 'зачтено'},
        {'name': 'Информатика', 'control': 'Экзамен', 'grade': 4},
        {'name': 'Мат. Логика', 'control': 'Зачет', 'grade': 4},
      ],
    },
    {
      'semester': 4,
      'disciplines': [
        {'name': 'Математика', 'control': 'Экзамен', 'grade': 5},
        {'name': 'Физика', 'control': 'Экзамен', 'grade': 4},
        {'name': 'Электротехника', 'control': 'Зачет', 'grade': 'зачтено'},
        {'name': 'Информатика', 'control': 'Экзамен', 'grade': 4},
        {'name': 'Мат. Логика', 'control': 'Зачет', 'grade': 4},
      ],
    },
    {
      'semester': 5,
      'disciplines': [
        {'name': 'Математика', 'control': 'Экзамен', 'grade': 5},
        {'name': 'Физика', 'control': 'Экзамен', 'grade': 4},
        {'name': 'Электротехника', 'control': 'Зачет', 'grade': 'зачтено'},
        {'name': 'Информатика', 'control': 'Экзамен', 'grade': 4},
        {'name': 'Мат. Логика', 'control': 'Зачет', 'grade': 4},
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: ListView.builder(
        itemCount: _semesters.length,
        itemBuilder: (ctx, index) => ExpandableNotifier(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
                    padding: const EdgeInsets.symmetric(
                      vertical: 18.0,
                      horizontal: 15.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Семестр ${_semesters[index]['semester']}',
                          style: GoogleFonts.rubikTextTheme(
                            Theme.of(context).textTheme,
                          ).headline6,
                          textScaleFactor: 0.8,
                        ),
                        for (final item in _semesters[index]['disciplines'])
                          if (item['grade'].toString().contains('2'))
                            Text(
                              'Необходима пересдача!',
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1
                                  .copyWith(
                                      color: Theme.of(context).errorColor),
                              textScaleFactor: 0.8,
                            ),
                      ],
                    ),
                  ),
                  expanded: _buildExpanded(
                    context,
                    _semesters[index]['disciplines'],
                  ),
                  builder: (_, __, expanded) {
                    return Expandable(
                      expanded: Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
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
      ),
    );
  }

  Widget _buildExpanded(BuildContext context, List<Map> disciplines) {
    return FittedBox(
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
            ),
          ),
          DataColumn(
            label: Text(
              'Вид контроля',
              style: Theme.of(context)
                  .textTheme
                  .caption
                  .copyWith(color: Theme.of(context).accentColor),
              textScaleFactor: 1.3,
            ),
          ),
          DataColumn(
            label: Text(
              'Оценка',
              style: Theme.of(context)
                  .textTheme
                  .caption
                  .copyWith(color: Theme.of(context).accentColor),
              textScaleFactor: 1.3,
            ),
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
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1
                      .copyWith(fontWeight: FontWeight.w600),
                )),
                DataCell(Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    item['control'],
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                )),
                DataCell(Align(
                  child: Text(
                    '${item['grade']}',
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1
                        .copyWith(fontWeight: FontWeight.w600),
                  ),
                )),
              ],
            ),
        ],
      ),
    );
  }
}

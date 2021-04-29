import 'package:big_tip/big_tip.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:row_collection/row_collection.dart';
import 'package:search_page/search_page.dart';

import '../../repositories/index.dart';
import '../screens/index.dart';
import '../widgets/index.dart';

class TimetableTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<TimetableRepository>(
      builder: (ctx, model, _) =>
          ReloadableSimplePage<TimetableRepository>.tabs(
        title: 'Расписание',
        leadingCallBack: Scaffold.of(context).openDrawer,
        fab: FloatingActionButton(
          tooltip: 'Поиск',
          onPressed: model.isLoaded || model.list.isNotEmpty
              ? () => showSearch(
                    context: context,
                    delegate: SearchPage<Map>(
                      items: model.searchCategories(),
                      searchLabel: 'Поиск по расписанию',
                      suggestion: BigTip(
                        title: Text(
                          'Расписание занятий',
                          style: GoogleFonts.rubikTextTheme(
                            Theme.of(context).textTheme,
                          ).headline6,
                        ),
                        subtitle: Text(
                          'Поиск по группе, аудитории, кафедре и преподавателю',
                          style: GoogleFonts.rubikTextTheme(
                            Theme.of(context).textTheme,
                          ).subtitle1.copyWith(
                                color:
                                    Theme.of(context).textTheme.caption.color,
                              ),
                        ),
                        child: Icon(Icons.search),
                      ),
                      failure: BigTip(
                        title: Text(
                          'Ой... Тут пусто',
                          style: GoogleFonts.rubikTextTheme(
                            Theme.of(context).textTheme,
                          ).headline6,
                        ),
                        subtitle: Text(
                          'По вашему запросу ничего не найдено',
                          style: GoogleFonts.rubikTextTheme(
                            Theme.of(context).textTheme,
                          ).subtitle1.copyWith(
                                color:
                                    Theme.of(context).textTheme.caption.color,
                              ),
                        ),
                        child: Icon(Icons.sentiment_dissatisfied),
                      ),
                      filter: (category) => [category['name']],
                      builder: (record) => Column(
                        children: [
                          ListTile(
                            onTap: () => Navigator.pushNamed(
                              context,
                              TimetableScreen.route,
                              arguments: {'keyword': record['name']},
                            ),
                            leading: Icon(
                              record['icon'],
                              size: 35,
                            ),
                            title: Text(record['name']),
                            subtitle: Text(record['category']),
                            trailing: Icon(
                              Icons.arrow_forward_ios_outlined,
                              size: 15,
                            ),
                          ),
                          Separator.divider(indent: 70),
                        ],
                      ),
                    ),
                  )
              : null,
          child: Icon(Icons.search),
        ),
        body: Scrollbar(
          child: ListView.separated(
            itemBuilder: (ctx, index) => _buildListTile(context, model, index),
            separatorBuilder: (ctx, index) => Separator.divider(indent: 15),
            itemCount: model.groups.length,
          ),
        ),
      ),
    );
  }

  Widget _buildListTile(
      BuildContext context, TimetableRepository model, int index) {
    return ListTile(
      title: Text(
        model.groups[index],
        style: GoogleFonts.rubikTextTheme(
          Theme.of(context).textTheme,
        ).bodyText1,
        textScaleFactor: 1.2,
      ),
      trailing: Icon(
        Icons.arrow_forward_ios_outlined,
        size: 15,
      ),
      onTap: () => Navigator.pushNamed(
        context,
        TimetableScreen.route,
        arguments: {'timetableList': model.getBy(model.groups[index])},
      ),
    );
  }
}

import 'package:flutter/material.dart';

import 'package:row_collection/row_collection.dart';
import 'package:search_page/search_page.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import 'package:big_tip/big_tip.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grouped_list/grouped_list.dart';

import '../../models/index.dart';
import '../../repositories/index.dart';
import '../../util/extensions.dart';
import '../widgets/index.dart';

class PhoneBookScreen extends StatelessWidget {
  static const route = '/phone_book';

  @override
  Widget build(BuildContext context) {
    return Consumer<PhoneBookRepository>(
      builder: (ctx, model, _) => ReloadableSimplePage<PhoneBookRepository>(
        title: 'Телефонный справочник',
        fab: FloatingActionButton(
          tooltip: 'Поиск',
          onPressed: model.isLoaded
              ? () => showSearch<PhoneBook>(
                    context: context,
                    delegate: SearchPage<PhoneBook>(
                      items: model.recordings,
                      searchLabel: 'Поиск контактов',
                      suggestion: Center(
                        child: SingleChildScrollView(
                          child: BigTip(
                            title: Text(
                              'Телефонный справочник',
                              style: GoogleFonts.rubikTextTheme(
                                Theme.of(context).textTheme,
                              ).headline6,
                            ).scalable(),
                            subtitle: Text(
                              'Поиск по сотруднику, должности или отделению',
                              style: GoogleFonts.rubikTextTheme(
                                Theme.of(context).textTheme,
                              ).subtitle1.copyWith(
                                    color: Theme.of(context)
                                        .textTheme
                                        .caption
                                        .color,
                                  ),
                            ).scalable(),
                            child: const Icon(Icons.search),
                          ),
                        ),
                      ),
                      failure: Center(
                        child: SingleChildScrollView(
                          child: BigTip(
                            title: Text(
                              'Ой... Тут пусто',
                              style: GoogleFonts.rubikTextTheme(
                                Theme.of(context).textTheme,
                              ).headline6,
                            ).scalable(),
                            subtitle: Text(
                              'По вашему запросу ничего не найдено',
                              style: GoogleFonts.rubikTextTheme(
                                Theme.of(context).textTheme,
                              ).subtitle1.copyWith(
                                    color: Theme.of(context)
                                        .textTheme
                                        .caption
                                        .color,
                                  ),
                            ).scalable(),
                            child: const Icon(Icons.sentiment_dissatisfied),
                          ),
                        ),
                      ),
                      filter: (record) => [
                        record.fullName,
                        for (final department in record.department) department,
                        for (final post in record.post) post,
                      ],
                      builder: (record) => _buildTile(
                        context,
                        titleLabel: record.fullName,
                        subtitleLabel: record.post
                            .reduce((value, element) => '$value, $element'),
                        children: record.phoneNumber,
                      ),
                    ),
                  )
              : null,
          child: const Icon(Icons.search),
        ),
        placeholder: PhoneBookPlaceholder(),
        body: Consumer<PhoneBookRepository>(
          builder: (ctx, model, _) => Scrollbar(
            child: GroupedListView<PhoneBook, String>(
                separator: Separator.divider(indent: 15),
                addAutomaticKeepAlives: false,
                elements: model.recordings,
                groupBy: (element) => element.department.first,
                groupSeparatorBuilder: (groupByValue) =>
                    _buildSeparator(context, groupByValue),
                indexedItemBuilder: (context, record, index) {
                  return _buildTile(
                    context,
                    titleLabel: record.fullName,
                    subtitleLabel: record.post
                        .reduce((value, element) => '$value, $element'),
                    children: record.phoneNumber,
                  );
                }),
          ),
        ),
      ),
    );
  }

  Widget _buildTile(BuildContext context,
      {String titleLabel, String subtitleLabel, List<dynamic> children}) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        backgroundColor: Theme.of(context).brightness == Brightness.light
            ? Theme.of(context).accentColor.withOpacity(0.1)
            : Colors.white10,
        title: Text(
          titleLabel,
          style: Theme.of(context).textTheme.bodyText1,
          textScaleFactor: 1.15,
        ).scalable(),
        trailing: Icon(
          Icons.arrow_forward_ios_outlined,
          size: 16,
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(right: 45.0),
          child: Text(
            subtitleLabel,
            style: GoogleFonts.rubikTextTheme(
              Theme.of(context).textTheme,
            ).caption,
            textScaleFactor: 1.1,
          ).scalable(),
        ),
        childrenPadding: const EdgeInsets.only(left: 10.0),
        children: [
          Row(
            children: [
              for (final item in children)
                Padding(
                  padding: const EdgeInsets.only(right: 15.0),
                  child: TextButton(
                    onPressed: () => launch('tel:+7(863)$item'),
                    child: RichText(
                      text: TextSpan(
                        children: [
                          WidgetSpan(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 5.0),
                              child: Icon(
                                Icons.phone,
                                size: 18,
                                color: Theme.of(context).accentColor,
                              ),
                            ),
                          ),
                          TextSpan(
                            text: item,
                            style:
                                TextStyle(color: Theme.of(context).accentColor),
                          ),
                        ],
                      ),
                      textScaleFactor: 1.15,
                    ).scalable(),
                  ),
                ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildSeparator(BuildContext context, String separator) {
    return HeaderText(
      separator,
      head: separator ==
          context.read<PhoneBookRepository>().recordings.first.department.first,
    );
  }
}

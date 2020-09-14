import 'package:flutter/material.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:provider/provider.dart';

import '../../providers/navigation_provider.dart';
import '../../util/routes.dart';

class AppDrawer extends StatefulWidget {
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  final List<Map<String, Object>> _items = [
    {
      'title': 'Главная',
      'icon': CommunityMaterialIcons.compass_outline,
    },
    {
      'title': 'Новости',
      'icon': CommunityMaterialIcons.newspaper_variant_outline,
    },
  ];

  List<Widget> _buildDrawerContent(BuildContext context) {
    List<Widget> drawerItems = [];
    for (var item in _items) {
      drawerItems.add(
        _buildDrawerItem(
          title: item['title'],
          icon: item['icon'],
          index: _items.indexOf(item),
          context: context,
        ),
      );
    }
    return drawerItems;
  }

  Widget _buildDrawerItem(
      {BuildContext context, IconData icon, String title, int index}) {
    return Consumer<NavigationProvider>(
      builder: (ctx, pageData, ch) => Container(
        margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 7),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(40),
            bottomRight: Radius.circular(40),
          ),
          color: pageData.currentIndex == index
              ? Theme.of(context).selectedRowColor
              : Colors.transparent,
        ),
        child: InkWell(
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(40),
              bottomRight: Radius.circular(40),
            ),
            child: Padding(
              padding: const EdgeInsets.all(7.0),
              child: Row(children: <Widget>[
                Icon(
                  icon,
                  color: pageData.currentIndex == index
                      ? Theme.of(context).focusColor
                      : Theme.of(context).iconTheme.color,
                  size: 28,
                ),
                const SizedBox(
                  width: 30,
                ),
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                    color: Theme.of(context).textTheme.bodyText2.color,
                  ),
                ),
              ]),
            ),
            onTap: () {
              pageData.currentIndex = index;
              Navigator.pop(context);
            }),
      ),
    );
  }

  Widget _buildDrawerHeader(BuildContext context) {
    return Container(
      height: 110,
      padding: const EdgeInsets.only(top: 40.0),
      child: ListTile(
        onTap: () {},
        title: Text(
          'Приемная комиссия',
          style: TextStyle(
              fontSize: 23,
              color: Theme.of(context).textTheme.headline6.color,
              fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          'priem@skf-mtusi.ru',
          style: TextStyle(
              fontSize: 16, color: Theme.of(context).textTheme.bodyText1.color),
        ),
      ),
    );
  }

  Widget _buildDrawerFooter(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 7),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(5)),
      ),
      child: InkWell(
        borderRadius: const BorderRadius.all(Radius.circular(5)),
        child: Padding(
          padding: const EdgeInsets.all(7.0),
          child: Row(
            children: [
              Icon(
                CommunityMaterialIcons.teach,
                color: Theme.of(context).iconTheme.color,
                size: 28,
              ),
              const SizedBox(
                width: 30,
              ),
              Expanded(
                child: Text(
                  'Научно-педагогический состав',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 18,
                    color: Theme.of(context).textTheme.bodyText2.color,
                  ),
                ),
              ),
            ],
          ),
        ),
        onTap: () {
          Navigator.pushNamed(context, Routes.teachers);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildDrawerHeader(context),
          const Divider(),
          Column(
            children: _buildDrawerContent(context),
          ),
          const Divider(),
          _buildDrawerFooter(context),
        ],
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:provider/provider.dart';

import '../../providers/navigation_provider.dart';
import '../../util/sections.dart';
import 'dynamic_treeview.dart';

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

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: CupertinoScrollbar(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              _buildDrawerHeader(context),
              const Divider(),
              Column(
                children: _buildDrawerContent(context),
              ),
              const Divider(),
              DynamicTreeView(
                data: getData(),
                config: Config(
                  parentTextStyle: Theme.of(context).textTheme.bodyText2,
                  parentPaddingEdgeInsets:
                      EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
                  childrenPaddingEdgeInsets:
                      EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
                  childrenTextStyle: Theme.of(context).textTheme.bodyText2,
                ),
                onTap: (m) {
                  debugPrint("onChildTap -> $m");
                  if (m['extra']['routeName'] != null) {
                    Navigator.pushNamed(context, m['extra']['routeName']);
                  }
                },
                width: double.infinity,
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildDrawerContent(BuildContext context) {
    final List<Widget> drawerItems = [];
    for (final item in _items) {
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
          onTap: () {
            pageData.currentIndex = index;
            Navigator.pop(context);
          },
          child: Padding(
            padding: const EdgeInsets.all(7.0),
            child: Row(children: <Widget>[
              Icon(
                icon,
                size: 28,
                color: pageData.currentIndex == index
                    ? Theme.of(context).focusColor
                    : Theme.of(context).iconTheme.color,
              ),
              const SizedBox(
                width: 30,
              ),
              Text(
                title,
                style: Theme.of(context).textTheme.bodyText2,
              ),
            ]),
          ),
        ),
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
              fontSize: 22,
              color: Theme.of(context).textTheme.headline6.color,
              fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          'priem@skf-mtusi.ru',
          style: TextStyle(
              fontSize: 15, color: Theme.of(context).textTheme.bodyText1.color),
        ),
      ),
    );
  }

  List<BaseData> getData() {
    return Sections.drawerSections.map((item) {
      return DataModel(
          id: item['id'],
          parentId: item['parentId'],
          name: item['title'],
          icon: item['icon'],
          extras: {'routeName': item['routeName']});
    }).toList();
  }
}

class DataModel implements BaseData {
  final int id;
  final int parentId;
  String name;
  IconData icon;

  ///Any extra data you want to get when tapped on children
  Map<String, dynamic> extras;
  DataModel({this.id, this.parentId, this.name, this.extras, this.icon});
  @override
  String getId() {
    return id.toString();
  }

  @override
  Map<String, dynamic> getExtraData() {
    return extras;
  }

  @override
  String getParentId() {
    return parentId.toString();
  }

  @override
  String getTitle() {
    return name;
  }

  @override
  IconData getIcon() {
    return icon;
  }
}

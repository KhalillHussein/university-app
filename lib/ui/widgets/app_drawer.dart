import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:provider/provider.dart';

import '../../providers/navigation_provider.dart';
import 'dynamic_treeview.dart';
import '../../ui/widgets/custom_tile.dart';
import '../../util/routes.dart';
import '../../util/sections.dart';

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
                  style: Theme.of(context).textTheme.bodyText2,
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
                  print("onChildTap -> $m");
                },
                width: double.infinity,
              ),
              // ListView.builder(
              //   padding: EdgeInsets.zero,
              //   physics: NeverScrollableScrollPhysics(),
              //   shrinkWrap: true,
              //   itemCount: _mainTree.length,
              //   itemBuilder: (ctx, index) => ParentWidget(
              //     icon: _mainTree[index]['icon'],
              //     title: _mainTree[index]['title'],
              //     items: _mainTree[index]['sub_tree'],
              //   ),
              // ),
            ],
          ),
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
      );
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
    return this.id.toString();
  }

  @override
  Map<String, dynamic> getExtraData() {
    return this.extras;
  }

  @override
  String getParentId() {
    return this.parentId.toString();
  }

  @override
  String getTitle() {
    return this.name;
  }

  @override
  IconData getIcon() {
    return this.icon;
  }
}

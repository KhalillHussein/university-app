import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../repositories/index.dart';
import '../../ui/pages/index.dart';
import '../widgets/index.dart';
import 'index.dart';

class AccountPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<Auth>(
      builder: (ctx, userData, _) => Column(
        children: <Widget>[
          _Header(userData),
          if (userData.user.role == 'student') _StudentTabs(),
          if (userData.user.role == 'lecturer') _LecturerTabs(),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final Auth userData;

  const _Header(this.userData);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      shape: RoundedRectangleBorder(),
      color: Theme.of(context).backgroundColor,
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  userData.user.userName,
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                ),
              ),
            ),
            if (userData.user.role == 'lecturer')
              Container(
                margin: EdgeInsets.only(right: 12),
                padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.green, width: 1.5),
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: Row(
                  children: [
                    Icon(
                      MdiIcons.chartAreaspline,
                      color: Colors.green,
                    ),
                    const SizedBox(
                      width: 5.0,
                    ),
                    Text(
                      '1.0',
                      style: TextStyle(
                          color: Colors.green, fontWeight: FontWeight.w700),
                    )
                  ],
                ),
              ),
            Stack(
              children: <Widget>[
                IconButton(
                  icon: Icon(
                    MdiIcons.bell,
                    size: 28,
                    color: Theme.of(context).primaryIconTheme.color,
                  ),
                  onPressed: () {},
                ),
                Positioned(
                  right: 8,
                  top: 8,
                  child: Icon(
                    MdiIcons.circle,
                    color: Theme.of(context).errorColor,
                    size: 12,
                  ),
                ),
              ],
            ),
            Badge(
              value: '+1',
              child: IconButton(
                icon: Icon(
                  MdiIcons.email,
                  size: 28,
                  color: Theme.of(context).primaryIconTheme.color,
                ),
                onPressed: () {},
              ),
            ),
            IconButton(
              icon: Icon(
                MdiIcons.exitToApp,
                size: 28,
                color: Theme.of(context).primaryIconTheme.color,
              ),
              onPressed: () => _showDialog(context, userData),
            ),
          ],
        ),
      ),
    );
  }

  void _showDialog(BuildContext context, Auth userData) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).appBarTheme.color,
        content: const Text('Вы действительно хотите выйти?'),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: Text(
              'ОТМЕНА',
              style: Theme.of(context).accentTextTheme.button,
            ),
          ),
          FlatButton(
            onPressed: () {
              Navigator.of(ctx).pop(userData.logout());
            },
            child: Text(
              'ОК',
              style: Theme.of(context).accentTextTheme.button,
            ),
          ),
        ],
      ),
    );
  }
}

class _StudentTabs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 6,
      child: DefaultTabController(
        length: 3,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          color: Theme.of(context).cardTheme.color,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: TabBar(
                  isScrollable: true,
                  unselectedLabelColor:
                      Theme.of(context).textTheme.bodyText1.color,
                  labelColor: Theme.of(context).accentColor,
                  indicatorColor: Theme.of(context).accentColor,
                  tabs: const <Widget>[
                    Tab(
                      child: Text(
                        'РАСПИСАНИЕ ЗАНЯТИЙ',
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        softWrap: true,
                      ),
                    ),
                    Tab(
                      child: Text('УСПЕВАЕМОСТЬ'),
                    ),
                    Tab(
                      child: Text('ПОРТФОЛИО'),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: <Widget>[
                    TimetablePage(),
                    Progress(),
                    const Center(child: Text('Портфолио')),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LecturerTabs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 6,
      child: DefaultTabController(
        length: 2,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            color: Theme.of(context).cardTheme.color,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: TabBar(
                    unselectedLabelColor:
                        Theme.of(context).textTheme.bodyText1.color,
                    labelColor: Theme.of(context).accentColor,
                    indicatorColor: Theme.of(context).accentColor,
                    tabs: const <Widget>[
                      Tab(
                        child: Text(
                          'РАСПИСАНИЕ ЗАНЯТИЙ',
                          maxLines: 2,
                          textAlign: TextAlign.center,
                          softWrap: true,
                        ),
                      ),
                      Tab(
                        child: Text('МРС'),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    children: <Widget>[
                      TimetablePage(),
                      Center(child: Text('МРС')),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../repositories/index.dart';
import '../pages/index.dart';
import '../screens/index.dart';
import '../tabs/index.dart';
import '../widgets/index.dart';

class AccountTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ReloadableSimplePage<TimetableRepository>.tabs(
      title: 'Аккаунт',
      leadingCallBack: Scaffold.of(context).openDrawer,
      body: Consumer<AuthRepository>(
        builder: (ctx, userData, _) => Column(
          children: <Widget>[
            _Header(userData),
            if (userData.user.role == 'student') _StudentTabs(),
            if (userData.user.role == 'lecturer') _LecturerTabs(),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final AuthRepository userData;

  const _Header(this.userData);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      elevation: 2.0,
      shape: RoundedRectangleBorder(),
      color: Theme.of(context).cardTheme.color,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(userData.user.userName,
                    style: Theme.of(context).textTheme.headline6),
              ),
            ),
            if (userData.user.role == 'lecturer')
              Container(
                margin: const EdgeInsets.only(right: 12),
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
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
            IconButton(
              splashRadius: 20,
              icon: Icon(
                MdiIcons.bell,
                size: 25,
              ),
              color: Theme.of(context).primaryIconTheme.color,
              onPressed: null,
            ),
            IconButton(
              splashRadius: 20,
              icon: Icon(
                MdiIcons.email,
                size: 25,
              ),
              onPressed: null,
            ),
            IconButton(
              splashRadius: 20,
              icon: Icon(
                MdiIcons.exitToApp,
                size: 23,
              ),
              onPressed: () => _showDialog(context, userData),
            ),
          ],
        ),
      ),
    );
  }

  void _showDialog(BuildContext context, AuthRepository userData) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).appBarTheme.color,
        content: Text(
          'Вы действительно хотите выйти?',
        ),
        actions: <Widget>[
          TextButton(
            style:
                TextButton.styleFrom(primary: Theme.of(context).disabledColor),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: Text(
              'ОТМЕНА',
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop(userData.logout());
            },
            child: Text(
              'ОК',
            ),
          ),
        ],
      ),
    );
  }
}

class _StudentTabs extends StatelessWidget {
  List<Map<String, dynamic>> _tabs(BuildContext context) {
    return [
      {
        'tab': 'РАСПИСАНИЕ ЗАНЯТИЙ',
        'page': TimetableScreen(context
            .watch<TimetableRepository>()
            .getBy(context.read<AuthRepository>().user.group)),
      },
      {
        'tab': 'УСПЕВАЕМОСТЬ',
        'page': Progress(),
      },
      {
        'tab': 'ЗАЧЕТНАЯ КНИЖКА',
        'page': RecordBookPage(),
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 6,
      child: DefaultTabController(
        length: 3,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: TabBar(
                labelColor: Theme.of(context).accentColor,
                unselectedLabelColor: Theme.of(context).textTheme.caption.color,
                isScrollable: true,
                tabs: <Widget>[
                  for (final item in _tabs(context))
                    Tab(
                      child: Text(
                        item['tab'],
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: TabBarView(
                  children: <Widget>[
                    for (final item in _tabs(context))
                      Tab(
                        child: item['page'],
                      ),
                  ],
                ),
              ),
            ),
          ],
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
                    indicatorColor: Theme.of(context).primaryColor,
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
                      TimetableTab(),
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

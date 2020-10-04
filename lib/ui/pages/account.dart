import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:community_material_icon/community_material_icon.dart';

import '../../providers/auth_provider.dart';
import '../widgets/badge.dart';
import 'schedule.dart';

class AccountPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<Auth>(
      builder: (ctx, userData, _) => Column(
        children: <Widget>[
          Header(userData),
          if (userData.role == 'student') StudentTabs(),
          if (userData.role == 'lecturer') LecturerTabs(),
        ],
      ),
    );
  }
}

class Header extends StatelessWidget {
  final Auth userData;

  const Header(this.userData);

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
              child: Text(
                userData.userName,
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
              ),
            ),
            Stack(
              children: <Widget>[
                IconButton(
                  icon: Icon(
                    CommunityMaterialIcons.bell,
                    size: 28,
                    color: Theme.of(context).primaryIconTheme.color,
                  ),
                  onPressed: () {},
                ),
                Positioned(
                  right: 8,
                  top: 8,
                  child: Icon(
                    CommunityMaterialIcons.circle,
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
                  CommunityMaterialIcons.email,
                  size: 28,
                  color: Theme.of(context).primaryIconTheme.color,
                ),
                onPressed: () {},
              ),
            ),
            IconButton(
              icon: Icon(
                CommunityMaterialIcons.exit_to_app,
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
}

class StudentTabs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 6,
      child: DefaultTabController(
        length: 3,
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
                      SchedulePage(),
                      const Center(child: Text('Успеваемость')),
                      const Center(child: Text('Портфолио')),
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

class LecturerTabs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 6,
      child: DefaultTabController(
        length: 2,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            color: Theme.of(context).cardColor,
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
                      SchedulePage(),
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

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../providers/index.dart';
import '../tabs/index.dart';
import '../widgets/index.dart';

class NavigationScreen extends StatelessWidget {
  static const route = '/';

  final List<Map<String, Object>> _tabs = [
    {
      'title': 'Новости',
      'tab': NewsTab(),
    },
    {
      'title': 'Расписание',
      'tab': TimetableTab(),
    },
    {
      'title': 'Авторизация',
      'tab': AuthTab(),
    },
    {
      'title': 'Основные сведения',
      'tab': AboutTab(),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ThemeSwitchingArea(
      child: Scaffold(
        drawer: AppDrawer(),
        body: _buildBody(),
        bottomNavigationBar: _buildBottomNavigationBar(context),
      ),
    );
  }

  Widget _buildBody() {
    return Consumer<NavigationProvider>(
      builder: (ctx, tabData, _) => _tabs[tabData.currentIndex]['tab'],
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    return Consumer<NavigationProvider>(
      builder: (ctx, tabsData, _) => BottomNavigationBar(
        // showSelectedLabels: false,
        // showUnselectedLabels: false,
        // selectedFontSize: 0,
        onTap: (index) => tabsData.currentIndex = index,
        currentIndex: tabsData.currentIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              MdiIcons.newspaperVariantOutline,
              size: 30,
            ),
            label: 'Новости',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              MdiIcons.calendarTextOutline,
              size: 28,
            ),
            label: 'Расписание',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              MdiIcons.account,
              size: 30,
            ),
            label: 'Аккаунт',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              MdiIcons.accessPoint,
              size: 30,
            ),
            label: 'О нас',
          ),
        ],
      ),
    );
  }
}

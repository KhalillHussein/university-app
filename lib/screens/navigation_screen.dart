import 'package:flutter/material.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:provider/provider.dart';
import 'package:animated_theme_switcher/animated_theme_switcher.dart';

import '../widgets/app_drawer.dart';
import '../widgets/badge.dart';
import '../screens/news_screen.dart';
import '../screens/home_screen.dart';
import '../providers/navigation_provider.dart';
import '../widgets/theme_switch.dart';
import '../widgets/auth_status.dart';

class NavigationScreen extends StatefulWidget {
  @override
  _NavigationScreenState createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  final List<Map<String, Object>> _pages = [
    {
      'title': 'Главная',
      'page': HomeScreen(),
    },
    {
      'title': 'Новости',
      'page': NewsScreen(),
    },
    {
      'title': 'Авторизация',
      'page': AuthStatus(),
    },
  ];

  Widget _buildBody() {
    return Consumer<NavigationProvider>(
      builder: (ctx, tabData, _) => _pages[tabData.currentIndex]['page'],
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    return Consumer<NavigationProvider>(
      builder: (ctx, tabsData, _) => BottomNavigationBar(
        onTap: (index) => tabsData.currentIndex = index,
        currentIndex: tabsData.currentIndex,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(CommunityMaterialIcons.compass_outline),
            title: Text('Главная'),
          ),
          const BottomNavigationBarItem(
            icon: Icon(CommunityMaterialIcons.newspaper_variant_outline),
            title: Text('Новости'),
          ),
          const BottomNavigationBarItem(
            icon: Icon(CommunityMaterialIcons.account),
            title: Text('Аккаунт'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print('rebuildbar');
    return ThemeSwitchingArea(
      child: Builder(
        builder: (context) => Scaffold(
          appBar: AppBar(
            titleSpacing: 0.0,
            title: Container(
              width: 165,
              height: 60,
              child: const Badge(
                  child: const Text(
                    'СКФ МТУСИ',
                    style: TextStyle(fontWeight: FontWeight.w400),
                  ),
                  value: 'version 0.1'),
            ),
            actions: <Widget>[
              ThemeSwitch(),
              IconButton(
                icon: const Icon(CommunityMaterialIcons.cog_outline),
                onPressed: () {},
              ),
            ],
          ),
          drawer: AppDrawer(),
          body: _buildBody(),
          bottomNavigationBar: _buildBottomNavigationBar(context),
        ),
      ),
    );
  }
}

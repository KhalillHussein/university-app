import 'package:flutter/material.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:provider/provider.dart';
import 'package:animated_theme_switcher/animated_theme_switcher.dart';

import '../../providers/index.dart';
import '../tabs/index.dart';

import '../widgets/app_drawer.dart';
import '../widgets/badge.dart';
import '../widgets/theme_switch.dart';

class NavigationScreen extends StatefulWidget {
  @override
  _NavigationScreenState createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  final List<Map<String, Object>> _pages = [
    {
      'title': 'Главная',
      'page': HomeTab(),
    },
    {
      'title': 'Новости',
      'page': NewsTab(),
    },
    {
      'title': 'Авторизация',
      'page': AuthTab(),
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
        items: const [
          BottomNavigationBarItem(
            icon: Icon(CommunityMaterialIcons.compass_outline),
            label: 'Главная',
          ),
          BottomNavigationBarItem(
            icon: Icon(CommunityMaterialIcons.newspaper_variant_outline),
            label: 'Новости',
          ),
          BottomNavigationBarItem(
            icon: Icon(CommunityMaterialIcons.account),
            label: 'Аккаунт',
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ThemeSwitchingArea(
      child: Builder(
        builder: (context) => Scaffold(
          appBar: AppBar(
            titleSpacing: 0.0,
            title: SizedBox(
              width: 165,
              height: 60,
              child: const Badge(
                value: 'version 0.1',
                child: Text(
                  'СКФ МТУСИ',
                  style: TextStyle(fontWeight: FontWeight.w400),
                ),
              ),
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

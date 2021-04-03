import 'package:flutter/material.dart';
import 'package:mtusiapp/repositories/auth.dart';
import 'package:provider/provider.dart';
import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../providers/index.dart';
import '../../ui/pages/index.dart';
import '../tabs/index.dart';
import '../widgets/index.dart';

class NavigationScreen extends StatefulWidget {
  @override
  _NavigationScreenState createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  final List<Map<String, Object>> _pages = [
    {
      'title': 'Новости',
      'page': NewsTab(),
    },
    {
      'title': 'Расписание',
      'page': TimetablePage(),
    },
    {
      'title': 'Авторизация',
      'page': AuthorizationPage(),
    },
    {
      'title': 'Основные сведения',
      'page': AboutTab(),
    },
  ];

  final GlobalKey<InnerDrawerState> innerDrawerKey =
      GlobalKey<InnerDrawerState>();

  @override
  Widget build(BuildContext context) {
    return ThemeSwitchingArea(
      child: Builder(
        builder: (context) => InnerDrawer(
          key: innerDrawerKey,
          onTapClose: true,
          swipeChild: true,
          boxShadow: [
            BoxShadow(
              color: Colors.grey[500].withOpacity(0.8),
            ),
          ],
          offset: IDOffset.horizontal(0.6),
          colorTransitionChild: Colors.white30,
          colorTransitionScaffold: Theme.of(context).splashColor,
          leftAnimationType: InnerDrawerAnimation.linear,
          leftChild: AppDrawer(),
          scaffold: Scaffold(
            appBar: _buildAppBar(),
            body: _buildBody(),
            bottomNavigationBar: _buildBottomNavigationBar(context),
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      leading: IconButton(
        splashRadius: 20,
        icon: Icon(Icons.menu),
        onPressed: () => innerDrawerKey.currentState.toggle(),
      ),
      title: Consumer2<NavigationProvider, AuthRepository>(
          builder: (ctx, tabData, auth, _) {
        _pages[2]['title'] = auth.isAuth ? 'Аккаунт' : 'Авторизация';
        return Text(
          _pages[tabData.currentIndex]['title'],
        );
      }),
      actions: <Widget>[
        ThemeSwitch(),
        IconButton(
          splashRadius: 20,
          icon: const Icon(MdiIcons.cogOutline),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildBody() {
    return Consumer2<NavigationProvider, AuthRepository>(
        builder: (ctx, tabData, auth, _) {
      _pages[2]['page'] = auth.isAuth ? AccountPage() : AuthorizationPage();
      return _pages[tabData.currentIndex]['page'];
    });
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    return Consumer<NavigationProvider>(
      builder: (ctx, tabsData, _) => BottomNavigationBar(
        onTap: (index) => tabsData.currentIndex = index,
        currentIndex: tabsData.currentIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              MdiIcons.newspaperVariantOutline,
              size: 28,
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
              size: 28,
            ),
            label: 'Аккаунт',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              MdiIcons.accessPoint,
              size: 28,
            ),
            label: 'О нас',
          ),
        ],
      ),
    );
  }
}

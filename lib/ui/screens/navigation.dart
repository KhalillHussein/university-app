import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mtusiapp/ui/screens/index.dart';

import 'package:provider/provider.dart';
import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:quick_actions/quick_actions.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../providers/index.dart';
import '../../repositories/index.dart';
import '../../util/index.dart';
import '../tabs/index.dart';
import '../widgets/index.dart';

class NavigationScreen extends StatefulWidget {
  static const route = '/';

  @override
  _NavigationScreenState createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  List<Widget> _tabs(AuthRepository model, TimetableRepository model2) {
    return [
      NewsTab(),
      if (model2.isUserSetCategory) CalendarScreen(),
      if (!model2.isUserSetCategory) TimetableTab(),
      if (model.isAuth) AccountTab(),
      if (!model.isAuth) AuthTab(),
      AboutTab(),
    ];
  }

  @override
  void initState() {
    // Reading app shortcuts input
    final QuickActions quickActions = QuickActions();
    quickActions.initialize((type) {
      switch (type) {
        case 'timetable':
          context.read<NavigationProvider>().currentIndex =
              Tabs.timetable.index;
          break;
        case 'account':
          context.read<NavigationProvider>().currentIndex = Tabs.auth.index;
          break;
        case 'phone_book':
          Navigator.pushNamed(context, PhoneBookScreen.route);
          break;
        default:
          context.read<NavigationProvider>().currentIndex = Tabs.news.index;
      }
    });
    Future.delayed(Duration.zero, () async {
      // Setting app shortcuts
      await quickActions.setShortcutItems(<ShortcutItem>[
        ShortcutItem(
          type: 'timetable',
          localizedTitle: 'Расписание',
          icon: 'action_timetable',
        ),
        ShortcutItem(
          type: 'account',
          localizedTitle: 'Аккаунт',
          icon: 'action_account',
        ),
        ShortcutItem(
          type: 'phone_book',
          localizedTitle: 'Телефонная книга',
          icon: 'action_phone',
        ),
      ]);
    });
    showStartDialog();
    super.initState();
  }

  void showStartDialog() {
    SharedPreferences.getInstance().then((prefs) {
      final bool showDialog = prefs.getBool('dialog_open') ?? true;
      if (showDialog) {
        //shows dialog for one time only
        Future.delayed(const Duration(milliseconds: 100), () {
          _showDialog(context);
          prefs.setBool('dialog_open', false);
        });
      }
    });
  }

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).appBarTheme.color,
        title: Text(
          'Добро пожаловать!',
        ).scalable(),
        content: MarkdownBody(
          data: Doc.doc.welcomeMessage,
          listItemCrossAxisAlignment: MarkdownListItemCrossAxisAlignment.start,
          styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
            blockSpacing: 10,
            strong: GoogleFonts.rubikTextTheme(Theme.of(context).textTheme)
                .bodyText2
                .copyWith(
                  fontWeight: FontWeight.w900,
                ),
            p: GoogleFonts.rubikTextTheme(Theme.of(context).textTheme)
                .bodyText2,
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: Navigator.of(ctx).pop,
            child: const Text(
              'ЗАКРЫТЬ',
            ).scalable(),
          ),
        ],
      ),
    );
  }

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
    return Consumer3<NavigationProvider, AuthRepository, TimetableRepository>(
      builder: (ctx, tabData, model, model2, _) =>
          _tabs(model, model2)[tabData.currentIndex],
    );
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

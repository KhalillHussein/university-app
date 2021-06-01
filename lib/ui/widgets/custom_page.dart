import 'dart:async';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:big_tip/big_tip.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:row_collection/row_collection.dart';

import '../../repositories/index.dart';
import '../../util/index.dart';
import '../screens/settings.dart';
import 'index.dart';

/// Centered [CircularProgressIndicator] widget.
Widget get _loadingIndicator =>
    const Center(child: CircularProgressIndicator());

/// Function which handles reloading [QueryModel] models.
Future<void> onRefresh(BuildContext context, BaseRepository repository) {
  final Completer<void> completer = Completer<void>();
  repository.refreshData().then((_) {
    if (repository.loadingFailed) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            elevation: 0,
            behavior: SnackBarBehavior.floating,
            backgroundColor: Theme.of(context).errorColor,
            content: Row(
              children: [
                Icon(
                  Icons.error,
                  color: Theme.of(context).primaryColor,
                ),
                Separator.spacer(),
                Expanded(
                  child: Text(
                    repository.errorMessage,
                    softWrap: true,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ).scalable(),
                ),
              ],
            ),
            duration: const Duration(seconds: 1),
          ),
        );
    }
    completer.complete();
  });
  return completer.future;
}

/// Basic screen.
/// Used when the desired page doesn't have reloading.
class SimplePage extends StatelessWidget {
  final String title;
  final Widget body, fab, leading, titleWidget;
  final List<Widget> actions;
  final double elevation;

  const SimplePage({
    this.title,
    @required this.body,
    this.elevation,
    this.titleWidget,
    this.leading,
    this.fab,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: leading,
        elevation: elevation,
        title: titleWidget ??
            Text(
              title,
              // style: GoogleFonts.rubik(fontWeight: FontWeight.w500),
              // style: Theme.of(context).textTheme.headline6,
            ),
        actions: actions,
      ),
      body: body,
      floatingActionButton: fab,
    );
  }
}

/// Basic page which has reloading properties.
/// It uses the [BlankPage] widget inside it.
class ReloadableSimplePage<T extends BaseRepository> extends StatelessWidget {
  final String title;
  final List<Widget> actions;
  final Widget body, fab, placeholder, leading, titleWidget;
  final double elevation;

  const ReloadableSimplePage({
    this.title,
    @required this.body,
    this.titleWidget,
    this.elevation,
    this.actions,
    this.placeholder,
    this.fab,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    return SimplePage(
      actions: actions,
      title: title,
      elevation: elevation,
      titleWidget: titleWidget,
      fab: fab,
      leading: leading,
      body: Consumer<T>(
        builder: (context, model, child) => RefreshIndicator(
          onRefresh: () => onRefresh(context, model),
          child: model.isLoading
              ? placeholder ?? _loadingIndicator
              : model.loadingFailed
                  ? ChangeNotifierProvider.value(
                      value: model,
                      child: ConnectionError<T>(),
                    )
                  : body,
        ),
      ),
    );
  }
}

class ReloadableTab<T extends BaseRepository> extends StatelessWidget {
  final String title;
  final List<Widget> actions;
  final Widget body, fab, placeholder, leading, titleWidget;
  final double elevation;

  const ReloadableTab({
    this.title,
    @required this.body,
    this.titleWidget,
    this.elevation,
    this.actions,
    this.placeholder,
    this.fab,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    return SimplePage(
      actions: actions ??
          [
            ThemeSwitchIcon(),
            IconButton(
              splashRadius: 20,
              tooltip: 'Настройки',
              icon: const Icon(MdiIcons.cogOutline),
              onPressed: () =>
                  Navigator.pushNamed(context, SettingsScreen.route),
            ),
          ],
      title: title,
      elevation: elevation,
      titleWidget: titleWidget,
      fab: fab,
      leading: IconButton(
        splashRadius: 20,
        tooltip: 'Меню',
        icon: const Icon(MdiIcons.menu),
        onPressed: Scaffold.of(context).openDrawer,
      ),
      body: Consumer<T>(
        builder: (context, model, child) => RefreshIndicator(
          onRefresh: () => onRefresh(context, model),
          child: model.isLoading
              ? placeholder ?? _loadingIndicator
              : model.loadingFailed
                  ? ChangeNotifierProvider.value(
                      value: model,
                      child: ConnectionError<T>(),
                    )
                  : body,
        ),
      ),
    );
  }
}

class SimpleTab<T extends BaseRepository> extends StatelessWidget {
  final String title;
  final List<Widget> actions;
  final Widget body, fab, placeholder, leading, titleWidget;
  final double elevation;

  const SimpleTab({
    this.title,
    @required this.body,
    this.titleWidget,
    this.elevation,
    this.actions,
    this.placeholder,
    this.fab,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    return SimplePage(
      actions: actions ??
          [
            ThemeSwitchIcon(),
            IconButton(
              splashRadius: 20,
              icon: const Icon(MdiIcons.cogOutline),
              onPressed: () =>
                  Navigator.pushNamed(context, SettingsScreen.route),
            ),
          ],
      title: title,
      elevation: elevation,
      titleWidget: titleWidget,
      fab: fab,
      leading: IconButton(
        splashRadius: 20,
        tooltip: 'Меню',
        icon: const Icon(MdiIcons.menu),
        onPressed: Scaffold.of(context).openDrawer,
      ),
      body: Consumer<T>(
        builder: (context, model, child) => model.isLoading
            ? placeholder ?? _loadingIndicator
            : model.loadingFailed
                ? ChangeNotifierProvider.value(
                    value: model,
                    child: ConnectionError<T>(),
                  )
                : body,
      ),
    );
  }
}

/// Widget used to display a connection error message.
/// It allows user to reload the page with a simple button.
class ConnectionError<T extends BaseRepository> extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<T>(
      builder: (context, model, child) => BigTip(
        title: Text(
          'При загрузке данных что-то пошло не так. Проверьте подключение к интернету',
          style: GoogleFonts.rubikTextTheme(
            Theme.of(context).textTheme,
          ).headline5,
          textScaleFactor: 0.6,
        ).scalable(),
        subtitle: TextButton(
          onPressed: () async => onRefresh(context, model),
          child: Text(
            'ПОВТОРИТЬ',
            style: GoogleFonts.rubikTextTheme(Theme.of(context).textTheme)
                .subtitle2
                .copyWith(
                  color: Theme.of(context).accentColor,
                  fontWeight: FontWeight.w600,
                ),
          ).scalable(),
        ),
        child: const Icon(Icons.cloud_off),
      ),
    );
  }
}

class Message<T extends BaseRepository> extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<T>(
      builder: (ctx, model, _) => MaterialBanner(
        backgroundColor: Theme.of(context).brightness == Brightness.light
            ? Colors.blue[50]
            : k04dp,
        leading: Icon(
          MdiIcons.cloudOffOutline,
          size: 22,
          color: Theme.of(context).disabledColor,
        ),
        actions: [
          TextButton(
            onPressed: () => onRefresh(context, model),
            child: Text(
              'ОБНОВИТЬ',
              style: GoogleFonts.rubikTextTheme(Theme.of(context).textTheme)
                  .subtitle1
                  .copyWith(
                    color: Theme.of(context).accentColor,
                    fontWeight: FontWeight.w600,
                  ),
              textScaleFactor: 0.85,
            ).scalable(),
          ),
        ],
        content: FittedBox(
          child: Text(
            'Сохраненная копия за ${DateFormat('yyyy.MM.dd - HH:mm', 'Ru').format(model.timestamp)}',
            style:
                GoogleFonts.rubikTextTheme(Theme.of(context).textTheme).caption,
            textScaleFactor: 1.2,
          ).scalable(),
        ),
      ),
    );
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

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
  final Widget body, fab, leading, titleWidget, bottomNavigationBar;
  final PreferredSizeWidget bottom;
  final List<Widget> actions;
  final double elevation;

  const SimplePage({
    this.title,
    this.bottom,
    @required this.body,
    this.elevation,
    this.titleWidget,
    this.leading,
    this.fab,
    this.actions,
    this.bottomNavigationBar,
  }) : assert(title != null || titleWidget != null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: leading,
        elevation: elevation,
        title: titleWidget ?? Text(title),
        actions: actions,
        bottom: bottom,
      ),
      bottomNavigationBar: bottomNavigationBar,
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
  final Widget body,
      fab,
      placeholder,
      leading,
      titleWidget,
      bottomNavigationBar;
  final double elevation;
  final PreferredSizeWidget bottom;

  const ReloadableSimplePage({
    this.title,
    @required this.body,
    this.titleWidget,
    this.elevation,
    this.actions,
    this.placeholder,
    this.fab,
    this.leading,
    this.bottom,
    this.bottomNavigationBar,
  }) : assert(title != null || titleWidget != null);

  @override
  Widget build(BuildContext context) {
    return SimplePage(
      actions: actions,
      title: title,
      elevation: elevation,
      titleWidget: titleWidget,
      fab: fab,
      leading: leading,
      bottom: bottom,
      bottomNavigationBar: bottomNavigationBar,
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
  final PreferredSizeWidget bottom;
  final double elevation;

  const ReloadableTab({
    this.title,
    @required this.body,
    this.titleWidget,
    this.elevation,
    this.bottom,
    this.actions,
    this.placeholder,
    this.fab,
    this.leading,
  }) : assert(title != null || titleWidget != null);

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
      bottom: bottom,
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
  final PreferredSizeWidget bottom;
  final double elevation;

  const SimpleTab({
    this.title,
    @required this.body,
    this.titleWidget,
    this.elevation,
    this.actions,
    this.placeholder,
    this.fab,
    this.bottom,
    this.leading,
  }) : assert(title != null || titleWidget != null);

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
      bottom: bottom,
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

class ReloadablePaginatedTab<M, T extends BaseRepository>
    extends StatelessWidget {
  final String title;
  final List<Widget> actions;
  final Widget fab, placeholder, leading, titleWidget;
  final Function itemBuilder;
  final VoidCallback onTryAgain;
  final PagingController pagingController;
  final PreferredSizeWidget bottom;
  final double elevation;

  const ReloadablePaginatedTab({
    this.title,
    this.titleWidget,
    this.elevation,
    this.bottom,
    this.actions,
    this.onTryAgain,
    this.placeholder,
    this.fab,
    this.leading,
    @required this.itemBuilder,
    @required this.pagingController,
  }) : assert(title != null || titleWidget != null);

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
      bottom: bottom,
      leading: IconButton(
        splashRadius: 20,
        tooltip: 'Меню',
        icon: const Icon(MdiIcons.menu),
        onPressed: Scaffold.of(context).openDrawer,
      ),
      body: Consumer<T>(
        builder: (context, model, child) => RefreshIndicator(
          onRefresh: () => onRefresh(context, model),
          child: RawScrollbar(
            thickness: 3.0,
            child: PagedListView<int, M>(
              pagingController: pagingController,
              builderDelegate: PagedChildBuilderDelegate<M>(
                itemBuilder: itemBuilder,
                firstPageProgressIndicatorBuilder: (_) => placeholder,
                firstPageErrorIndicatorBuilder: (_) => ConnectionError<T>(),
                newPageErrorIndicatorBuilder: (_) => PageErrorIndicator(
                  onTryAgain: onTryAgain,
                ),
                newPageProgressIndicatorBuilder: (_) => Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Center(
                    child: SizedBox(
                      width: 25,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(
                              Theme.of(context).textTheme.caption.color),
                          strokeWidth: 5,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
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
          'Что-то пошло не так',
          style: GoogleFonts.rubikTextTheme(
            Theme.of(context).textTheme,
          ).headline6,
        ).scalable(),
        subtitle: Column(
          children: [
            Text(
              'При загрузке данных произошла ошибка.\nПовторите попытку позже.',
              textScaleFactor: 0.9,
              style: GoogleFonts.rubikTextTheme(Theme.of(context).textTheme)
                  .bodyText2
                  .copyWith(height: 1.3),
            ).scalable(),
            Separator.spacer(),
            TextButton(
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
          ],
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

class PageErrorIndicator extends StatelessWidget {
  final VoidCallback onTryAgain;

  const PageErrorIndicator({
    this.onTryAgain,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTryAgain,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Text(
              'Что-то пошло не так. Повторите попытку.',
            ).scalable(),
            Separator.spacer(space: 6),
            const Icon(
              Icons.refresh,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
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
                  message,
                  softWrap: true,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          duration: const Duration(seconds: 1),
        ),
      );
  }
}

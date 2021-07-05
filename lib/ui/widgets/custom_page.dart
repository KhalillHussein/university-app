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
import '../views/screens/settings.dart';
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
class BasicPage extends StatelessWidget {
  final String title;
  final Widget body, fab, leading, titleWidget, bottomNavigationBar;
  final PreferredSizeWidget bottom;
  final List<Widget> actions;
  final double elevation;

  const BasicPage({
    this.title,
    this.bottom,
    this.body,
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

class BasicTab extends StatelessWidget {
  final String title;
  final Widget body, fab, leading, titleWidget, bottomNavigationBar;
  final PreferredSizeWidget bottom;
  final List<Widget> actions;
  final double elevation;

  const BasicTab({
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
        leading: IconButton(
          splashRadius: 20,
          tooltip: 'Меню',
          icon: const Icon(MdiIcons.menu),
          onPressed: Scaffold.of(context).openDrawer,
        ),
        elevation: elevation,
        title: titleWidget ?? Text(title),
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
        bottom: bottom,
      ),
      bottomNavigationBar: bottomNavigationBar,
      body: body,
      floatingActionButton: fab,
    );
  }
}

/// Extension on Basic page which has reloading properties.
/// It uses the [BlankPage] widget inside it.
extension CustomPage on BasicPage {
  Widget reloadablePage<T extends BaseRepository>({Widget placeholder}) {
    return BasicPage(
      title: title,
      titleWidget: titleWidget,
      actions: actions,
      fab: fab,
      leading: leading,
      bottomNavigationBar: bottomNavigationBar,
      elevation: elevation,
      bottom: bottom,
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

  Widget reloadableTab<T extends BaseRepository>(
    BuildContext context, {
    Widget placeholder,
  }) {
    return BasicTab(
      title: title,
      titleWidget: titleWidget,
      actions: actions,
      fab: fab,
      leading: leading,
      bottomNavigationBar: bottomNavigationBar,
      elevation: elevation,
      bottom: bottom,
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

  Widget contentTab<T extends BaseRepository>(
    BuildContext context, {
    Widget placeholder,
  }) {
    return BasicTab(
      title: title,
      titleWidget: titleWidget,
      actions: actions,
      fab: fab,
      leading: leading,
      bottomNavigationBar: bottomNavigationBar,
      elevation: elevation,
      bottom: bottom,
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

  Widget paginatedTab<M, T extends BasePaginationRepository>(
    BuildContext context,
    Function itemBuilder,
    PagingController pagingController, {
    Widget placeholder,
  }) {
    return BasicTab(
      title: title,
      titleWidget: titleWidget,
      actions: actions,
      fab: fab,
      leading: leading,
      bottomNavigationBar: bottomNavigationBar,
      elevation: elevation,
      bottom: bottom,
      body: Consumer<T>(
        builder: (context, model, child) => RefreshIndicator(
          onRefresh: () => onRefresh(context, model),
          child: RawScrollbar(
            thickness: 3.0,
            interactive: false,
            child: PagedListView<int, M>(
              pagingController: pagingController,
              builderDelegate: PagedChildBuilderDelegate<M>(
                itemBuilder: itemBuilder,
                firstPageProgressIndicatorBuilder: (_) => placeholder,
                firstPageErrorIndicatorBuilder: (_) => ConnectionError<T>(),
                newPageErrorIndicatorBuilder: (_) => PageErrorIndicator<T>(),
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
              'При загрузке данных произошла ошибка.\nПовторите попытку позже',
              textScaleFactor: 1.2,
              style: GoogleFonts.rubikTextTheme(Theme.of(context).textTheme)
                  .caption
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

class Message<T extends BaseDbRepository> extends StatelessWidget {
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
            ),
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

class PageErrorIndicator<T extends BasePaginationRepository>
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.read<T>().retryLastFailedRequest();
      },
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
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../repositories/index.dart';
import 'index.dart';

/// Centered [CircularProgressIndicator] widget.
Widget get _loadingIndicator =>
    const Center(child: CircularProgressIndicator());

///Showing a placeholder preview of content before the data gets loaded.
Widget get _skeletonLoading => SkeletonLoading();

/// Function which handles reloading [QueryModel] models.
Future<void> _onRefresh(BuildContext context, BaseRepository repository) {
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
            content: Text(
              repository.errorMessage,
              style: Theme.of(context).snackBarTheme.contentTextStyle,
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
  final Widget body, fab;
  final List<Widget> actions;

  const SimplePage({
    @required this.title,
    @required this.body,
    this.fab,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        titleSpacing: 0,
        actions: actions,
      ),
      body: body,
      floatingActionButton: fab,
    );
  }
}

/// Basic page which has reloading properties.
/// It uses the [BlankPage] widget inside it.
class ReloadablePage<T extends BaseRepository> extends StatelessWidget {
  final String title;
  final Widget body, fab;
  final List<Widget> actions;

  const ReloadablePage({
    @required this.title,
    @required this.body,
    this.fab,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return SimplePage(
      title: title,
      fab: fab,
      body: Consumer<T>(
        builder: (context, model, child) => RefreshIndicator(
          onRefresh: () => _onRefresh(context, model),
          child: model.isLoading
              ? _loadingIndicator
              : model.loadingFailed
                  ? SliverFillRemaining(
                      child: ChangeNotifierProvider.value(
                        value: model,
                        child: ConnectionError<T>(),
                      ),
                    )
                  : SafeArea(bottom: false, child: body),
        ),
      ),
    );
  }
}

///
class BasicPage<T extends BaseRepository> extends StatelessWidget {
  final String title;
  final Widget body, fab;

  const BasicPage({
    @required this.title,
    @required this.body,
    this.fab,
  });

  @override
  Widget build(BuildContext context) {
    return SimplePage(
      title: title,
      fab: fab,
      body: Consumer<T>(
        builder: (context, model, child) => model.isLoading
            ? _loadingIndicator
            : model.loadingFailed
                ? ChangeNotifierProvider.value(
                    value: model,
                    child: ConnectionError<T>(),
                  )
                : SafeArea(bottom: false, child: body),
      ),
    );
  }
}

class BasicPageNoScaffold<T extends BaseRepository> extends StatelessWidget {
  final Widget body;

  const BasicPageNoScaffold({
    @required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<T>(
      builder: (context, model, child) => model.isLoading
          ? _loadingIndicator
          : model.loadingFailed
              ? ChangeNotifierProvider.value(
                  value: model,
                  child: ConnectionError<T>(),
                )
              : SafeArea(bottom: false, child: body),
    );
  }
}

class ListViewPage<T extends BaseRepository> extends StatelessWidget {
  final String title;
  final int itemCount;
  final Object buildFunction;

  const ListViewPage({
    this.title,
    @required this.itemCount,
    @required this.buildFunction,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<T>(
      builder: (context, model, child) => RefreshIndicator(
        onRefresh: () => _onRefresh(context, model),
        child: model.isLoading
            ? _skeletonLoading
            : model.loadingFailed && itemCount <= 1
                ? ChangeNotifierProvider.value(
                    value: model,
                    child: ConnectionError<T>(),
                  )
                : Scrollbar(
                    thickness: 3.0,
                    child: ScrollablePositionedList.builder(
                      // physics: BouncingScrollPhysics(),
                      // key: PageStorageKey(title),
                      addAutomaticKeepAlives: false,
                      itemCount: itemCount,
                      itemBuilder: buildFunction,
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
      builder: (context, model, child) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'При загрузке данных что-то пошло не так',
              style: Theme.of(context).textTheme.headline6,
              textScaleFactor: 0.85,
            ),
            const SizedBox(height: 5),
            TextButton(
              onPressed: () async => _onRefresh(context, model),
              style: TextButton.styleFrom(
                primary: Theme.of(context).accentColor,
              ),
              child: const Text(
                'Повторить попытку',
                textScaleFactor: 1.1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BasicPageNoScaffoldWithMessage<T extends BaseRepository>
    extends StatelessWidget {
  final Widget body;

  const BasicPageNoScaffoldWithMessage({
    @required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<T>(
      builder: (context, model, child) => RefreshIndicator(
        onRefresh: () => _onRefresh(context, model),
        child: model.isLoading
            ? _loadingIndicator
            : model.loadingFailed
                ? ChangeNotifierProvider.value(
                    value: model,
                    child: ConnectionError<T>(),
                  )
                : model.databaseFetch
                    ? Column(
                        children: [
                          ChangeNotifierProvider.value(
                            value: model,
                            child: Message<T>(),
                          ),
                          Expanded(
                            child: SafeArea(bottom: false, child: body),
                          ),
                        ],
                      )
                    : SafeArea(bottom: false, child: body),
      ),
    );
  }
}

class Message<T extends BaseRepository> extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<T>(
      builder: (ctx, model, _) => Container(
        width: double.infinity,
        padding: EdgeInsets.all(15.0),
        color: Theme.of(context).cardTheme.color,
        alignment: Alignment.center,
        child: RichText(
          text: TextSpan(
            children: [
              WidgetSpan(
                child: Padding(
                  padding: const EdgeInsets.only(right: 5.0),
                  child: Icon(
                    MdiIcons.alertOutline,
                    size: 20,
                    color: Theme.of(context).primaryIconTheme.color,
                  ),
                ),
              ),
              TextSpan(
                text:
                    'Сохраненная копия за ${DateFormat('yyyy.MM.dd - HH:mm', 'Ru').format(model.timestamp)}',
                style: TextStyle(
                  color: Theme.of(context).primaryIconTheme.color,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../repositories/base.dart';

/// Centered [CircularProgressIndicator] widget.
Widget get _loadingIndicator =>
    Center(child: const CircularProgressIndicator());

/// Function which handles reloading [QueryModel] models.
Future<void> _onRefresh(BuildContext context, BaseRepository repository) {
  final Completer<void> completer = Completer<void>();

  repository.refreshData().then((_) {
    if (repository.loadingFailed) {
      Scaffold.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            elevation: 0,
            behavior: SnackBarBehavior.floating,
            backgroundColor: Theme.of(context).snackBarTheme.backgroundColor,
            content: Text(
              'Невозможно получить данные. Проверьте подключение к интернету',
              style:
                  TextStyle(color: Theme.of(context).textTheme.bodyText2.color),
            ),
            duration: Duration(seconds: 1),
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
        centerTitle: true,
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
    this.title,
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
  final AppBar appBar;
  final Widget body, fab;

  const BasicPageNoScaffold({
    this.appBar,
    @required this.body,
    this.fab,
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

/// This widget is used for all tabs inside the app.
/// Its main features are connection error handling.
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
            ? _loadingIndicator
            : model.loadingFailed
                ? ChangeNotifierProvider.value(
                    value: model,
                    child: ConnectionError<T>(),
                  )
                : ListView.builder(
                    // key: PageStorageKey(title),
                    addAutomaticKeepAlives: false,
                    itemCount: itemCount,
                    itemBuilder: buildFunction,
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
            const Text('При загрузке данных произошла ошибка'),
            const SizedBox(height: 5),
            FlatButton(
              onPressed: () async => _onRefresh(context, model),
              textColor: Theme.of(context).accentColor,
              child:
                  model.isLoading ? _loadingIndicator : const Text('Повторить'),
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mtusiapp/util/index.dart';
import 'package:provider/provider.dart';

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
class ReloadableSimplePage<T extends BaseRepository> extends StatelessWidget {
  final String title;
  final Widget body, fab;

  const ReloadableSimplePage({
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
        builder: (context, model, child) => RefreshIndicator(
          onRefresh: () => _onRefresh(context, model),
          child: model.isLoading
              ? _loadingIndicator
              : model.loadingFailed
                  ? ChangeNotifierProvider.value(
                      value: model,
                      child: ConnectionError<T>(),
                    )
                  : SafeArea(bottom: false, child: body),
        ),
      ),
    );
  }
}

///Do refactoring
class ReloadableScreen<T extends BaseRepository> extends StatelessWidget {
  final Widget body;

  const ReloadableScreen({
    @required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<T>(
      builder: (context, model, child) => RefreshIndicator(
        onRefresh: () => _onRefresh(context, model),
        child: model.isLoading
            ? _skeletonLoading
            : model.loadingFailed
                ? ChangeNotifierProvider.value(
                    value: model,
                    child: ConnectionError<T>(),
                  )
                : model.databaseFetch
                    ? Stack(
                        children: [
                          body,
                          Positioned(
                            bottom: 0.0,
                            left: 0.0,
                            right: 0.0,
                            child: ChangeNotifierProvider.value(
                              value: model,
                              child: Message<T>(),
                            ),
                          ),
                        ],
                      )
                    : body,
      ),
    );
  }
}

///Do refactoring
class Screen<T extends BaseRepository> extends StatelessWidget {
  final Widget body;

  const Screen({
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
              : model.databaseFetch
                  ? Stack(
                      children: [
                        body,
                        Positioned(
                          bottom: 0.0,
                          left: 0.0,
                          right: 0.0,
                          child: ChangeNotifierProvider.value(
                            value: model,
                            child: Message<T>(),
                          ),
                        ),
                      ],
                    )
                  : body,
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
              style: Theme.of(context).textTheme.subtitle1,
            ),
            const SizedBox(height: 5),
            TextButton(
              onPressed: () async => _onRefresh(context, model),
              style: TextButton.styleFrom(
                primary: Theme.of(context).accentColor,
                textStyle: Theme.of(context).textTheme.button.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              child: const Text(
                'Повторить попытку',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Message<T extends BaseRepository> extends StatefulWidget {
  @override
  _MessageState<T> createState() => _MessageState<T>();
}

class _MessageState<T extends BaseRepository> extends State<Message<T>> {
  bool isShowing = true;

  @override
  Widget build(BuildContext context) {
    return isShowing
        ? Consumer<T>(
            builder: (ctx, model, _) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.blue[50]
                  : k04dp,
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        WidgetSpan(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Icon(
                              MdiIcons.cloudOffOutline,
                              size: 18,
                              color: Theme.of(context).disabledColor,
                            ),
                          ),
                        ),
                        TextSpan(
                            text:
                                'Сохраненная копия за ${DateFormat('yyyy.MM.dd - HH:mm', 'Ru').format(model.timestamp)}',
                            style: Theme.of(context).textTheme.caption),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () => setState(
                      () => isShowing = false,
                    ),
                    child: Text(
                      'Скрыть',
                    ),
                  ),
                ],
              ),
            ),
          )
        : SizedBox();
  }
}

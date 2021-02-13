import 'dart:async';

import 'package:flutter/material.dart';
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
      Scaffold.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            elevation: 0,
            behavior: SnackBarBehavior.floating,
            backgroundColor: Theme.of(context).snackBarTheme.backgroundColor,
            content: Text(
              'Невозможно получить данные. ${repository.errorMessage}',
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
  final Widget body;

  const BasicPageNoScaffold({
    this.appBar,
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
            : model.loadingFailed
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
              style: Theme.of(context).textTheme.bodyText1,
            ),
            const SizedBox(height: 5),
            FlatButton(
              onPressed: () async => _onRefresh(context, model),
              textColor: Theme.of(context).accentColor,
              child: const Text('Повторить попытку'),
            ),
          ],
        ),
      ),
    );
  }
}
//
// class ListViewPaginatedPage<T extends BaseRepository> extends StatelessWidget {
//   final String title;
//   final int itemCount;
//   final Object buildFunction;
//
//   const ListViewPaginatedPage({
//     this.title,
//     @required this.itemCount,
//     @required this.buildFunction,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<T>(
//       builder: (context, model, child) => RefreshIndicator(
//         onRefresh: () => _onRefresh(context, model),
//         child: model.isLoading
//             ? _skeletonLoading
//             : model.loadingFailed && itemCount == 0
//                 ? ChangeNotifierProvider.value(
//                     value: model,
//                     child: ConnectionError<T>(),
//                   )
//                 : Scrollbar(
//                     thickness: 3.0,
//                     child: NotificationListener<ScrollNotification>(
//                       onNotification: (ScrollNotification notification) {
//                         _handleScrollNotification(notification, model);
//                         return false;
//                       },
//                       child: ScrollablePositionedList.builder(
//                         // physics: BouncingScrollPhysics(),
//                         // key: PageStorageKey(title),
//                         itemPositionsListener: ItemPositionsListener.create(),
//                         addAutomaticKeepAlives: false,
//                         itemCount:
//                             model.hasReachedMax() ? itemCount : itemCount + 1,
//                         itemBuilder: buildFunction,
//                       ),
//                     ),
//                   ),
//       ),
//     );
//   }
//
//   void _handleScrollNotification(ScrollNotification notification, T model) {
//     if (notification is ScrollEndNotification) {
//       if (notification.metrics.extentAfter == 0) {
//         if (!model.hasReachedMax()) {
//           model.nextPage();
//         }
//       }
//     }
//   }
// }

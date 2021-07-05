import 'package:flutter/foundation.dart';

import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../services/base.dart';

enum Status { loading, error, loaded, dbFetching }

/// This class serves as the building blocks of a repository.
///
/// A repository has the purpose to load and parse the data

abstract class BaseRepository<T extends BaseService> with ChangeNotifier {
  /// System to perform data manipulation operations
  final T service;

  /// Status regarding data loading capabilities
  Status _status;

  /// String that saves information about the latest error
  String errorMessage;

  /// Call the [loadData] method upon object initialization.
  ///
  /// Default is set to [true].
  final bool autoLoad;

  BaseRepository(this.service, {this.autoLoad = true}) {
    if (autoLoad) {
      startLoading();
      loadData();
    }
  }

  /// Overridable method, used to load the model's data.
  Future<void> loadData();

  /// Reloads model's data, calling [loadData] once again.
  Future<void> refreshData() => loadData();

  bool get isLoading => _status == Status.loading;

  bool get loadingFailed => _status == Status.error;

  bool get isLoaded => _status == Status.loaded;

  /// Signals that information is being downloaded.
  void startLoading() {
    _status = Status.loading;
    notifyListeners();
  }

  /// Signals that information has been downloaded.
  void finishLoading() {
    _status = Status.loaded;
    notifyListeners();
  }

  /// Signals that there has been an error downloading data.
  void receivedError(String error) {
    _status = Status.error;
    errorMessage = error;
    debugPrint(error);
    notifyListeners();
  }
}

///repository that realize database fetching logic.
abstract class BaseDbRepository<T extends BaseService>
    extends BaseRepository<T> {
  ///Timestamp that used as the last date data loading
  DateTime timestamp;

  BaseDbRepository(T service, {autoLoad = true})
      : super(service, autoLoad: autoLoad);

  bool get databaseFetch => _status == Status.dbFetching;

  ///Overridable method, used to load model's data from database
  Future<void> loadDataFromDb();

  ///Signals that information loading from database
  void databaseFetching() {
    _status = Status.dbFetching;
    notifyListeners();
  }
}

///Base repository that realize server pagination logic.
abstract class BasePaginationRepository<M, T extends BaseService>
    extends BaseRepository<T> {
  PagingState pagingState = PagingState<int, M>();
  final int limit = 12;
  List<M> itemList;
  int pageIndex;

  BasePaginationRepository(T service, {autoLoad = true})
      : super(service, autoLoad: autoLoad);

  void retryLastFailedRequest() => loadData();

  void nextPage() {
    final bool isLastPage = itemList.length < limit;
    if (isLastPage) {
      appendPage(itemList, null);
    } else {
      final nextPageKey = pageIndex + 1;
      appendPage(itemList, nextPageKey);
    }
  }

  @override
  void receivedError(String error) {
    pagingState = PagingState<int, M>(
      error: error,
      itemList: pagingState.itemList,
      nextPageKey: pageIndex,
    );
    errorMessage = error;
    _status = Status.error;
    notifyListeners();
    debugPrint(error);
  }

  @override
  Future<void> refreshData() {
    pagingState = PagingState<int, M>(
      nextPageKey: pageIndex = 1,
    );
    return loadData();
  }

  void appendPage(List<M> newItems, int nextPageKey) {
    final List<M> previousItems = pagingState.itemList ?? [];
    final List<M> newList = {...previousItems, ...itemList}.toList();
    pagingState = PagingState<int, M>(
      itemList: newList,
      nextPageKey: nextPageKey,
    );
    notifyListeners();
  }
}

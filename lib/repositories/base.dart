import 'package:flutter/foundation.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../services/base.dart';

enum Status { loading, error, loaded, dbFetching }

/// This class serves as the building blocks of a repository.
///
/// A repository has the purpose to load and parse the data

abstract class BaseRepository<T extends BaseService> with ChangeNotifier {
  DateTime timestamp;

  /// System to perform data manipulation operations
  final T service;

  /// Status regarding data loading capabilities
  Status _status;

  /// String that saves information about the latest error
  String errorMessage;

  BaseRepository(this.service);

  /// Overridable method, used to load the model's data.
  Future<void> loadData();

  /// Reloads model's data, calling [loadData] once again.
  Future<void> refreshData() => loadData();

  bool get isLoading => _status == Status.loading;
  bool get loadingFailed => _status == Status.error;
  bool get isLoaded => _status == Status.loaded;
  bool get databaseFetch => _status == Status.dbFetching;

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

  void databaseFetching() {
    _status = Status.dbFetching;
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

abstract class BasePaginatedRepository<M, T extends BaseService>
    with ChangeNotifier {
  /// System to perform data manipulation operations
  final T service;

  List<M> dataList;

  int pageIndex;

  PagingState pagingState = PagingState<int, M>();

  BasePaginatedRepository(this.service);

  /// Overridable method, used to load the model's data.
  Future<void> loadData();

  void refreshData() {
    pagingState = PagingState<int, M>(
      nextPageKey: pageIndex = 1,
    );
    loadData();
  }

  void retryLastFailedRequest() => loadData();

  /// The current error, if any. Initially `null`.
  dynamic get error => pagingState.error;

  set error(dynamic newError) {
    pagingState = PagingState<int, M>(
      error: newError,
      itemList: pagingState.itemList,
      nextPageKey: pageIndex,
    );
    debugPrint(newError);
    notifyListeners();
  }
}

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../services/base.dart';

enum Status { loading, error, loaded }

/// This class serves as the building blocks of a repository.
///
/// A repository has the purpose to load and parse the data

abstract class BaseRepository<T extends BaseService> with ChangeNotifier {
  final BuildContext context;

  /// System to perform data manipulation operations
  final T service;

  /// Status regarding data loading capabilities
  Status _status;

  /// String that saves information about the latest error
  String _errorMessage;

  BaseRepository(this.service, [this.context]) {
    startLoading();
    loadData();
  }

  /// Overridable method, used to load the model's data.
  Future<void> loadData({int pageIndex, int limit});

  /// Reloads model's data, calling [loadData] once again.
  Future<void> refreshData() => loadData();

  String get errorMessage => _errorMessage;

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
    _errorMessage = error;
    debugPrint(error);
    notifyListeners();
  }
}

import '../services/base.dart';

/// This class serves as the building blocks of a [sqflite] database repository.
///
/// A repository has the purpose to perform basic operations with the [sqflite] database
abstract class BaseDbRepository<T, S extends DbBaseService> {
  /// System to perform data manipulation operations
  final S service;

  BaseDbRepository(this.service) {
    init();
  }

  /// Overridable method, used for initialization of the [sqflite] database
  Future<void> init();

  /// Overridable method, used for insert operations with the table
  Future<void> insert(T record);

  /// Overridable method, used for update data in the table
  Future<void> update(T record);

  /// Overridable method, used for delete data in the table
  Future<void> delete(T record);

  /// Overridable method, used for get data from the table
  Future<List<Object>> getRecords();
}

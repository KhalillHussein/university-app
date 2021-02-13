/// Class that creates [sql] query and mapping data for save in the database.
abstract class DbBaseService<T> {
  //queries
  String get createTableQuery;

  //abstract mapping method
  Map<String, dynamic> toMap(T object);
}

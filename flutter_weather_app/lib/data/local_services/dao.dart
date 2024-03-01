abstract class IDao<T>{

  String get createTableQuery;
  String get tableName;

  T fromMap(Map<String, dynamic> query);
  List<T> fromList(List<Map<String,dynamic>> query);
  T toMap(T object);

  Future<List<T>> getAllData(String id);
  Future<int> insertDB(Map<String,dynamic> entity);
  Future<int> updateDB(T entity);
  Future<int> deleteDB();
  Future<int> insertAll(List<T> list);
  Future<void> checkIdExistence(List<T> list);
  Future<void> checkIdExistenceForOne(T entity);
}
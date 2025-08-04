
import 'package:surrealdb/surrealdb.dart';

final class QueryResults {
  List<dynamic> _data;

  QueryResults(List<dynamic> data): _data = data;

  int get length => _data.length;

  QueryResult<dynamic> operator [](int index) => QueryResult<dynamic>(_data[index]);
  QueryResult<dynamic> get first => this[0];

  QueryResult<T> getQueryResult<T>(int index) => QueryResult<T>(_data[index]);
  QueryResult<T> getFirst<T>() => getQueryResult<T>(0);
}

extension SurrealResultHelpersObject on Object {
  QueryResults toQueryResults() => QueryResults(this as List<dynamic>);
}

extension SurrealResultHelpersDynamicList on List<dynamic> {
  QueryResults toQueryResults() => QueryResults(this);
}

final class QueryResult<T> {
  Map<String, dynamic> _data;

  QueryResult(dynamic data): _data = data as Map<String, dynamic>;
  QueryResult._error(): _data = {'result': null, 'status': 'ERROR', 'time': '0s'};

  String get time => _data['time'] as String;
  String get status => _data['status'] as String;
  bool get isOk => status == 'OK';
  T get result => _data['result'] as T;
}

extension SurrealResultExtractions on Object {
  QueryResult<T> extractQuery<T>(int index) =>
    toQueryResults().getQueryResult<T>(index);
}

extension SurrealQueries on SurrealDB {
  Future<QueryResult<T>> singleQuery<T>(
    String query, [
    Map<String, Object?>? vars,
  ]) async {
    final result = await this.query(query, vars);
    if (result == null) {
      return QueryResult<T>._error();
    }

    return result.extractQuery<T>(0);
  }
}

// typedef QueryResult<T> = ({T? result, String status, String time});


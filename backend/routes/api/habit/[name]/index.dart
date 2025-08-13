import 'dart:convert';
import 'package:dart_frog/dart_frog.dart';
import 'package:habit_tracker_api/db/types.dart';
// import 'package:habit_tracker_api/models/habit.dart';
import 'package:surrealdb/surrealdb.dart';

typedef SurrealObject = Map<String, dynamic>;

Future<Response> onRequest(RequestContext context, String name) async {
  final decodedName = utf8.decode(base64.decode(name));
  final method = context.request.method.value;

  return switch (method) {
    'GET' => await onGetHabit(context, decodedName),
    _ => Response(statusCode: 400, body: 'Unsupported method'),
  };
}



Future<Response> onGetHabit(RequestContext context, String habitName) async {
  print("Getting habit with name '$habitName'");

  final db = await context.read<Future<SurrealDB>>();
  try {
    final queryResult = await db.singleQuery<dynamic>(r'''
      SELECT
          name,
          description,
          (
              SELECT date, value, notes
              FROM logEntry
              WHERE habitId = $parent.id AND deletedAt is NONE
          ) as logEntries
      FROM ONLY habit
      WHERE
          name = $habitName
          AND deletedAt is NONE;
      ''',
      { 'habitName': habitName}
    );

    if (!queryResult.isOk) {
      return Response(
        statusCode: 500,
        body: 'There was a problem with the database.',
      );
    }

    final data = queryResult.result;
    return Response.json(body: data);
  } catch (e) {
    rethrow;
  }
}

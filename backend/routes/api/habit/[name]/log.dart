import 'dart:convert';
import 'package:dart_frog/dart_frog.dart';
import 'package:habit_tracker_api/db/types.dart';
import 'package:habit_tracker_api/helpers/time_helpers.dart';
// import 'package:habit_tracker_api/models/habit.dart';
import 'package:surrealdb/surrealdb.dart';

Future<Response> onRequest(RequestContext context, String name) async {
  final decodedName = utf8.decode(base64.decode(name));
  final method = context.request.method.value;

  return switch (method) {
    'POST' => await onPostLog(context, decodedName),
    _ => Response(statusCode: 400, body: 'Unsupported method'),
  };
}

Future<Response> onPostLog(RequestContext context, String habitName) async {
  try {
    final body = await context.request.json() as Map<String, dynamic>;
    final logDate = (body['date'] as String).toUtcDate();
    final logValue = body['value'] as bool;
    final logNotes = body['notes'] as String;

    // print('Received: $habitName at $logDate with value $logValue; notes: $logNotes');

    final db = await context.read<Future<SurrealDB>>();
    final queryResult = await db.singleQuery<dynamic>(r'''
      LET $habitId = (SELECT VALUE id FROM ONLY habit WHERE name = $habitName);
      UPSERT logEntry
        SET
          habitId = $habitId,
          date = <datetime>$logDate,
          value = $logValue,
          notes = $logNotes
        WHERE habitId = $habitId AND date = <datetime>$logDate;
      ''',
      {
        'habitName': habitName,
        'logDate': logDate.toSurrealDateString(),
        'logValue': logValue,
        'logNotes': logNotes,
      },
    );
    if (queryResult.isOk) {
      return Response(statusCode: 204);
    } else {
      return Response(statusCode: 400, body: 'Failed to add habit history entry');
    }
  } catch (e) {
    return Response(statusCode: 400, body: "It's your fault! $e");
  }
}

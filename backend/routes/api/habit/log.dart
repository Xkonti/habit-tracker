import 'package:dart_frog/dart_frog.dart';
import 'package:habit_tracker_api/db/types.dart';
import 'package:habit_tracker_api/helpers/time_helpers.dart';
import 'package:habit_tracker_api/models/habit_history_entry.dart';
// import 'package:habit_tracker_api/models/habit.dart';
import 'package:surrealdb/surrealdb.dart';

Future<Response> onRequest(RequestContext context) async {
  
  final method = context.request.method.value;

  return switch (method) {
    'POST' => await onPostLog(context),
    _ => Response(statusCode: 400, body: 'Unsupported method'),
  };
}

Future<Response> onPostLog(RequestContext context) async {
  try {
    final body = await context.request.json() as Map<String, dynamic>;
    final habitName = body['habit'] as String;
    final logDate = (body['date'] as String).toUtcDate();
    final logValue = body['value'] as bool;
    final logNotes = body['notes'] as String;

    print('Received: $habitName at $logDate with value $logValue; notes: $logNotes');
    // final logEntry = HabitHistoryEntry(
    //   habitName: habitName,
    //   date: logDate.toUtcDate(),
    //   value: logValue,
    //   notes: logNotes
    // );

    final db = await context.read<Future<SurrealDB>>();
    final queryResult = await db.singleQuery<dynamic>(r'''
      LET $habitId = (SELECT VALUE id FROM ONLY habit WHERE name = $habitName);
      CREATE logEntry SET habitId = $habitId, date = <datetime>$logDate, value = $logValue, notes = $logNotes;
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
    return Response(body: 'Test OK');
  } catch (e) {
    return Response(statusCode: 400, body: "It's your fault! $e");
  }
}

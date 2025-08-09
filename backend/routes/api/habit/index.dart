import 'package:dart_frog/dart_frog.dart';
import 'package:habit_tracker_api/db/types.dart';
// import 'package:habit_tracker_api/models/habit.dart';
import 'package:surrealdb/surrealdb.dart';

typedef SurrealObject = Map<String, dynamic>;

Future<Response> onRequest(RequestContext context) async {
  
  final method = context.request.method.value;

  return switch (method) {
    'GET' => await onGetHabits(context),
    'POST' => await onPostHabit(context),
    _ => Response(statusCode: 400, body: 'Unsupported method'),
  };
}



Future<Response> onGetHabits(RequestContext context) async {
  final db = await context.read<Future<SurrealDB>>();
  try {
    final queryResult = await db.singleQuery<List<dynamic>>('''
      SELECT date, value, notes, habitId.{id, name, description} as habit
      FROM logEntry
      WHERE deletedAt is NONE AND date > time::now() - 11d AND date < time::now();
      '''
    );

    if (!queryResult.isOk)  {
      return Response(
        statusCode: 500,
        body: 'There was a problem with the database.',
      );
    }

    final data = queryResult.result.cast<SurrealObject>();
    final habitMap = <String, SurrealObject>{};

    for (final logEntryData in data) {
      final logDate = logEntryData['date'];
      final logValue = logEntryData['value'];
      final logNotes = logEntryData['notes'];
      final habitData = logEntryData['habit'] as SurrealObject;
      final habitId = habitData['id'] as String;

      // If habit data not yet extracted, do it now
      if (!habitMap.containsKey(habitId)) {
        final habitName = habitData['name'];
        final habitDescription = habitData['description'];
        final newHabitData = {
          'name': habitName,
          'description': habitDescription,
          'history': <SurrealObject>[],
        };
        habitMap[habitId] = newHabitData;
      }

      final newEntryData = {
        'date': logDate,
        'value': logValue,
        'notes': logNotes,
      };
      (habitMap[habitId]!['history'] as List<SurrealObject>)
        .add(newEntryData);
    }

    return Response.json(body: habitMap.values.toList());
    
  } catch (e) {
    rethrow;
    // print('Error: $e');
    // return Response(
    //   statusCode: 500,
    //   body: 'There was a big problem with the database.',
    // );
  }
}

Future<Response> onPostHabit(RequestContext context) async {
  try {
    final body = await context.request.json() as SurrealObject;
    final habitName = body['name'] as String;
    final habitDescription = body['description'] as String;

    final db = await context.read<Future<SurrealDB>>();
    final queryResult = await db.singleQuery<dynamic>(
      r'CREATE habit SET name = $name, description = $description;',
      { 'name': habitName, 'description': habitDescription},
    );
    if (queryResult.isOk) {
      return Response(statusCode: 204);
    } else {
      return Response(statusCode: 400, body: 'Failed to create habit');
    }

  } catch (_) {
    return Response(statusCode: 400, body: "It's your fault!");
  }
}

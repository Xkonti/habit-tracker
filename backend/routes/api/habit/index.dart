import 'dart:math';

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
    final results = await db.query('''
      SELECT id, name, description FROM habit WHERE deletedAt is NONE;
      SELECT date, value, notes, habitId
        FROM logEntry
        WHERE deletedAt is NONE AND date > time::now() - 3001d AND date < time::now();
      '''
    );
    if (results == null) {
      return Response(
        statusCode: 500,
        body: 'There was a problem with the database.',
      );
    }
    final queryResults = results.toQueryResults();
    final habitsQuery = queryResults.getQueryResult<List<dynamic>>(0);
    final logEntriesQuery = queryResults.getQueryResult<List<dynamic>>(1);

    if (!habitsQuery.isOk || !logEntriesQuery.isOk)  {
      return Response(
        statusCode: 500,
        body: 'There was a problem with the database.',
      );
    }

    // Create a map of habits
    final habitMap = <String, SurrealObject>{};
    final habitsData = habitsQuery.result.cast<SurrealObject>();
    for (final habitData in habitsData) {
      final habitId = habitData['id'] as String;
      final habitName = habitData['name'];
      final habitDescription = habitData['description'];
      final newHabitData = {
        'name': habitName,
        'description': habitDescription,
        'history': <SurrealObject>[],
      };
      habitMap[habitId] = newHabitData;
    }

    final logEntriesData = logEntriesQuery.result.cast<SurrealObject>();
    for (final logEntryData in logEntriesData) {
      final habitId = logEntryData['habitId'] as String;
      if (!habitMap.containsKey(habitId)) continue;

      final logDate = logEntryData['date'];
      final logValue = logEntryData['value'];
      final logNotes = logEntryData['notes'];

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

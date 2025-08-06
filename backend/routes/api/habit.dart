import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:habit_tracker_api/models/habit.dart';
import 'package:habit_tracker_api/db/types.dart';
// import 'package:surrealdb/surrealdb.dart';

final List<Habit> habits = [
  Habit(createdAt: DateTime.now(), name: 'Stream every day'),
  // Habit(createdAt: DateTime.now(), name: 'Read technical book for 30m'),
  // Habit(createdAt: DateTime.now(), name: 'Work on a side project for 30m'),
  // Habit(createdAt: DateTime.now(), name: 'Go for a walk'),
];

Future<Response> onRequest(RequestContext context) async {
  
  final method = context.request.method.value;

  return switch (method) {
    'GET' => await onGetHabits(context),
    'POST' => await onPostHabit(context),
    _ => Response(statusCode: 400, body: 'Unsupported method'),
  };
}



Future<Response> onGetHabits(RequestContext context) async {
  // final db = await context.read<Future<SurrealDB>>();
  try {
    // final queryResult = await db.singleQuery<List<dynamic>>('RETURN [1, 2, 3]');

    // if (queryResult.isOk)  {
    //   print('Result is ok: ${queryResult.result}');
    // } else {
    //   print('Result was not ok');
    // }

    return Response.json(body: habits);

  } catch (_) {
    rethrow;
  }
}

Future<Response> onPostHabit(RequestContext context) async {
  try {
    final body = await context.request.json() as Map<String, dynamic>;
    final habitName = body['name'] as String;
    // TODO: Check if habit with same name exists first
    habits.add(Habit(createdAt: DateTime.now(), name: habitName));
    return Response(statusCode: 204);
  } catch (_) {
    return Response(statusCode: 400, body: "It's your fault!");
  }
}

import 'package:dart_frog/dart_frog.dart';
import 'package:habit_tracker_api/db/types.dart';
// import 'package:habit_tracker_api/models/habit.dart';
import 'package:surrealdb/surrealdb.dart';

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
    final queryResult = await db.singleQuery<List<dynamic>>(
      'SELECT name, description FROM habit WHERE deletedAt = NONE ORDER BY name COLLATE ASC;',
    );

    if (queryResult.isOk)  {
      final data = queryResult.result;

      // final habits = data
      //   .map((h) {
      //     final habit = h as Map<String, dynamic>;
      //     return HabitResponseDto(
      //       name: habit['name'] as String,
      //       description: habit['description'] as String,
      //     );
      //   })
      //   .toList();
      // return Response.json(body: habits);
      return Response.json(body: data);
    } else {
      return Response(
        statusCode: 500,
        body: 'There was a problem with the database.',
      );
    }
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
    final body = await context.request.json() as Map<String, dynamic>;
    final habitName = body['name'] as String;
    // TODO: Accept description

    final db = await context.read<Future<SurrealDB>>();
    final queryResult = await db.singleQuery<List<dynamic>>(
      r'CREATE habit SET name = $name;',
      { 'name': habitName},
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

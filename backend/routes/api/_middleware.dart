import 'package:dart_frog/dart_frog.dart';
import 'package:habit_tracker_api/services/surrealdb.dart';

Handler middleware(Handler handler) {
  return handler.use(databaseProvider());
}

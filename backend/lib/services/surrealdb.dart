import 'package:dart_frog/dart_frog.dart' as frog;
import 'package:surrealdb/surrealdb.dart';


SurrealDB? _db;

/// Provides a [SurrealDB] instance.
frog.Middleware databaseProvider() {
  return frog.provider<Future<SurrealDB>>(
    (_) async => _db ?? await createAndConnect(),
  );
}

/// Creates a new [SurrealDB] instance and connects to it
Future<SurrealDB> createAndConnect() async {
  final db = SurrealDB('ws://jabba.lan:14831/rpc')
    ..connect();
  await db.wait();

  await db.signin(
    user: '...', 
    pass: '...',
    namespace: 'habit',
    database: 'dev',
  );

  _db = db;
  return db;
}

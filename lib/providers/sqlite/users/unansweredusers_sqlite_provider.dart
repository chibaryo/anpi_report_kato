import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sqflite/sqflite.dart';

import '../../../models/firestoreuser.dart';

part 'unansweredusers_sqlite_provider.g.dart';

@riverpod
class UnansweredUsersSQLiteNotifier extends _$UnansweredUsersSQLiteNotifier {
  late Database database; // Declare the database instance
  bool isDatabaseInitialized = false; // Track initialization status

  @override
  Future<List<Map<String, dynamic>>> build() async {
    await initializeDatabase(); // Initialize the database
    return await fetchUsers(); // Fetch users after initialization
  } 

  // Initialize the database
  Future<void> initializeDatabase() async {
    if (!isDatabaseInitialized) {
      database = await openDatabase(
        "users.db",
        version: 1,
        onCreate: (Database db, int version) async {
          await db.execute(
            'CREATE TABLE Users (uid TEXT PRIMARY KEY, username TEXT, email TEXT, accountStatus INTEGER, password TEXT, isOnline BOOL, created_at TEXT, updated_at TEXT, lastActive_at TEXT)',
          );
        },
      );
      isDatabaseInitialized = true; // Mark database as initialized
    }
  }

  // Fetch all users from the database
  Future<List<Map<String, dynamic>>> fetchUsers() async {
    return await database.rawQuery('SELECT * FROM Users');
  }

/*    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'users.db');
    database = await openDatabase(path, version: 1,
      onCreate: (Database db, int version) async {
        await db.execute(
          'CREATE TABLE Users (uid TEXT PRIMARY KEY, username TEXT, email TEXT, accountStatus INTEGER, password TEXT, isOnline BOOL, created_at TEXT, updated_at TEXT, lastActive_at TEXT)'
        );
      }
    );

    final usersList = await database.rawQuery('SELECT * FROM Users');

    return usersList;
  }*/

  // Add
  Future<void> addUser(String uid, FirestoreUser user) async {
    try {
      if (!isDatabaseInitialized) {
        await initializeDatabase(); // Ensure database is initialized
      }

      await database.insert(
        "Users",
        {
          'uid': "xxxxxxxx",
          'username': user.username,
          'email': user.email,
          'password': user.password,
          'isOnline': true,
          'created_at': user.createdAt?.toIso8601String(),
          'updated_at': user.updatedAt?.toIso8601String(),
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      //print("Error");
      rethrow;
    }
  }
}

/*
Future<List<Map<String, dynamic>>> fetchUsersFromSQLiteProvider(FetchUsersFromSQLiteProviderRef ref, String notiId) async {
  var databasesPath = await getDatabasesPath();
  String path = join(databasesPath, 'users.db');
  Database database = await openDatabase(path, version: 1,
    onCreate: (Database db, int version) async {
      await db.execute(
        'CREATE TABLE Users (uid TEXT PRIMARY KEY, username TEXT, email TEXT, accountStatus INTEGER, password TEXT, isOnline BOOL, created_at TEXT, updated_at TEXT, lastActive_at TEXT)'
      );
    }
  );

  return null;
}
*/
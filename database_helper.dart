import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/event.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'events.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE registered_events(
        id INTEGER PRIMARY KEY,
        title TEXT,
        description TEXT,
        date TEXT,
        time TEXT,
        location TEXT,
        imageUrl TEXT
      )
    ''');
  }

  Future<int> insertEvent(Event event) async {
    Database db = await database;
    return await db.insert('registered_events', event.toMap());
  }

  Future<List<Event>> getEvents() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query('registered_events');
    return List.generate(maps.length, (i) {
      return Event.fromMap(maps[i]);
    });
  }

  Future<int> deleteEvent(int id) async {
    Database db = await database;
    return await db.delete(
      'registered_events',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}


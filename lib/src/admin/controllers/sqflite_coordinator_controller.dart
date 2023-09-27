import 'package:sqflite/sqflite.dart';

abstract class SqfliteCoordinatorControler{
  static const _databaseName = "coordinator.db";
  static Database? database;
  Future startDatabase() async{
    if(database !=null){
      return database;
    }
    database = await _openOrCreateDatabase();
    return database;
  }

  Future _openOrCreateDatabase() async{
    var databasePath = await getDatabasesPath();
    String path = databasePath + _databaseName;
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version)async{
    await db.execute('''CREATE TABLE IF NOT EXISTS coordinator(
          name TEXT, course TEXT, email TEXT, uid TEXT, password TEXT
      )''');
    await db.execute('''CREATE TABLE IF NOT EXISTS notification(
      uid TEXT, title TEXT, body TEXT, link TEXT, coordinator TEXT, course TEXT, initialDate INT, finalDate INT
    )''');
    await db.execute('''CREATE TABLE IF NOT EXISTS message(
      text TEXT, type TEXT, name TEXT, uid TEXT, date TEXT
    )''');
    await db.execute('''CREATE TABLE IF NOT EXISTS enquetes(
      uid TEXT, course TEXT, discipline TEXT, questions TEXT, coordinator TEXT, initialDate TEXT, finalDate TEXT
    )''');
  }

  Future deleteDatabase() async{
    Database db = await startDatabase();
    await db.delete('coordinator');
    await db.delete('notification');
    await db.delete('message');
    await db.delete('enquetes');
  }
}
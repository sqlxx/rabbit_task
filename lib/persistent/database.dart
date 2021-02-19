import 'dart:async';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBProvider {
  DBProvider._();

  static final DBProvider db = DBProvider._();
  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "TestDB.db"); 

    return await openDatabase(path, version: 1, onOpen:(db) {},
      onCreate: (Database db, int version) async {
        await db.execute("create table Client("
          "id INTEGER primary key,"
          "first_name TEXT,"
          "last_name TEXT,"
          "blocked BIT"
        ")");
      }
    );
  }

  

}

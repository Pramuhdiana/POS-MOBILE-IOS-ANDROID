// ignore_for_file: depend_on_referenced_packages, avoid_print

import 'dart:io';
import 'package:e_shop/database/model_notification_dummy.dart';
import 'package:path/path.dart';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DbNotifDummy {
  static Database? _database;
  static final DbNotifDummy db = DbNotifDummy._();

  DbNotifDummy._();

  Future<Database> get database async {
    // If database exists, return database
    if (_database != null) return _database!;

    // If database don't exists, create one
    _database = await initDB();

    return _database!;
  }

  // Create the database and the Employee table
  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'NOTIFDUMMY.db');

    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute('''
      CREATE TABLE allnotifdummy(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT,
          body TEXT,
          status INTEGER,
          created_at TEXT
                   )''');
    });
  }

  saveNotifDummy(ModelNotificationDummy newNotif) async {
    print('notif masuk database');
    final db = await database;
    final res = await db.insert('allnotifdummy', newNotif.toJson());
    return res;
  }

  // Delete all employees
  Future<int> deleteAllnotif() async {
    final db = await database;
    final res = await db.rawDelete('DELETE FROM allnotifdummy');

    return res;
  }

  Future<List<ModelNotificationDummy>> getAllNotif(int status) async {
    final db = await database;
    // final res = await db
    //     .rawQuery('SELECT * FROM allcrm WHERE alamat!=?', ['null']);
    final res = await db
        .rawQuery('SELECT * FROM allnotifdummy WHERE status=?', [status]);

    List<ModelNotificationDummy> list = res.isNotEmpty
        ? res
            .map((c) => ModelNotificationDummy.fromJson(c, String: null))
            .toList()
        : [];

    return list;
  }

  // Update an item by id
  Future<int> updateAllnotifByid(idNotif) async {
    final db = await database;

    final data = {'status': 2};

    final result = await db
        .update('allnotifdummy', data, where: "id = ?", whereArgs: [idNotif]);
    return result;
  }

  // Future<List<ModelNotificationDummy>> getAllNotifByStatus(int status) async {
  //   final db = await database;
  //   // final res = await db
  //   //     .rawQuery('SELECT * FROM allcrm WHERE alamat!=?', ['null']);
  //   final res = await db
  //       .rawQuery('SELECT * FROM allnotifdummy WHERE status=?', [status]);

  //   List<ModelNotificationDummy> list = res.isNotEmpty
  //       ? res
  //           .map((c) => ModelNotificationDummy.fromJson(c, String: null))
  //           .toList()
  //       : [];

  //   return list;
  // }
}

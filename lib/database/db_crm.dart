// ignore_for_file: depend_on_referenced_packages, avoid_print

import 'dart:io';
import 'package:e_shop/database/model_crm.dart';
import 'package:e_shop/global/global.dart';
import 'package:path/path.dart';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DbCRM {
  static Database? _database;
  static final DbCRM db = DbCRM._();

  DbCRM._();

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
    final path = join(documentsDirectory.path, 'CRM.db');

    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute('''
      CREATE TABLE allcrm(
          id INTEGER PRIMARY KEY,
          user_id INTEGER,
          customer_id INTEGER,
          aktivitas_id INTEGER,
          visit_id INTEGER,
          hasil_aktivitas INTEGER,
          nominal_hasil INTEGER,
          nomor_invoice TEXT,
          detail TEXT,
          tanggal_aktivitas TEXT,
          created_at TEXT,
          nama_toko TEXT
                   )''');
    });
  }

  createAllcrm(ModelCRM newCrm) async {
    final db = await database;
    final res = await db.insert('allcrm', newCrm.toJson());
    print('crm masuk database');
    return res;
  }

  // Delete all employees
  Future<int> deleteAllcrm() async {
    final db = await database;
    final res = await db.rawDelete('DELETE FROM allcrm');

    return res;
  }

  //Delete by id (untuk cart)
  Future<int> deleteAllcrmByid(int? id) async {
    final db = await database;

    final res = await db.delete('allcrm', where: "id = ?", whereArgs: [id]);
    print(res);
    print('delete items toko berhasil');
    return res;
  }

  //update by id
  // Future<int> updateAllitemsByid(id) async {
  //   final db = await database;
  //   final res =
  //       await db.update();

  //   return res;
  // }

  // Update an item by id
  Future<int> updateAllcrmByname(String? name, int? qty) async {
    final db = await database;

    final data = {'qty': qty};

    final result =
        await db.update('allcrm', data, where: "name = ?", whereArgs: [name]);
    return result;
  }

  Future<List<ModelCRM>> getAllcrm() async {
    final db = await database;
    final res = await db.rawQuery("SELECT * FROM allcrm");

    List<ModelCRM> list =
        res.isNotEmpty ? res.map((c) => ModelCRM.fromJson(c)).toList() : [];

    return list;
  }

  Future<List<ModelCRM>> getAllcrmByDate(fromDate, toDate) async {
    final db = await database;
    final res = await db.rawQuery(
        'SELECT * FROM allcrm WHERE tanggal_aktivitas >=? and tanggal_aktivitas <=?',
        [fromDate, toDate]);

    List<ModelCRM> list =
        res.isNotEmpty ? res.map((c) => ModelCRM.fromJson(c)).toList() : [];

    return list;
  }
  //  .rawQuery("SELECT * FROM $tableName where $columnDate >= '2021-01-01' and
  //   $columnDate <= '2022-10-10' ");

  Future<List<ModelCRM>> getAllCrmById(aktivitasId) async {
    final db = await database;
    final res = await db.rawQuery(
        'SELECT * FROM allcrm WHERE aktivitas_id=? and user_id=? ORDER BY tanggal_aktivitas DESC',
        [aktivitasId, sharedPreferences!.getString('id')]);
    // final res = await db.rawQuery("SELECT * FROM allcrm");

    List<ModelCRM> list =
        res.isNotEmpty ? res.map((c) => ModelCRM.fromJson(c)).toList() : [];

    return list;
  }

  Future<List<ModelCRM>> getCountCrmById(
      aktivitasId, idcustomer, userId) async {
    final db = await database;
    final res = await db.rawQuery(
        'SELECT * FROM allcrm WHERE aktivitas_id=? and customer_id =? and user_id=?',
        [aktivitasId, idcustomer, userId]);
    // final res = await db.rawQuery("SELECT * FROM allcrm");

    List<ModelCRM> list =
        res.isNotEmpty ? res.map((c) => ModelCRM.fromJson(c)).toList() : [];

    return list;
  }
}

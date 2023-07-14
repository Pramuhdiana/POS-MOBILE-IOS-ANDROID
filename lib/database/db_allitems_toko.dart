// ignore_for_file: depend_on_referenced_packages, avoid_print

import 'dart:io';
import 'package:e_shop/database/model_allitems_toko.dart';
import 'package:path/path.dart';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DbAllitemsToko {
  static Database? _database;
  static final DbAllitemsToko db = DbAllitemsToko._();

  DbAllitemsToko._();

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
    final path = join(documentsDirectory.path, 'ALLITEMSTOKO.db');

    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute('''
      CREATE TABLE allitemstoko(
          id INTEGER,
          name TEXT,
          slug TEXT,
          image_name TEXT,
          description TEXT,
          price INTEGER,
          category_id TEXT,
          posisi_id INTEGER,
          customer_id INTEGER,
          kode_refrensi TEXT,
          sales_id INTEGER,
          brand_id INTEGER,
          qty INTEGER,
          status_titipan INTEGER,
          keterangan_barang TEXT
         
          )''');
    });
  }

  createAllitemsToko(ModelAllitemsToko newAllitemsToko) async {
    final db = await database;
    final res = await db.insert('allitemstoko', newAllitemsToko.toJson());
    return res;
  }

  // Delete all employees
  Future<int> deleteAllitemsToko() async {
    print("delete all items toko berhasil");
    final db = await database;
    final res = await db.rawDelete('DELETE FROM allitemstoko');

    return res;
  }

  //Delete by id (untuk cart)
  Future<int> deleteAllitemsTokoByid(int? id) async {
    final db = await database;

    final res =
        await db.delete('allitemstoko', where: "id = ?", whereArgs: [id]);
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
  Future<int> updateAllitemsTokoByname(String? name, int? qty) async {
    final db = await database;

    final data = {'qty': qty};

    final result = await db
        .update('allitemstoko', data, where: "name = ?", whereArgs: [name]);
    return result;
  }

  //gett all items toko
  Future<List<ModelAllitemsToko>> getAllitemsToko(idtoko) async {
    final db = await database;
    final res = await db.rawQuery(
        'SELECT * FROM allitemstoko WHERE customer_id=? and qty=?',
        [idtoko, 1]);
    // final res = await db.rawQuery("SELECT * FROM allitemstoko");

    List<ModelAllitemsToko> list = res.isNotEmpty
        ? res.map((c) => ModelAllitemsToko.fromJson(c)).toList()
        : [];

    return list;
  }

  //gett all items toko
  Future<List<ModelAllitemsToko>> getAllitems() async {
    final db = await database;
    final res =
        await db.rawQuery('SELECT * FROM allitemstoko WHERE qty=?', [1]);
    // final res = await db.rawQuery("SELECT * FROM allitemstoko");

    List<ModelAllitemsToko> list = res.isNotEmpty
        ? res.map((c) => ModelAllitemsToko.fromJson(c)).toList()
        : [];

    return list;
  }

  //gett all items toko with search lot
  Future<List<ModelAllitemsToko>> getAllitemsTokoBylot(idtoko, name) async {
    final db = await database;
    final res = await db.rawQuery(
        'SELECT * FROM allitemstoko WHERE name LIKE ? and qty=? and customer_id=?',
        ['%$name%', 1, idtoko]);
    // final res = await db.rawQuery("SELECT * FROM allitemstoko");

    List<ModelAllitemsToko> list = res.isNotEmpty
        ? res.map((c) => ModelAllitemsToko.fromJson(c)).toList()
        : [];

    return list;
  }
}

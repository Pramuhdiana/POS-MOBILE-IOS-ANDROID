// ignore_for_file: depend_on_referenced_packages, avoid_print

import 'dart:io';
import 'package:e_shop/database/model_allitems.dart';
import 'package:e_shop/global/global.dart';
import 'package:path/path.dart';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DbAllitems {
  static Database? _database;
  static final DbAllitems db = DbAllitems._();

  DbAllitems._();

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
    final path = join(documentsDirectory.path, 'POSMOBILE.db');

    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute('''
      CREATE TABLE allitems(
          id INTEGER PRIMARY KEY,
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

  createAllitems(ModelAllitems newAllitems) async {
    final db = await database;
    final res = await db.insert('allitems', newAllitems.toJson());
    return res;
  }

  // Delete all employees
  Future<int> deleteAllitems() async {
    final db = await database;
    final res = await db.rawDelete('DELETE FROM allitems');
    print("delete all items berhasil");
    return res;
  }

  //Delete by id (untuk cart)
  Future<int> deleteAllitemsByid(int? id) async {
    final db = await database;
    final res = await db.delete('allitems', whereArgs: [id]);

    return res;
  }

  // Update an item by id
  Future<int> updateAllitemsByname(String? name, int? qty) async {
    final db = await database;

    final data = {'qty': qty};

    final result =
        await db.update('allitems', data, where: "name = ?", whereArgs: [name]);
    return result;
  }

  Future<List<ModelAllitems>> getAll() async {
    print('masuk sqlite');
    final db = await database;
    final res = await db.rawQuery('SELECT * FROM allitems');

    List<ModelAllitems> list = res.isNotEmpty
        ? res.map((c) => ModelAllitems.fromJson(c)).toList()
        // ? res.map((c) => ModelAllitems.fromMap(c)).toList()
        : [];

    return list;
  }

  Future<List<ModelAllitems>> getAllitems() async {
    final db = await database;
    final res = await db.rawQuery(
        'SELECT * FROM allitems WHERE sales_id=? and qty=?',
        [sharedPreferences!.getString('id'), 1]);

    List<ModelAllitems> list = res.isNotEmpty
        ? res.map((c) => ModelAllitems.fromJson(c)).toList()
        // ? res.map((c) => ModelAllitems.fromMap(c)).toList()
        : [];

    return list;
  }

  Future<List<ModelAllitems>> getAllitemsBtPage(page, limit) async {
    final db = await database;
    final res = await db.rawQuery(
        'SELECT * FROM allitems WHERE sales_id=? and qty=? LIMIT $limit OFFSET $page',
        [sharedPreferences!.getString('id'), 1]);

    List<ModelAllitems> list = res.isNotEmpty
        ? res.map((c) => ModelAllitems.fromJson(c)).toList()
        // ? res.map((c) => ModelAllitems.fromMap(c)).toList()
        : [];

    return list;
  }

  Future<List<ModelAllitems>> getAllitemsBykode(
      kodeRefrensi, page, limit) async {
    final db = await database;
    final res = await db.rawQuery(
        'SELECT * FROM allitems WHERE sales_id=? and qty=? and kode_refrensi =? LIMIT $limit OFFSET $page',
        [sharedPreferences!.getString('id'), 1, kodeRefrensi]);

    List<ModelAllitems> list = res.isNotEmpty
        ? res.map((c) => ModelAllitems.fromJson(c)).toList()
        // ? res.map((c) => ModelAllitems.fromMap(c)).toList()
        : [];

    return list;
  }

//get with search lot and qty >1
  Future<List<ModelAllitems>> getAllitemsBylot(name) async {
    final db = await database;
    // final res = await db
    //     .query("allitems", where: "name LIKE ?", whereArgs: ['%$name%']);
    final res = await db.rawQuery(
        'SELECT * FROM allitems WHERE name LIKE ? and qty=?', ['%$name%', 1]);

    List<ModelAllitems> list = res.isNotEmpty
        ? res.map((c) => ModelAllitems.fromJson(c)).toList()
        : [];

    return list;
  }

//get with search only lot
  Future<List<ModelAllitems>> getAllitemsByOnlylot(name) async {
    final db = await database;
    // final res = await db
    //     .query("allitems", where: "name LIKE ?", whereArgs: ['%$name%']);
    final res = await db
        .rawQuery('SELECT * FROM allitems WHERE name LIKE ?', ['%$name%']);

    List<ModelAllitems> list = res.isNotEmpty
        ? res.map((c) => ModelAllitems.fromJson(c)).toList()
        : [];

    return list;
  }
}

class DbAllKodekeluarbarang {
  static Database? _database;
  static final DbAllKodekeluarbarang db = DbAllKodekeluarbarang._();

  DbAllKodekeluarbarang._();

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
    final path = join(documentsDirectory.path, 'KELUARBARANG.db');

    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute('''
      CREATE TABLE allkodekeluarbarang(
          kode_refrensi TEXT PRIMARY KEY
                  )''');
    });
  }

  createAllkodekeluarbarang(String kdRef) async {
    Map<String, String> body = {'kode_refrensi': kdRef};
    final db = await database;
    final res = await db.insert(
      'allkodekeluarbarang',
      body,
    );
    return res;
  }

  // Delete all employees
  Future<int> deleteAllkeluarbarang() async {
    final db = await database;
    // final res = await db.rawDelete(
    //     'DELETE FROM allkodekeluarbarang where kode_refrensi not in (select min(kode_refrensi) from allkodekeluarbarang)');
    final res = await db.rawDelete('DELETE FROM allkodekeluarbarang');
    print("delete all items berhasil");

    return res;
  }

  Future<List<Map<String, Object?>>> getAllkeluarbarang() async {
// Future<List<Map<String, Object?>>> getAllinvoicesnumber(idtoko) async {
//     final db = await database;
//     return await db.rawQuery(
//         'SELECT * FROM alltransaksi WHERE user_id=? and customer_id=? ORDER BY invoices_number DESC',
//         [sharedPreferences!.getString('id'), idtoko]);
//   }
    final db = await database;
    return await db.rawQuery(
        'SELECT * FROM allkodekeluarbarang WHERE kode_refrensi!=?', ['null']);
    // return await db.rawQuery('SELECT * FROM allkodekeluarbarang');
  }
}

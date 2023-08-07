// ignore_for_file: depend_on_referenced_packages, avoid_print

import 'dart:io';
import 'package:e_shop/database/model_allitems_retur.dart';
import 'package:path/path.dart';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DbAllitemsRetur {
  static Database? _database;
  static final DbAllitemsRetur db = DbAllitemsRetur._();

  DbAllitemsRetur._();

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
    final path = join(documentsDirectory.path, 'ALLITEMSRETUR.db');

    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute('''
      CREATE TABLE allitemsretur(
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

  createAllitemsRetur(ModelAllitemsRetur newAllitemsRetur) async {
    final db = await database;
    final res = await db.insert('allitemsretur', newAllitemsRetur.toJson());
    return res;
  }

  // Delete all employees
  Future<int> deleteAllitemsRetur() async {
    final db = await database;
    final res = await db.rawDelete('DELETE FROM allitemsretur');

    return res;
  }

  //Delete by id (untuk cart)
  Future<int> deleteAllitemsReturByid(int? id) async {
    final db = await database;

    final res =
        await db.delete('allitemsretur', where: "id = ?", whereArgs: [id]);
    print(res);
    print('delete items retur berhasil');
    return res;
  }

  // Update an item by id
  Future<int> updateAllitemsReturByname(String? name, int? qty) async {
    final db = await database;

    final data = {'qty': qty};

    final result = await db
        .update('allitemsretur', data, where: "name = ?", whereArgs: [name]);
    return result;
  }

  Future<List<ModelAllitemsRetur>> getAllitemsRetur(idtoko) async {
    final db = await database;
    final res = await db
        .rawQuery('SELECT * FROM allitemsretur WHERE customer_id=? ', [idtoko]);
    // final res = await db.rawQuery("SELECT * FROM allitemstoko");

    List<ModelAllitemsRetur> list = res.isNotEmpty
        ? res.map((c) => ModelAllitemsRetur.fromJson(c)).toList()
        : [];

    return list;
  }

  Future<List<ModelAllitemsRetur>> getAllitemsReturByPage(
      idtoko, page, limit) async {
    final db = await database;
    final res = await db.rawQuery(
        'SELECT * FROM allitemsretur WHERE customer_id=? LIMIT $limit OFFSET $page',
        [idtoko]);
    // final res = await db.rawQuery("SELECT * FROM allitemstoko");

    List<ModelAllitemsRetur> list = res.isNotEmpty
        ? res.map((c) => ModelAllitemsRetur.fromJson(c)).toList()
        : [];

    return list;
  }

  Future<List<ModelAllitemsRetur>> getAllRetur() async {
    final db = await database;
    final res = await db.rawQuery('SELECT * FROM allitemsretur');

    List<ModelAllitemsRetur> list = res.isNotEmpty
        ? res.map((c) => ModelAllitemsRetur.fromJson(c)).toList()
        : [];

    return list;
  }

  //gett all items toko with search lot
  Future<List<ModelAllitemsRetur>> getAllitemsReturBylot(idtoko, name) async {
    final db = await database;
    final res = await db.rawQuery(
        'SELECT * FROM allitemsretur WHERE name LIKE ? and customer_id=?',
        ['%$name%', idtoko]);

    List<ModelAllitemsRetur> list = res.isNotEmpty
        ? res.map((c) => ModelAllitemsRetur.fromJson(c)).toList()
        : [];

    return list;
  }
}

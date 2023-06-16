// ignore_for_file: depend_on_referenced_packages, avoid_print, non_constant_identifier_names

import 'dart:io';
import 'package:e_shop/database/model_alltransaksi.dart';
import 'package:e_shop/global/global.dart';
import 'package:path/path.dart';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DbAlltransaksi {
  static Database? _database;
  static final DbAlltransaksi db = DbAlltransaksi._();

  DbAlltransaksi._();

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
    final path = join(documentsDirectory.path, 'ALLTRANSAKSI.db');

    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute('''
      CREATE TABLE alltransaksi(
          invoices_number TEXT,
          user_id INTEGER,
          customer_id INTEGER,
          customer_metier INTEGER,
          jenisform_id INTEGER,
          sales_id INTEGER,
          total INTEGER,
          total_quantity INTEGER,
          total_rupiah TEXT,
          basic_discount INTEGER,
          addesdiskon_rupiah INTEGER,
          rate INTEGER,
          nett INTEGER,
          created_at TEXT,
          updated_at TEXT,
          user TEXT,
          customer TEXT,
          alamat TEXT,
          jenisform TEXT
          )''');
    });
  }

  createAlltransaksi(ModelAlltransaksi newAlltransaksi) async {
    final db = await database;
    final res = await db.insert('alltransaksi', newAlltransaksi.toJson());
    print('insert to database alltransaksi');
    return res;
  }

  // Delete all employees
  Future<int> deleteAlltransaksi() async {
    final db = await database;
    final res = await db.rawDelete('DELETE FROM alltransaksi');
    print("delete all transaksi berhasil");

    return res;
  }

  //Delete by id (untuk cart)
  Future<int> deleteAlltransaksiByid(int? id) async {
    final db = await database;
    final res = await db.delete('alltransaksi', whereArgs: [id]);

    return res;
  }

  //update by id
  // Future<int> updateAllitemsByid(id) async {
  //   final db = await database;
  //   final res =
  //       await db.update();

  //   return res;
  // }

  Future<List<ModelAlltransaksi>> getAlltransaksi(jenis_id) async {
    id;
    final db = await database;
    final res = await db.rawQuery(
        'SELECT * FROM alltransaksi WHERE jenisform_id=? and user_id=? ORDER BY invoices_number DESC',
        [jenis_id, id]);
    // final res = await db.query('allitems', where: '"sales_id" = $id');
    // final res = await db.rawQuery("SELECT * FROM allitems");

    List<ModelAlltransaksi> list = res.isNotEmpty
        ? res.map((c) => ModelAlltransaksi.fromJson(c)).toList()
        // ? res.map((c) => ModelAllitems.fromMap(c)).toList()
        : [];

    return list;
  }

  Future<List<ModelAlltransaksi>> getAlltransaksiBysearch(
      jenis_id, name) async {
    id;
    final db = await database;
    final res = await db.rawQuery(
        'SELECT * FROM alltransaksi WHERE jenisform_id=? and user_id=? and invoices_number LIKE ? ORDER BY invoices_number DESC',
        [jenis_id, id, '%$name%']);
    // final res = await db.query('allitems', where: '"sales_id" = $id');
    // final res = await db.rawQuery("SELECT * FROM alltransaksi");

    List<ModelAlltransaksi> list = res.isNotEmpty
        ? res.map((c) => ModelAlltransaksi.fromJson(c)).toList()
        // ? res.map((c) => ModelAllitems.fromMap(c)).toList()
        : [];

    return list;
  }

//get with search lot
  Future<List<ModelAlltransaksi>> getAlltransaksiBylot(name) async {
    name = '';
    id;
    final db = await database;
    final res = await db
        .query("allitems", where: "name LIKE ?", whereArgs: ['%$name%']);
    // final res = await db.query('allitems', where: '"sales_id" = $id');
    // final res = await db.rawQuery("SELECT * FROM allitems");

    List<ModelAlltransaksi> list = res.isNotEmpty
        ? res.map((c) => ModelAlltransaksi.fromJson(c)).toList()
        : [];

    return list;
  }
}

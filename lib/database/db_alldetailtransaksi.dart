// ignore_for_file: depend_on_referenced_packages, avoid_print, non_constant_identifier_names

import 'dart:io';
import 'package:e_shop/database/model_alldetailtransaksi.dart';
import 'package:e_shop/global/global.dart';
import 'package:path/path.dart';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DbAlldetailtransaksi {
  static Database? _database;
  static final DbAlldetailtransaksi db = DbAlldetailtransaksi._();

  DbAlldetailtransaksi._();

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
    final path = join(documentsDirectory.path, 'ALLDETAILTRANSAKSI.db');

    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute('''
      CREATE TABLE alldetailtransaksi(
        invoices_number TEXT,
          product_id INTEGER,
          user_id INTEGER,
          kode_refrensi TEXT,
          name TEXT,
          price INTEGER,
          description TEXT,
          image_name TEXT,
          keterangan_barang TEXT
          )''');
    });
  }

  createAlldetailtransaksi(
      ModelAlldetailtransaksi newAlldetailtransaksi) async {
    final db = await database;
    final res =
        await db.insert('alldetailtransaksi', newAlldetailtransaksi.toJson());
    print('insert to database alldetailtransaksi');
    return res;
  }

  // Delete all employees
  Future<int> deleteAlldetailtransaksi() async {
    final db = await database;
    final res = await db.rawDelete('DELETE FROM alldetailtransaksi');
    print("delete all detail berhasil");

    return res;
  }

  //Delete by id (untuk cart)
  Future<int> deleteAlldetailtransaksiByid(int? id) async {
    final db = await database;
    final res = await db.delete('alldetailtransaksi', whereArgs: [id]);

    return res;
  }

  Future<List<ModelAlldetailtransaksi>> getAlldetailtransaksi(
      String jenis_id) async {
    id;
    final db = await database;
    final res = await db.rawQuery(
        'SELECT * FROM alldetailtransaksi WHERE invoices_number=? and user_id=?',
        [jenis_id, id]);

    List<ModelAlldetailtransaksi> list = res.isNotEmpty
        ? res.map((c) => ModelAlldetailtransaksi.fromJson(c)).toList()
        // ? res.map((c) => ModelAllitems.fromMap(c)).toList()
        : [];

    return list;
  }

  Future<List<ModelAlldetailtransaksi>> getAlldetailtransaksiBysearch(
      name) async {
    id;
    final db = await database;
    final res = await db.rawQuery(
        'SELECT * FROM alldetailtransaksi WHERE invoices_number LIKE ? and user_id=?',
        ['%$name%', id]);

    List<ModelAlldetailtransaksi> list = res.isNotEmpty
        ? res.map((c) => ModelAlldetailtransaksi.fromJson(c)).toList()
        // ? res.map((c) => ModelAllitems.fromMap(c)).toList()
        : [];

    return list;
  }

//get with search lot
  Future<List<ModelAlldetailtransaksi>> getAlldetailtransaksiBylot(name) async {
    name = '';
    id;
    final db = await database;
    final res = await db.rawQuery(
        'SELECT * FROM alldetailtransaksi WHERE name LIKE ?', ['%$name%']);

    List<ModelAlldetailtransaksi> list = res.isNotEmpty
        ? res.map((c) => ModelAlldetailtransaksi.fromJson(c)).toList()
        : [];

    return list;
  }
}

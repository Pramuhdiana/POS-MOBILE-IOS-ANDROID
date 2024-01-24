// ignore_for_file: depend_on_referenced_packages, avoid_print, non_constant_identifier_names

import 'dart:io';
import 'package:e_shop/database/model_alltransaksi_baru.dart';
import 'package:e_shop/global/global.dart';
import 'package:path/path.dart';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DbAlltransaksiBaru {
  static Database? _database;
  static final DbAlltransaksiBaru db = DbAlltransaksiBaru._();

  DbAlltransaksiBaru._();

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
    final path = join(documentsDirectory.path, 'ALLTRANSAKSIBARU.db');

    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute('''
      CREATE TABLE alltransaksibaru(
          invoices_number TEXT,
          user_id INTEGER,
          customer_id INTEGER,
          customer_metier INTEGER,
          customer_beliberlian TEXT,
          jenisform_id INTEGER,
          sales_id INTEGER,
          total INTEGER,
          total_quantity INTEGER,
          total_rupiah TEXT,
          basic_discount TEXT,
          addesdiskon_rupiah INTEGER,
          rate INTEGER,
          nett INTEGER,
          created_at TEXT,
          updated_at TEXT,
          user TEXT,
          customer TEXT,
          alamat TEXT,
          jenisform TEXT,
          voucher_diskon INTEGER,
          month TEXT,
          year TEXT,
          status TEXT,
          addaddesdiskon_rupiah2 INTEGER
          )''');
    });
  }

  createAlltransaksiBaru(ModelAlltransaksiBaru newAlltransaksiBaru) async {
    final db = await database;
    final res =
        await db.insert('alltransaksibaru', newAlltransaksiBaru.toJson());
    print('insert to database alltransaksibaru');
    return res;
  }

  // Delete all employees
  Future<int> deleteAlltransaksiBaru() async {
    final db = await database;
    final res = await db.rawDelete('DELETE FROM alltransaksibaru');
    print("delete all transaksi new voucher berhasil");

    return res;
  }

  //Delete by id (untuk cart)
  Future<int> deleteAlltransaksiBaruByid(int? id) async {
    final db = await database;
    final res = await db.delete('alltransaksibaru', whereArgs: [id]);

    return res;
  }

  //update by id
  // Future<int> updateAllitemsByid(id) async {
  //   final db = await database;
  //   final res =
  //       await db.update();

  //   return res;
  // }

Future<List<ModelAlltransaksiBaru>> getAll() async {
    final db = await database;
    final res = await db.rawQuery(
        'SELECT * FROM alltransaksibaru');

    List<ModelAlltransaksiBaru> list = res.isNotEmpty
        ? res.map((c) => ModelAlltransaksiBaru.fromJson(c)).toList()
        : [];

    return list;
  }
  Future<List<ModelAlltransaksiBaru>> getAlltransaksiBaru(jenis_id) async {
    final db = await database;
    final res = await db.rawQuery(
        'SELECT * FROM alltransaksibaru WHERE jenisform_id=? and user_id=? ORDER BY invoices_number DESC',
        [jenis_id, sharedPreferences!.getString('id')]);
    // final res = await db.query('allitems', where: '"sales_id" = $id');
    // final res = await db.rawQuery("SELECT * FROM allitems");

    List<ModelAlltransaksiBaru> list = res.isNotEmpty
        ? res.map((c) => ModelAlltransaksiBaru.fromJson(c)).toList()
        // ? res.map((c) => ModelAllitems.fromMap(c)).toList()
        : [];

    return list;
  }

  Future<List<ModelAlltransaksiBaru>> getAllHistoryBaru() async {
    final db = await database;
    final res = await db.rawQuery(
        'SELECT * FROM alltransaksibaru WHERE user_id=?',
        [sharedPreferences!.getString('id')]);
    // final res = await db.query('allitems', where: '"sales_id" = $id');
    // final res = await db.rawQuery("SELECT * FROM allitems");

    List<ModelAlltransaksiBaru> list = res.isNotEmpty
        ? res.map((c) => ModelAlltransaksiBaru.fromJson(c)).toList()
        // ? res.map((c) => ModelAllitems.fromMap(c)).toList()
        : [];

    return list;
  }

  Future<List<ModelAlltransaksiBaru>> getAlltransaksiNominalBaru(year) async {
    final db = await database;
    final res = await db.rawQuery(
        'SELECT * FROM alltransaksibaru WHERE user_id=? and nett !=? and year =? and jenisform_id=?',
        [sharedPreferences!.getString('id'), 0, year, 1]);
    // final res = await db.query('allitems', where: '"sales_id" = $id');
    // final res = await db.rawQuery("SELECT * FROM allitems");

    List<ModelAlltransaksiBaru> list = res.isNotEmpty
        ? res.map((c) => ModelAlltransaksiBaru.fromJson(c)).toList()
        // ? res.map((c) => ModelAllitems.fromMap(c)).toList()
        : [];

    return list;
  }

  Future<List<ModelAlltransaksiBaru>> getAlltransaksiNominalByMonthBaru(
      month, year) async {
    final db = await database;
    final res = await db.rawQuery(
        'SELECT * FROM alltransaksibaru WHERE user_id=? and nett !=? and month =? and year =? and jenisform_id=?',
        [sharedPreferences!.getString('id'), 0, month, year, 1]);
    // final res = await db.query('allitems', where: '"sales_id" = $id');
    // final res = await db.rawQuery("SELECT * FROM allitems");

    List<ModelAlltransaksiBaru> list = res.isNotEmpty
        ? res.map((c) => ModelAlltransaksiBaru.fromJson(c)).toList()
        // ? res.map((c) => ModelAllitems.fromMap(c)).toList()
        : [];

    return list;
  }

  Future<List<ModelAlltransaksiBaru>> getAllNominalTransaksiBaru(
      no_invoices) async {
    final db = await database;
    final res = await db.rawQuery(
        'SELECT * FROM alltransaksibaru WHERE invoices_number=? and user_id=? and jenisform_id=?',
        [no_invoices, sharedPreferences!.getString('id'), 1]);
    // final res = await db.query('allitems', where: '"sales_id" = $id');
    // final res = await db.rawQuery("SELECT * FROM allitems");

    List<ModelAlltransaksiBaru> list = res.isNotEmpty
        ? res.map((c) => ModelAlltransaksiBaru.fromJson(c)).toList()
        // ? res.map((c) => ModelAllitems.fromMap(c)).toList()
        : [];

    return list;
  }

  Future<List<Map<String, Object?>>> getAllinvoicesnumberbaru(idtoko) async {
    final db = await database;
    return await db.rawQuery(
        'SELECT * FROM alltransaksibaru WHERE user_id=? and customer_id=? ORDER BY invoices_number DESC',
        [sharedPreferences!.getString('id'), idtoko]);
  }

  Future<List<ModelAlltransaksiBaru>> getAlltransaksiBysearchBaru(
      jenis_id, name) async {
    final db = await database;
    final res = await db.rawQuery(
        'SELECT * FROM alltransaksibaru WHERE jenisform_id=? and user_id=? and invoices_number LIKE ? ORDER BY invoices_number DESC',
        [jenis_id, sharedPreferences!.getString('id'), '%$name%']);
    // final res = await db.query('allitems', where: '"sales_id" = $id');
    // final res = await db.rawQuery("SELECT * FROM alltransaksi");

    List<ModelAlltransaksiBaru> list = res.isNotEmpty
        ? res.map((c) => ModelAlltransaksiBaru.fromJson(c)).toList()
        // ? res.map((c) => ModelAllitems.fromMap(c)).toList()
        : [];

    return list;
  }

//get with search lot
  Future<List<ModelAlltransaksiBaru>> getAlltransaksiBylotBaru(name) async {
    name = '';
    final db = await database;
    final res = await db
        .query("allitemsbaru", where: "name LIKE ?", whereArgs: ['%$name%']);
    // final res = await db.query('allitems', where: '"sales_id" = $id');
    // final res = await db.rawQuery("SELECT * FROM allitems");

    List<ModelAlltransaksiBaru> list = res.isNotEmpty
        ? res.map((c) => ModelAlltransaksiBaru.fromJson(c)).toList()
        : [];

    return list;
  }
}

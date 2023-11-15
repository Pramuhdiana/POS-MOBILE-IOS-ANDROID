// ignore_for_file: depend_on_referenced_packages, avoid_print, non_constant_identifier_names

import 'dart:io';
import 'package:e_shop/database/model_alltransaksi_voucher.dart';
import 'package:e_shop/global/global.dart';
import 'package:path/path.dart';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DbAlltransaksiNewVoucher {
  static Database? _database;
  static final DbAlltransaksiNewVoucher db = DbAlltransaksiNewVoucher._();

  DbAlltransaksiNewVoucher._();

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
    final path = join(documentsDirectory.path, 'ALLTRANSAKSINEWVOUCHER.db');

    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute('''
      CREATE TABLE alltransaksinewvoucher(
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
          status TEXT
          )''');
    });
  }

  createAlltransaksiNewVoucher(
      ModelAlltransaksiNewVoucher newAlltransaksiNewVoucher) async {
    final db = await database;
    final res = await db.insert(
        'alltransaksinewvoucher', newAlltransaksiNewVoucher.toJson());
    print('insert to database alltransaksinewvoucher');
    return res;
  }

  // Delete all employees
  Future<int> deleteAlltransaksiNewVoucher() async {
    final db = await database;
    final res = await db.rawDelete('DELETE FROM alltransaksinewvoucher');
    print("delete all transaksi new voucher berhasil");

    return res;
  }

  //Delete by id (untuk cart)
  Future<int> deleteAlltransaksiNewVoucherByid(int? id) async {
    final db = await database;
    final res = await db.delete('alltransaksinewvoucher', whereArgs: [id]);

    return res;
  }

  //update by id
  // Future<int> updateAllitemsByid(id) async {
  //   final db = await database;
  //   final res =
  //       await db.update();

  //   return res;
  // }

  Future<List<ModelAlltransaksiNewVoucher>> getAlltransaksiNewVoucher(
      jenis_id) async {
    final db = await database;
    final res = await db.rawQuery(
        'SELECT * FROM alltransaksinewvoucher WHERE jenisform_id=? and user_id=? ORDER BY invoices_number DESC',
        [jenis_id, sharedPreferences!.getString('id')]);
    // final res = await db.query('allitems', where: '"sales_id" = $id');
    // final res = await db.rawQuery("SELECT * FROM allitems");

    List<ModelAlltransaksiNewVoucher> list = res.isNotEmpty
        ? res.map((c) => ModelAlltransaksiNewVoucher.fromJson(c)).toList()
        // ? res.map((c) => ModelAllitems.fromMap(c)).toList()
        : [];

    return list;
  }

  Future<List<ModelAlltransaksiNewVoucher>> getAllHistoryNewVoucher() async {
    final db = await database;
    final res = await db.rawQuery(
        'SELECT * FROM alltransaksinewvoucher WHERE user_id=?',
        [sharedPreferences!.getString('id')]);
    // final res = await db.query('allitems', where: '"sales_id" = $id');
    // final res = await db.rawQuery("SELECT * FROM allitems");

    List<ModelAlltransaksiNewVoucher> list = res.isNotEmpty
        ? res.map((c) => ModelAlltransaksiNewVoucher.fromJson(c)).toList()
        // ? res.map((c) => ModelAllitems.fromMap(c)).toList()
        : [];

    return list;
  }

  Future<List<ModelAlltransaksiNewVoucher>> getAlltransaksiNominalNewVoucher(
      year) async {
    final db = await database;
    final res = await db.rawQuery(
        'SELECT * FROM alltransaksinewvoucher WHERE user_id=? and nett !=? and year =? and jenisform_id=?',
        [sharedPreferences!.getString('id'), 0, year, 1]);
    // final res = await db.query('allitems', where: '"sales_id" = $id');
    // final res = await db.rawQuery("SELECT * FROM allitems");

    List<ModelAlltransaksiNewVoucher> list = res.isNotEmpty
        ? res.map((c) => ModelAlltransaksiNewVoucher.fromJson(c)).toList()
        // ? res.map((c) => ModelAllitems.fromMap(c)).toList()
        : [];

    return list;
  }

  Future<List<ModelAlltransaksiNewVoucher>>
      getAlltransaksiNominalByMonthNewVoucher(month, year) async {
    final db = await database;
    final res = await db.rawQuery(
        'SELECT * FROM alltransaksinewvoucher WHERE user_id=? and nett !=? and month =? and year =? and jenisform_id=?',
        [sharedPreferences!.getString('id'), 0, month, year, 1]);
    // final res = await db.query('allitems', where: '"sales_id" = $id');
    // final res = await db.rawQuery("SELECT * FROM allitems");

    List<ModelAlltransaksiNewVoucher> list = res.isNotEmpty
        ? res.map((c) => ModelAlltransaksiNewVoucher.fromJson(c)).toList()
        // ? res.map((c) => ModelAllitems.fromMap(c)).toList()
        : [];

    return list;
  }

  Future<List<ModelAlltransaksiNewVoucher>> getAllNominalTransaksiNewVoucher(
      no_invoices) async {
    final db = await database;
    final res = await db.rawQuery(
        'SELECT * FROM alltransaksinewvoucher WHERE invoices_number=? and user_id=? and jenisform_id=?',
        [no_invoices, sharedPreferences!.getString('id'), 1]);
    // final res = await db.query('allitems', where: '"sales_id" = $id');
    // final res = await db.rawQuery("SELECT * FROM allitems");

    List<ModelAlltransaksiNewVoucher> list = res.isNotEmpty
        ? res.map((c) => ModelAlltransaksiNewVoucher.fromJson(c)).toList()
        // ? res.map((c) => ModelAllitems.fromMap(c)).toList()
        : [];

    return list;
  }

  Future<List<Map<String, Object?>>> getAllinvoicesnumbernewvoucher(
      idtoko) async {
    final db = await database;
    return await db.rawQuery(
        'SELECT * FROM alltransaksinewvoucher WHERE user_id=? and customer_id=? ORDER BY invoices_number DESC',
        [sharedPreferences!.getString('id'), idtoko]);
  }

  Future<List<ModelAlltransaksiNewVoucher>> getAlltransaksiBysearchNewVoucher(
      jenis_id, name) async {
    final db = await database;
    final res = await db.rawQuery(
        'SELECT * FROM alltransaksinewvoucher WHERE jenisform_id=? and user_id=? and invoices_number LIKE ? ORDER BY invoices_number DESC',
        [jenis_id, sharedPreferences!.getString('id'), '%$name%']);
    // final res = await db.query('allitems', where: '"sales_id" = $id');
    // final res = await db.rawQuery("SELECT * FROM alltransaksi");

    List<ModelAlltransaksiNewVoucher> list = res.isNotEmpty
        ? res.map((c) => ModelAlltransaksiNewVoucher.fromJson(c)).toList()
        // ? res.map((c) => ModelAllitems.fromMap(c)).toList()
        : [];

    return list;
  }

//get with search lot
  Future<List<ModelAlltransaksiNewVoucher>> getAlltransaksiBylotNewVoucher(
      name) async {
    name = '';
    final db = await database;
    final res = await db.query("allitemsnewvoucher",
        where: "name LIKE ?", whereArgs: ['%$name%']);
    // final res = await db.query('allitems', where: '"sales_id" = $id');
    // final res = await db.rawQuery("SELECT * FROM allitems");

    List<ModelAlltransaksiNewVoucher> list = res.isNotEmpty
        ? res.map((c) => ModelAlltransaksiNewVoucher.fromJson(c)).toList()
        : [];

    return list;
  }
}

// ignore_for_file: depend_on_referenced_packages, avoid_print

import 'dart:io';
import 'package:e_shop/database/model_allcustomer.dart';
import 'package:e_shop/global/global.dart';
import 'package:path/path.dart';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DbAllCustomer {
  static Database? _database;
  static final DbAllCustomer db = DbAllCustomer._();

  DbAllCustomer._();

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
    final path = join(documentsDirectory.path, 'ALLCUSTOMER.db');

    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute('''
      CREATE TABLE allcustomer(
          id INTEGER PRIMARY KEY,
          name TEXT,
          role INTEGER,
          alamat TEXT,
          phone TEXT,
          user_id TEXT,
          type_customer TEXT,
          diskon_customer TEXT,
          customer_brand INTEGER,
          score INTEGER
                   )''');
    });
  }

  createAllcustomer(ModelAllCustomer newAllcustomer) async {
    final db = await database;
    final res = await db.insert('allcustomer', newAllcustomer.toJson());
    return res;
  }

  // Delete all employees
  Future<int> deleteAllcustomer() async {
    final db = await database;
    final res = await db.rawDelete('DELETE FROM allcustomer');

    return res;
  }

  //Delete by id (untuk cart)
  Future<int> deleteAllcustomerByid(int? id) async {
    final db = await database;

    final res =
        await db.delete('allcustomer', where: "id = ?", whereArgs: [id]);
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
  Future<int> updateAllcustomerByname(String? name, int? qty) async {
    final db = await database;

    final data = {'qty': qty};

    final result = await db
        .update('allcustomer', data, where: "name = ?", whereArgs: [name]);
    return result;
  }

  Future<List<ModelAllCustomer>> getAllcustomer(int score) async {
    id;
    final db = await database;
    final res = await db
        .rawQuery('SELECT * FROM allcustomer WHERE alamat!=?', ['null']);
    // final res = await db.rawQuery("SELECT * FROM allcustomer");

    List<ModelAllCustomer> list = res.isNotEmpty
        ? res.map((c) => ModelAllCustomer.fromJson(c)).toList()
        : [];

    return list;
  }
}

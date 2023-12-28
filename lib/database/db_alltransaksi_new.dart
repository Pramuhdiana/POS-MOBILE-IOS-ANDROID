// // ignore_for_file: depend_on_referenced_packages, avoid_print, non_constant_identifier_names

// import 'dart:io';
// import 'package:e_shop/database/model_alltransaksi_new.dart';
// import 'package:e_shop/global/global.dart';
// import 'package:path/path.dart';

// import 'package:path_provider/path_provider.dart';
// import 'package:sqflite/sqflite.dart';

// class DbAlltransaksiNew {
//   static Database? _database;
//   static final DbAlltransaksiNew db = DbAlltransaksiNew._();

//   DbAlltransaksiNew._();

//   Future<Database> get database async {
//     // If database exists, return database
//     if (_database != null) return _database!;

//     // If database don't exists, create one
//     _database = await initDB();

//     return _database!;
//   }

//   // Create the database and the Employee table
//   initDB() async {
//     Directory documentsDirectory = await getApplicationDocumentsDirectory();
//     final path = join(documentsDirectory.path, 'ALLTRANSAKSINEW.db');

//     return await openDatabase(path, version: 1, onOpen: (db) {},
//         onCreate: (Database db, int version) async {
//       await db.execute('''
//       CREATE TABLE alltransaksinew(
//           invoices_number TEXT,
//           user_id INTEGER,
//           customer_id INTEGER,
//           customer_metier INTEGER,
//           customer_beliberlian TEXT,
//           jenisform_id INTEGER,
//           sales_id INTEGER,
//           total INTEGER,
//           total_quantity INTEGER,
//           total_rupiah TEXT,
//           basic_discount INTEGER,
//           addesdiskon_rupiah INTEGER,
//           rate INTEGER,
//           nett INTEGER,
//           created_at TEXT,
//           updated_at TEXT,
//           user TEXT,
//           customer TEXT,
//           alamat TEXT,
//           jenisform TEXT,
//           month TEXT,
//           year TEXT
//           )''');
//     });
//   }

//   createAlltransaksiNew(ModelAlltransaksiNew newAlltransaksi) async {
//     print('insert to database alltransaksinew');
//     final db = await database;
//     final res = await db.insert('alltransaksinew', newAlltransaksi.toJson());
//     return res;
//   }

//   // Delete all employees
//   Future<int> deleteAlltransaksiNew() async {
//     final db = await database;
//     final res = await db.rawDelete('DELETE FROM alltransaksinew');
//     print("delete all transaksi new berhasil");

//     return res;
//   }

//   //Delete by id (untuk cart)
//   Future<int> deleteAlltransaksiByidNew(int? id) async {
//     final db = await database;
//     final res = await db.delete('alltransaksinew', whereArgs: [id]);

//     return res;
//   }

//   //update by id
//   // Future<int> updateAllitemsByid(id) async {
//   //   final db = await database;
//   //   final res =
//   //       await db.update();

//   //   return res;
//   // }

//   Future<List<ModelAlltransaksiNew>> getAlltransaksiNew(jenis_id) async {
//     final db = await database;
//     final res = await db.rawQuery(
//         'SELECT * FROM alltransaksinew WHERE jenisform_id=? and user_id=? ORDER BY invoices_number DESC',
//         [jenis_id, sharedPreferences!.getString('id')]);
//     // final res = await db.query('allitems', where: '"sales_id" = $id');
//     // final res = await db.rawQuery("SELECT * FROM allitems");

//     List<ModelAlltransaksiNew> list = res.isNotEmpty
//         ? res.map((c) => ModelAlltransaksiNew.fromJson(c)).toList()
//         // ? res.map((c) => ModelAllitems.fromMap(c)).toList()
//         : [];

//     return list;
//   }

//   Future<List<ModelAlltransaksiNew>> getAllHistoryNew() async {
//     final db = await database;
//     final res = await db.rawQuery(
//         'SELECT * FROM alltransaksinew WHERE user_id=?',
//         [sharedPreferences!.getString('id')]);
//     // final res = await db.query('allitems', where: '"sales_id" = $id');
//     // final res = await db.rawQuery("SELECT * FROM allitems");

//     List<ModelAlltransaksiNew> list = res.isNotEmpty
//         ? res.map((c) => ModelAlltransaksiNew.fromJson(c)).toList()
//         // ? res.map((c) => ModelAllitems.fromMap(c)).toList()
//         : [];

//     return list;
//   }

//   Future<List<ModelAlltransaksiNew>> getAlltransaksiNominalNew(year) async {
//     final db = await database;
//     final res = await db.rawQuery(
//         'SELECT * FROM alltransaksinew WHERE user_id=? and nett !=? and year =? and jenisform_id=?',
//         [sharedPreferences!.getString('id'), 0, year, 1]);
//     // final res = await db.query('allitems', where: '"sales_id" = $id');
//     // final res = await db.rawQuery("SELECT * FROM allitems");

//     List<ModelAlltransaksiNew> list = res.isNotEmpty
//         ? res.map((c) => ModelAlltransaksiNew.fromJson(c)).toList()
//         // ? res.map((c) => ModelAllitems.fromMap(c)).toList()
//         : [];

//     return list;
//   }

//   Future<List<ModelAlltransaksiNew>> getAlltransaksiNominalByMonthNew(
//       month, year) async {
//     final db = await database;
//     final res = await db.rawQuery(
//         'SELECT * FROM alltransaksinew WHERE user_id=? and nett !=? and month =? and year =? and jenisform_id=?',
//         [sharedPreferences!.getString('id'), 0, month, year, 1]);
//     // final res = await db.query('allitems', where: '"sales_id" = $id');
//     // final res = await db.rawQuery("SELECT * FROM allitems");

//     List<ModelAlltransaksiNew> list = res.isNotEmpty
//         ? res.map((c) => ModelAlltransaksiNew.fromJson(c)).toList()
//         // ? res.map((c) => ModelAllitems.fromMap(c)).toList()
//         : [];

//     return list;
//   }

//   Future<List<ModelAlltransaksiNew>> getAllNominalTransaksiNew(
//       no_invoices) async {
//     final db = await database;
//     final res = await db.rawQuery(
//         'SELECT * FROM alltransaksinew WHERE invoices_number=? and user_id=? and jenisform_id=?',
//         [no_invoices, sharedPreferences!.getString('id'), 1]);
//     // final res = await db.query('allitems', where: '"sales_id" = $id');
//     // final res = await db.rawQuery("SELECT * FROM allitems");

//     List<ModelAlltransaksiNew> list = res.isNotEmpty
//         ? res.map((c) => ModelAlltransaksiNew.fromJson(c)).toList()
//         // ? res.map((c) => ModelAllitems.fromMap(c)).toList()
//         : [];

//     return list;
//   }

//   Future<List<Map<String, Object?>>> getAllinvoicesnumberNew(idtoko) async {
//     final db = await database;
//     return await db.rawQuery(
//         'SELECT * FROM alltransaksinew WHERE user_id=? and customer_id=? ORDER BY invoices_number DESC',
//         [sharedPreferences!.getString('id'), idtoko]);
//   }

//   Future<List<ModelAlltransaksiNew>> getAlltransaksiBysearchNew(
//       jenis_id, name) async {
//     final db = await database;
//     final res = await db.rawQuery(
//         'SELECT * FROM alltransaksinew WHERE jenisform_id=? and user_id=? and invoices_number LIKE ? ORDER BY invoices_number DESC',
//         [jenis_id, sharedPreferences!.getString('id'), '%$name%']);
//     // final res = await db.query('allitems', where: '"sales_id" = $id');
//     // final res = await db.rawQuery("SELECT * FROM alltransaksi");

//     List<ModelAlltransaksiNew> list = res.isNotEmpty
//         ? res.map((c) => ModelAlltransaksiNew.fromJson(c)).toList()
//         // ? res.map((c) => ModelAllitems.fromMap(c)).toList()
//         : [];

//     return list;
//   }

// //get with search lot
//   Future<List<ModelAlltransaksiNew>> getAlltransaksiBylotNew(name) async {
//     name = '';
//     final db = await database;
//     final res = await db
//         .query("allitemsnew", where: "name LIKE ?", whereArgs: ['%$name%']);
//     // final res = await db.query('allitems', where: '"sales_id" = $id');
//     // final res = await db.rawQuery("SELECT * FROM allitems");

//     List<ModelAlltransaksiNew> list = res.isNotEmpty
//         ? res.map((c) => ModelAlltransaksiNew.fromJson(c)).toList()
//         : [];

//     return list;
//   }
// }

import 'package:e_shop/database/db_crm.dart';
import 'package:e_shop/global/global.dart';
import 'package:flutter/material.dart';

class DashboardErick extends StatefulWidget {
  const DashboardErick({super.key});

  @override
  State<DashboardErick> createState() => _DashboardErickState();
}

@override
void initState() {}

class _DashboardErickState extends State<DashboardErick> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
            colors: [
              Colors.blueAccent,
              Colors.lightBlueAccent,
            ],
            begin: FractionalOffset(0.0, 0.0),
            end: FractionalOffset(1.0, 0.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp,
          )),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "View khusus pak erick",
          style: TextStyle(
            fontSize: 20,
            letterSpacing: 3,
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: FutureBuilder(
        future: DbCRM.db.getAllcrm(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          // WHEN THE CALL IS DONE BUT HAPPENS TO HAVE AN ERROR
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }

          return Column(children: <Widget>[
            const Center(
                child: Text('List Report',
                    style:
                        TextStyle(fontSize: 25, fontWeight: FontWeight.bold))),
            Expanded(
                flex: 1,
                child: ListView(
                    // SingleChildScrollView(
                    // scrollDirection: Axis.vertical,
                    children: <Widget>[
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          // ignore: deprecated_member_use
                          dataRowHeight: 70,
                          sortColumnIndex: 1,
                          showCheckboxColumn: false,
                          border: TableBorder.all(width: 1),
                          columns: const [
                            DataColumn(
                                label: Text('ID',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold))),
                            DataColumn(
                                label: Text('Name',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold))),
                            DataColumn(
                                label: Text('Adit',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold))),
                            DataColumn(
                                label: Text('Febri',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold))),
                            DataColumn(
                                label: Text('Erick',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold))),
                            DataColumn(
                                label: Text('Jonathan',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold))),
                          ],
                          rows: [
                            for (var i = 0; i < snapshot.data!.length; i++)
                              DataRow(cells: [
                                DataCell(Text((i + 1).toString())),
                                DataCell(
                                    Text('${snapshot.data![i].nama_toko}')),
                                //adit
                                DataCell(
                                  Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: FutureBuilder(
                                            future: DbCRM.db.getCountCrmById(
                                                1,
                                                snapshot.data![i].customer_id,
                                                19),
                                            builder: (context, snapshot) {
                                              if (snapshot.hasData) {
                                                return Text(
                                                  'Wa     : ${snapshot.data!.length.toString()}',
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                  style: const TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.green,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                );
                                              } else {
                                                return const Text('0');
                                              }
                                            }),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: FutureBuilder(
                                            future: DbCRM.db.getCountCrmById(
                                                2,
                                                snapshot.data![i].customer_id,
                                                19),
                                            builder: (context, snapshot) {
                                              if (snapshot.hasData) {
                                                return Text(
                                                  'Tlp     : ${snapshot.data!.length.toString()}',
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                  style: const TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.blue,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                );
                                              } else {
                                                return const Text('0');
                                              }
                                            }),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: FutureBuilder(
                                            future: DbCRM.db.getCountCrmById(
                                                3,
                                                snapshot.data![i].customer_id,
                                                19),
                                            builder: (context, snapshot) {
                                              if (snapshot.hasData) {
                                                return Text(
                                                  'Visit   : ${snapshot.data!.length.toString()}',
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                  style: const TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.orange,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                );
                                              } else {
                                                return const Text('0');
                                              }
                                            }),
                                      ),
                                    ],
                                  ),
                                ),
                                //febri
                                DataCell(
                                  Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: FutureBuilder(
                                            future: DbCRM.db.getCountCrmById(
                                                1,
                                                snapshot.data![i].customer_id,
                                                19),
                                            builder: (context, snapshot) {
                                              if (snapshot.hasData) {
                                                return Text(
                                                  'Wa     : ${snapshot.data!.length.toString()}',
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                  style: const TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.green,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                );
                                              } else {
                                                return const Text('0');
                                              }
                                            }),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: FutureBuilder(
                                            future: DbCRM.db.getCountCrmById(
                                                2,
                                                snapshot.data![i].customer_id,
                                                19),
                                            builder: (context, snapshot) {
                                              if (snapshot.hasData) {
                                                return Text(
                                                  'Tlp     : ${snapshot.data!.length.toString()}',
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                  style: const TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.blue,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                );
                                              } else {
                                                return const Text('0');
                                              }
                                            }),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: FutureBuilder(
                                            future: DbCRM.db.getCountCrmById(
                                                3,
                                                snapshot.data![i].customer_id,
                                                19),
                                            builder: (context, snapshot) {
                                              if (snapshot.hasData) {
                                                return Text(
                                                  'Visit   : ${snapshot.data!.length.toString()}',
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                  style: const TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.orange,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                );
                                              } else {
                                                return const Text('0');
                                              }
                                            }),
                                      ),
                                    ],
                                  ),
                                ),
                                //erick
                                DataCell(
                                  Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: FutureBuilder(
                                            future: DbCRM.db.getCountCrmById(
                                                1,
                                                snapshot.data![i].customer_id,
                                                sharedPreferences!
                                                    .getString('id')),
                                            builder: (context, snapshot) {
                                              if (snapshot.hasData) {
                                                return Text(
                                                  'Wa     : ${snapshot.data!.length.toString()}',
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                  style: const TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.green,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                );
                                              } else {
                                                return const Text('0');
                                              }
                                            }),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: FutureBuilder(
                                            future: DbCRM.db.getCountCrmById(
                                                2,
                                                snapshot.data![i].customer_id,
                                                sharedPreferences!
                                                    .getString('id')),
                                            builder: (context, snapshot) {
                                              if (snapshot.hasData) {
                                                return Text(
                                                  'Tlp     : ${snapshot.data!.length.toString()}',
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                  style: const TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.blue,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                );
                                              } else {
                                                return const Text('0');
                                              }
                                            }),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: FutureBuilder(
                                            future: DbCRM.db.getCountCrmById(
                                                3,
                                                snapshot.data![i].customer_id,
                                                sharedPreferences!
                                                    .getString('id')),
                                            builder: (context, snapshot) {
                                              if (snapshot.hasData) {
                                                return Text(
                                                  'Visit   : ${snapshot.data!.length.toString()}',
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                  style: const TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.orange,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                );
                                              } else {
                                                return const Text('0');
                                              }
                                            }),
                                      ),
                                    ],
                                  ),
                                ),
                                //jonathan
                                DataCell(
                                  Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: FutureBuilder(
                                            future: DbCRM.db.getCountCrmById(
                                                1,
                                                snapshot.data![i].customer_id,
                                                19),
                                            builder: (context, snapshot) {
                                              if (snapshot.hasData) {
                                                return Text(
                                                  'Wa     : ${snapshot.data!.length.toString()}',
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                  style: const TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.green,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                );
                                              } else {
                                                return const Text('0');
                                              }
                                            }),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: FutureBuilder(
                                            future: DbCRM.db.getCountCrmById(
                                                2,
                                                snapshot.data![i].customer_id,
                                                19),
                                            builder: (context, snapshot) {
                                              if (snapshot.hasData) {
                                                return Text(
                                                  'Tlp     : ${snapshot.data!.length.toString()}',
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                  style: const TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.blue,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                );
                                              } else {
                                                return const Text('0');
                                              }
                                            }),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: FutureBuilder(
                                            future: DbCRM.db.getCountCrmById(
                                                3,
                                                snapshot.data![i].customer_id,
                                                19),
                                            builder: (context, snapshot) {
                                              if (snapshot.hasData) {
                                                return Text(
                                                  'Visit   : ${snapshot.data!.length.toString()}',
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                  style: const TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.orange,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                );
                                              } else {
                                                return const Text('0');
                                              }
                                            }),
                                      ),
                                    ],
                                  ),
                                ),
                              ]),
                          ],
                        ),
                      )
                    ]))
          ]);
        },
      ),
    );
  }
}

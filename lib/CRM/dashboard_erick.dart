// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:e_shop/database/db_crm.dart';
import 'package:e_shop/database/model_crm.dart';
import 'package:flutter/material.dart';

class DashboardErick extends StatefulWidget {
  const DashboardErick({super.key});

  @override
  State<DashboardErick> createState() => _DashboardErickState();
}

@override
Widget _verticalDivider = const VerticalDivider(
  color: Colors.grey,
  thickness: 1,
);

@override
void initState() {}

class _DashboardErickState extends State<DashboardErick> {
  bool sort = true;
  List<ModelCRM>? filterCrm;
  List<ModelCRM>? myCrm;
  TextEditingController controller = TextEditingController();

  onsortColum(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      if (ascending) {
        filterCrm!.sort((a, b) =>
            a.nama_toko!.toLowerCase().compareTo(b.nama_toko!.toLowerCase()));
      } else {
        filterCrm!.sort((a, b) =>
            b.nama_toko!.toLowerCase().compareTo(a.nama_toko!.toLowerCase()));
      }
    }
  }

  // fungsi remove duplicate object
  List<ModelCRM> removeDuplicates(List<ModelCRM> items) {
    List<ModelCRM> uniqueItems = []; // uniqueList
    var uniqueNames = items
        .map((e) => e.nama_toko)
        .toSet(); //list if UniqueID to remove duplicates
    for (var e in uniqueNames) {
      uniqueItems.add(items.firstWhere((i) => i.nama_toko == e));
    } // populate uniqueItems with equivalent original Batch items
    return uniqueItems; //send back the unique items list
  }

// end fungsi remove duplicate
  @override
  void initState() {
    super.initState();

    DbCRM.db.getAllcrm().then((value) {
      setState(() {
        filterCrm = value;
        // myCrm = filterCrm;
        myCrm = removeDuplicates(filterCrm!);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, //anti error jika keyboard active
      appBar: AppBar(
        backgroundColor: Colors.white,
        flexibleSpace: Container(
          color: Colors.white,
          // decoration: const BoxDecoration(
          //     gradient: LinearGradient(
          //   colors: [
          //     Colors.blueAccent,
          //     Colors.lightBlueAccent,
          //   ],
          //   begin: FractionalOffset(0.0, 0.0),
          //   end: FractionalOffset(1.0, 0.0),
          //   stops: [0.0, 1.0],
          //   tileMode: TileMode.clamp,
          // )),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "HELICOPTER VIEW",
          style: TextStyle(
            color: Colors.black,
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

          return Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Theme.of(context).canvasColor,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                    width: double.infinity,
                    child: Theme(
                      data: ThemeData.light()
                          .copyWith(cardColor: Theme.of(context).canvasColor),
                      child: PaginatedDataTable(
                        // ignore: deprecated_member_use
                        dataRowHeight: 70,
                        sortColumnIndex: 0,
                        sortAscending: sort,
                        header: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey,
                              ),
                              borderRadius: BorderRadius.circular(12)),
                          child: TextField(
                            controller: controller,
                            decoration: const InputDecoration(
                                hintText: "Enter something to filter"),
                            onChanged: (value) {
                              myCrm = removeDuplicates(filterCrm!)
                                  .where((element) => element.nama_toko!
                                      .toLowerCase()
                                      .contains(value))
                                  .toList();
                              setState(() {});
                            },
                          ),
                        ),
                        source: RowSource(
                          myData: myCrm,
                          count: myCrm!.length,
                        ),
                        rowsPerPage: 5,
                        columnSpacing: 5,
                        columns: [
                          DataColumn(
                              label: const Text(
                                "Name",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 14),
                              ),
                              onSort: (columnIndex, ascending) {
                                sort = !sort;
                                setState(() {
                                  sort = !sort;
                                });
                                onsortColum(columnIndex, ascending);
                              }),
                          DataColumn(label: _verticalDivider),
                          const DataColumn(
                              label: Text('Adit',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600))),
                          DataColumn(label: _verticalDivider),
                          const DataColumn(
                              label: Text('Erick',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600))),
                          DataColumn(label: _verticalDivider),
                          const DataColumn(
                              label: Text('Febri',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600))),
                          DataColumn(label: _verticalDivider),
                          const DataColumn(
                              label: Text('Jonathan',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600))),
                        ],
                      ),
                    )),
              ],
            ),
          );
        },
      ),
    );
  }
}

class RowSource extends DataTableSource {
  var myData;
  final count;
  RowSource({
    required this.myData,
    required this.count,
  });

  @override
  DataRow? getRow(int index) {
    if (index < rowCount) {
      return recentFileDataRow(myData![index]);
    } else {
      return null;
    }
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => count;

  @override
  int get selectedRowCount => 0;
}

DataRow recentFileDataRow(var data) {
  return DataRow(
    cells: [
      DataCell(Text(data.nama_toko ?? "")),
      DataCell(_verticalDivider),

      //adit
      DataCell(
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: FutureBuilder(
                  future: DbCRM.db.getCountCrmById(1, data.customer_id, 23),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data!.length.toString() == '0') {
                        return const Text('');
                      } else {
                        return Text(
                          'Wa     : ${snapshot.data!.length.toString()}',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: const TextStyle(
                              fontSize: 15,
                              color: Colors.green,
                              fontWeight: FontWeight.w600),
                        );
                      }
                    } else {
                      return const Text('0');
                    }
                  }),
            ),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: FutureBuilder(
                  future: DbCRM.db.getCountCrmById(2, data.customer_id, 23),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data!.length.toString() == '0') {
                        return const Text('');
                      } else {
                        return Text(
                          'Tlp     : ${snapshot.data!.length.toString()}',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: const TextStyle(
                              fontSize: 15,
                              color: Colors.blue,
                              fontWeight: FontWeight.w600),
                        );
                      }
                    } else {
                      return const Text('0');
                    }
                  }),
            ),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: FutureBuilder(
                  future: DbCRM.db.getCountCrmById(3, data.customer_id, 23),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data!.length.toString() == '0') {
                        return const Text('');
                      } else {
                        return Text(
                          'Visit   : ${snapshot.data!.length.toString()}',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: const TextStyle(
                              fontSize: 15,
                              color: Colors.orange,
                              fontWeight: FontWeight.w600),
                        );
                      }
                    } else {
                      return const Text('0');
                    }
                  }),
            ),
          ],
        ),
      ),
      DataCell(_verticalDivider),

      //erick
      DataCell(
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: FutureBuilder(
                  future: DbCRM.db.getCountCrmById(1, data.customer_id, 21),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data!.length.toString() == '0') {
                        return const Text('');
                      } else {
                        return Text(
                          'Wa     : ${snapshot.data!.length.toString()}',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: const TextStyle(
                              fontSize: 15,
                              color: Colors.green,
                              fontWeight: FontWeight.w600),
                        );
                      }
                    } else {
                      return const Text('0');
                    }
                  }),
            ),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: FutureBuilder(
                  future: DbCRM.db.getCountCrmById(2, data.customer_id, 21),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data!.length.toString() == '0') {
                        return const Text('');
                      } else {
                        return Text(
                          'Tlp     : ${snapshot.data!.length.toString()}',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: const TextStyle(
                              fontSize: 15,
                              color: Colors.blue,
                              fontWeight: FontWeight.w600),
                        );
                      }
                    } else {
                      return const Text('0');
                    }
                  }),
            ),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: FutureBuilder(
                  future: DbCRM.db.getCountCrmById(3, data.customer_id, 21),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data!.length.toString() == '0') {
                        return const Text('');
                      } else {
                        return Text(
                          'Visit   : ${snapshot.data!.length.toString()}',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: const TextStyle(
                              fontSize: 15,
                              color: Colors.orange,
                              fontWeight: FontWeight.w600),
                        );
                      }
                    } else {
                      return const Text('0');
                    }
                  }),
            ),
          ],
        ),
      ),
      DataCell(_verticalDivider),

      //febri
      DataCell(
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: FutureBuilder(
                  future: DbCRM.db.getCountCrmById(1, data.customer_id, 52),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data!.length.toString() == '0') {
                        return const Text('');
                      } else {
                        return Text(
                          'Wa     : ${snapshot.data!.length.toString()}',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: const TextStyle(
                              fontSize: 15,
                              color: Colors.green,
                              fontWeight: FontWeight.w600),
                        );
                      }
                    } else {
                      return const Text('0');
                    }
                  }),
            ),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: FutureBuilder(
                  future: DbCRM.db.getCountCrmById(2, data.customer_id, 52),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data!.length.toString() == '0') {
                        return const Text('');
                      } else {
                        return Text(
                          'Tlp     : ${snapshot.data!.length.toString()}',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: const TextStyle(
                              fontSize: 15,
                              color: Colors.blue,
                              fontWeight: FontWeight.w600),
                        );
                      }
                    } else {
                      return const Text('0');
                    }
                  }),
            ),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: FutureBuilder(
                  future: DbCRM.db.getCountCrmById(3, data.customer_id, 52),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data!.length.toString() == '0') {
                        return const Text('');
                      } else {
                        return Text(
                          'Visit   : ${snapshot.data!.length.toString()}',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: const TextStyle(
                              fontSize: 15,
                              color: Colors.orange,
                              fontWeight: FontWeight.w600),
                        );
                      }
                    } else {
                      return const Text('0');
                    }
                  }),
            ),
          ],
        ),
      ),
      DataCell(_verticalDivider),

      //jonathan
      DataCell(
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: FutureBuilder(
                  future: DbCRM.db.getCountCrmById(1, data.customer_id, 19),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data!.length.toString() == '0') {
                        return const Text('');
                      } else {
                        return Text(
                          'Wa     : ${snapshot.data!.length.toString()}',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: const TextStyle(
                              fontSize: 15,
                              color: Colors.green,
                              fontWeight: FontWeight.w600),
                        );
                      }
                    } else {
                      return const Text('0');
                    }
                  }),
            ),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: FutureBuilder(
                  future: DbCRM.db.getCountCrmById(2, data.customer_id, 19),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data!.length.toString() == '0') {
                        return const Text('');
                      } else {
                        return Text(
                          'Tlp     : ${snapshot.data!.length.toString()}',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: const TextStyle(
                              fontSize: 15,
                              color: Colors.blue,
                              fontWeight: FontWeight.w600),
                        );
                      }
                    } else {
                      return const Text('0');
                    }
                  }),
            ),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: FutureBuilder(
                  future: DbCRM.db.getCountCrmById(3, data.customer_id, 19),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data!.length.toString() == '0') {
                        return const Text('');
                      } else {
                        return Text(
                          'Visit   : ${snapshot.data!.length.toString()}',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: const TextStyle(
                              fontSize: 15,
                              color: Colors.orange,
                              fontWeight: FontWeight.w600),
                        );
                      }
                    } else {
                      return const Text('0');
                    }
                  }),
            ),
          ],
        ),
      ),
    ],
  );
}

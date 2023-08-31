// ignore_for_file: prefer_typing_uninitialized_variables, avoid_print

import 'package:e_shop/CRM/detailCrm/detail_activity_sales.dart';
import 'package:e_shop/CRM/detailCrm/detail_crm_by_customer.dart';

import 'package:e_shop/database/db_crm.dart';
import 'package:e_shop/database/model_crm.dart';
import 'package:e_shop/global/global.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

import 'detailCrm/detail_crm_sales.dart';

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
  TextEditingController fromDate = TextEditingController();
  TextEditingController toDate = TextEditingController();

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

    // DbCRM.db.getAllcrmByDate(fromDate.text, toDate.text).then((value) {
    //   setState(() {
    //     filterCrm = value;
    //     // myCrm = filterCrm;
    //     myCrm = removeDuplicates(filterCrm!);
    //   });
    // });

    DbCRM.db.getAllcrm().then((value) {
      setState(() {
        filterCrm = value;
        myCrm = removeDuplicates(filterCrm!);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, //anti error jika keyboard active
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        flexibleSpace: Container(
          color: Colors.white,
        ),
        leading: IconButton(
          icon: Image.asset(
            "assets/arrow.png",
            width: 35,
            height: 35,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "REPORT ALL CRM",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    width: 130,
                    child: TextField(
                      style: const TextStyle(fontSize: 12),
                      controller:
                          fromDate, //editing controller of this TextField
                      decoration: const InputDecoration(
                          icon: Icon(
                            Icons.calendar_month,
                            color: Colors.black,
                          ), //icon of text field
                          labelText: "From..." //label text of field
                          ),
                      readOnly:
                          true, //set it true, so that user will not able to edit text
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(
                              2000), //DateTime.now() - not to allow to choose before today.
                          lastDate: DateTime(2025),
                        );

                        if (pickedDate != null) {
                          print(
                              pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                          String formattedDate =
                              DateFormat('yyyy-MM-dd').format(pickedDate);
                          // DateFormat('dd-MM-yyyy').format(pickedDate);

                          print(
                              formattedDate); //formatted date output using intl package =>  2021-03-16
                          //you can implement different kind of Date Format here according to your requirement
                          setState(() {
                            fromDate.text =
                                formattedDate; //set output date to TextField value.
                            DbCRM.db
                                .getAllcrmByDate(fromDate.text, toDate.text)
                                .then((value) {
                              setState(() {
                                filterCrm = value;
                                myCrm = removeDuplicates(filterCrm!);
                              });
                            });
                          });
                        } else {
                          print("Date is not selected");
                        }
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                    child: Text(
                      ':',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                  //to date
                  SizedBox(
                    width: 130,
                    child: TextField(
                      style: const TextStyle(fontSize: 12),
                      controller: toDate, //editing controller of this TextField
                      decoration: const InputDecoration(
                          icon: Icon(
                            Icons.calendar_month,
                            color: Colors.black,
                          ), //icon of text field
                          labelText: "To..." //label text of field
                          ),
                      readOnly:
                          true, //set it true, so that user will not able to edit text
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(
                              2000), //DateTime.now() - not to allow to choose before today.
                          lastDate: DateTime(2025),
                        );

                        if (pickedDate != null) {
                          print(
                              pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                          String formattedDate =
                              DateFormat('yyyy-MM-dd').format(pickedDate);

                          print(
                              formattedDate); //formatted date output using intl package =>  2021-03-16
                          //you can implement different kind of Date Format here according to your requirement
                          setState(() {
                            toDate.text =
                                formattedDate; //set output date to TextField value.
                            DbCRM.db
                                .getAllcrmByDate(fromDate.text, toDate.text)
                                .then((value) {
                              setState(() {
                                filterCrm = value;
                                myCrm = removeDuplicates(filterCrm!);
                              });
                            });
                          });
                        } else {
                          print("Date is not selected");
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.7,
            height: 45,
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                ),
                borderRadius: BorderRadius.circular(12)),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: TextField(
                textAlign: TextAlign.center,
                controller: controller,
                decoration: const InputDecoration(
                    hintText: "Enter name Customer to filter"),
                onChanged: (value) {
                  myCrm = removeDuplicates(filterCrm!)
                      .where((element) =>
                          element.nama_toko!.toLowerCase().contains(value))
                      .toList();
                  setState(() {});
                },
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Container(
                padding: const EdgeInsets.only(top: 20),
                child: FutureBuilder(
                  future: toDate.text.isNotEmpty && fromDate.text.isNotEmpty
                      ? DbCRM.db.getAllcrmByDate(fromDate.text, toDate.text)
                      : DbCRM.db.getAllcrm(),
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
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                              width: double.infinity,
                              child: Theme(
                                data: ThemeData.light().copyWith(
                                    cardColor: Theme.of(context).canvasColor),
                                child: PaginatedDataTable(
                                  // ignore: deprecated_member_use
                                  dataRowHeight: 110,
                                  sortColumnIndex: 0,
                                  sortAscending: sort,

                                  source: RowSource(
                                    myData: myCrm,
                                    count: myCrm!.length,
                                  ),
                                  rowsPerPage: 5,
                                  columnSpacing: 1,
                                  columns: [
                                    const DataColumn(
                                      label: Padding(
                                        padding: EdgeInsets.only(left: 35),
                                        child: Text(
                                          "Name",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14),
                                        ),
                                      ),
                                      // onSort: (columnIndex, ascending) {
                                      // sort = !sort;
                                      // setState(() {
                                      //   sort = !sort;
                                      // });
                                      // onsortColum(columnIndex, ascending);
                                      // }
                                    ),
                                    DataColumn(label: _verticalDivider),
                                    DataColumn(
                                        label: Padding(
                                      padding: const EdgeInsets.only(left: 15),
                                      child: TextButton(
                                        onPressed: () {
                                          sharedPreferences!
                                              .setInt('detailIdSales', 23);
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (c) =>
                                                      DetailCrmSalesScreen(
                                                        str: 'ADIT',
                                                      )));
                                        },
                                        child: const Text('Adit',
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600)),
                                      ),
                                    )),
                                    DataColumn(label: _verticalDivider),
                                    DataColumn(
                                        label: Padding(
                                      padding: const EdgeInsets.only(left: 15),
                                      child: TextButton(
                                        onPressed: () {},
                                        child: const Text('Erick',
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600)),
                                      ),
                                    )),
                                    DataColumn(label: _verticalDivider),
                                    DataColumn(
                                        label: Padding(
                                      padding: const EdgeInsets.only(left: 15),
                                      child: TextButton(
                                        onPressed: () {
                                          sharedPreferences!
                                              .setInt('detailIdSales', 52);
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (c) =>
                                                      DetailCrmSalesScreen(
                                                        str: 'FEBRI',
                                                      )));
                                        },
                                        child: const Text('Febri',
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600)),
                                      ),
                                    )),
                                    DataColumn(label: _verticalDivider),
                                    DataColumn(
                                        label: Padding(
                                      padding: const EdgeInsets.only(left: 15),
                                      child: TextButton(
                                        onPressed: () {
                                          sharedPreferences!
                                              .setInt('detailIdSales', 19);
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (c) =>
                                                      DetailCrmSalesScreen(
                                                        str: 'JONATHAN',
                                                      )));
                                        },
                                        child: const Text('Jonathan',
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600)),
                                      ),
                                    )),
                                  ],
                                ),
                              )),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
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
      DataCell(FutureBuilder(
        // future: DbCRM.db.getCountCrmById(1, data.customer_id, 23),
        builder: (context, snapshot) {
          return TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (c) => DetailCrmByCustomer(
                            str: '',
                            salesId: 23,
                            tokoName: data.nama_toko,
                            tokoId: data.customer_id,
                            activityId: 1)));
              },
              child: Text(data.nama_toko ?? ""));
        },
      )),
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
                        return const SizedBox();
                      } else {
                        return SizedBox(
                          width: 100,
                          height: 30,
                          child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (c) =>
                                            DetailActivitySalesScreen(
                                                str: 'WhatsApp Adit',
                                                salesId: 23,
                                                tokoName: data.nama_toko,
                                                tokoId: data.customer_id,
                                                activityId: 1)));
                              },
                              child: Text(
                                'Wa     : ${snapshot.data!.length.toString()}',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: const TextStyle(
                                    fontSize: 15,
                                    color: Colors.green,
                                    fontWeight: FontWeight.w600),
                              )),
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
                        return const SizedBox();
                      } else {
                        return SizedBox(
                          width: 100,
                          height: 33,
                          child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (c) =>
                                            DetailActivitySalesScreen(
                                                str: 'Telephone Adit',
                                                salesId: 23,
                                                tokoName: data.nama_toko,
                                                tokoId: data.customer_id,
                                                activityId: 2)));
                              },
                              child: Text(
                                'Tlp     : ${snapshot.data!.length.toString()}',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: const TextStyle(
                                    fontSize: 15,
                                    color: Colors.blue,
                                    fontWeight: FontWeight.w600),
                              )),
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
                        return const SizedBox();
                      } else {
                        return SizedBox(
                          width: 100,
                          height: 30,
                          child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (c) =>
                                            DetailActivitySalesScreen(
                                                str: 'Visit Adit',
                                                salesId: 23,
                                                tokoName: data.nama_toko,
                                                tokoId: data.customer_id,
                                                activityId: 3)));
                              },
                              child: Text(
                                'Visit   : ${snapshot.data!.length.toString()}',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: const TextStyle(
                                    fontSize: 15,
                                    color: Colors.orange,
                                    fontWeight: FontWeight.w600),
                              )),
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
                        return const SizedBox();
                      } else {
                        return SizedBox(
                          width: 100,
                          height: 30,
                          child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (c) =>
                                            DetailActivitySalesScreen(
                                                str: 'WhatsApp Erick',
                                                salesId: 21,
                                                tokoName: data.nama_toko,
                                                tokoId: data.customer_id,
                                                activityId: 1)));
                              },
                              child: Text(
                                'Wa     : ${snapshot.data!.length.toString()}',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: const TextStyle(
                                    fontSize: 15,
                                    color: Colors.green,
                                    fontWeight: FontWeight.w600),
                              )),
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
                        return const SizedBox();
                      } else {
                        return SizedBox(
                          width: 100,
                          height: 33,
                          child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (c) =>
                                            DetailActivitySalesScreen(
                                                str: 'Telephone Erick',
                                                salesId: 21,
                                                tokoName: data.nama_toko,
                                                tokoId: data.customer_id,
                                                activityId: 2)));
                              },
                              child: Text(
                                'Tlp     : ${snapshot.data!.length.toString()}',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: const TextStyle(
                                    fontSize: 15,
                                    color: Colors.blue,
                                    fontWeight: FontWeight.w600),
                              )),
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
                        return const SizedBox();
                      } else {
                        return SizedBox(
                          width: 100,
                          height: 30,
                          child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (c) =>
                                            DetailActivitySalesScreen(
                                                str: 'Visit Erick',
                                                salesId: 21,
                                                tokoName: data.nama_toko,
                                                tokoId: data.customer_id,
                                                activityId: 3)));
                              },
                              child: Text(
                                'Visit   : ${snapshot.data!.length.toString()}',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: const TextStyle(
                                    fontSize: 15,
                                    color: Colors.orange,
                                    fontWeight: FontWeight.w600),
                              )),
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
                        return const SizedBox();
                      } else {
                        return SizedBox(
                          width: 100,
                          height: 30,
                          child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (c) =>
                                            DetailActivitySalesScreen(
                                                str: 'WhatsApp Febri',
                                                salesId: 52,
                                                tokoName: data.nama_toko,
                                                tokoId: data.customer_id,
                                                activityId: 1)));
                              },
                              child: Text(
                                'Wa     : ${snapshot.data!.length.toString()}',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: const TextStyle(
                                    fontSize: 15,
                                    color: Colors.green,
                                    fontWeight: FontWeight.w600),
                              )),
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
                        return const SizedBox();
                      } else {
                        return SizedBox(
                          width: 100,
                          height: 33,
                          child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (c) =>
                                            DetailActivitySalesScreen(
                                                str: 'Telephone Febri',
                                                salesId: 52,
                                                tokoName: data.nama_toko,
                                                tokoId: data.customer_id,
                                                activityId: 2)));
                              },
                              child: Text(
                                'Tlp     : ${snapshot.data!.length.toString()}',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: const TextStyle(
                                    fontSize: 15,
                                    color: Colors.blue,
                                    fontWeight: FontWeight.w600),
                              )),
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
                        return const SizedBox();
                      } else {
                        return SizedBox(
                          width: 100,
                          height: 30,
                          child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (c) =>
                                            DetailActivitySalesScreen(
                                                str: 'Visit Febri',
                                                salesId: 52,
                                                tokoName: data.nama_toko,
                                                tokoId: data.customer_id,
                                                activityId: 3)));
                              },
                              child: Text(
                                'Visit   : ${snapshot.data!.length.toString()}',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: const TextStyle(
                                    fontSize: 15,
                                    color: Colors.orange,
                                    fontWeight: FontWeight.w600),
                              )),
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
                        return const SizedBox();
                      } else {
                        return SizedBox(
                          width: 100,
                          height: 30,
                          child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (c) =>
                                            DetailActivitySalesScreen(
                                                str: 'WhatsApp Jonathan',
                                                salesId: 19,
                                                tokoName: data.nama_toko,
                                                tokoId: data.customer_id,
                                                activityId: 1)));
                              },
                              child: Text(
                                'Wa     : ${snapshot.data!.length.toString()}',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: const TextStyle(
                                    fontSize: 15,
                                    color: Colors.green,
                                    fontWeight: FontWeight.w600),
                              )),
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
                        return const SizedBox();
                      } else {
                        return SizedBox(
                          width: 100,
                          height: 33,
                          child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (c) =>
                                            DetailActivitySalesScreen(
                                                str: 'Telephone Jonathan',
                                                salesId: 19,
                                                tokoName: data.nama_toko,
                                                tokoId: data.customer_id,
                                                activityId: 2)));
                              },
                              child: Text(
                                'Tlp     : ${snapshot.data!.length.toString()}',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: const TextStyle(
                                    fontSize: 15,
                                    color: Colors.blue,
                                    fontWeight: FontWeight.w600),
                              )),
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
                        return const SizedBox();
                      } else {
                        return SizedBox(
                          width: 100,
                          height: 30,
                          child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (c) =>
                                            DetailActivitySalesScreen(
                                                str: 'Visit Jonathan',
                                                salesId: 19,
                                                tokoName: data.nama_toko,
                                                tokoId: data.customer_id,
                                                activityId: 3)));
                              },
                              child: Text(
                                'Visit   : ${snapshot.data!.length.toString()}',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: const TextStyle(
                                    fontSize: 15,
                                    color: Colors.orange,
                                    fontWeight: FontWeight.w600),
                              )),
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

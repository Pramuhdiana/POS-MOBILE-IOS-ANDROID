// ignore_for_file: avoid_print, non_constant_identifier_names, sized_box_for_whitespace, depend_on_referenced_packages

import 'package:dio/dio.dart';
import 'package:e_shop/api/api_constant.dart';
import 'package:e_shop/global/global.dart';
import 'package:e_shop/splashScreen/transaksi_gagal.dart';
import 'package:e_shop/widgets/custom_dialog.dart';
import 'package:e_shop/widgets/custom_loading.dart';
import 'package:e_shop/widgets/keyboard_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:http/http.dart' as http;
import 'package:awesome_dialog/awesome_dialog.dart';

// ignore: use_key_in_widget_constructors
class SetDiskonScreen extends StatefulWidget {
  @override
  State<SetDiskonScreen> createState() => _SetDiskonScreenState();
}

class _SetDiskonScreenState extends State<SetDiskonScreen> {
  FocusNode numberFocusNode = FocusNode();
  FocusNode numberFocusNode2 = FocusNode();
  String token = sharedPreferences!.getString("token").toString();
  List<String> listDiskonDollar = [];
  List<String> listNamaDiskonDollar = [];
  List<List<String>> tanggalDiskonDollar = [];
  List<List<String>> tanggalDiskonRupiah = [];
  List<String> listDiskonRupiah = [];
  List<String> listNamaDiskonRupiah = [];
  List<String> listVoucher = [];
  List<String> listMinTransaksi = [];
  List<String> listNamaVoucher = [];
  List<String> listIdVoucher = [];
  List<int> listRate = [];
  List<bool> isEditable = [];
  bool isLoading = false;
  RoundedLoadingButtonController btnController =
      RoundedLoadingButtonController();
  List<List<bool>> selectedLists = List.generate(
    4, // Jumlah list dalam list utama
    (index) => List.generate(
      31, // Jumlah elemen dalam setiap list dalam list utama
      (index) => false, // Default status pilihan
    ),
  );
  List<List<bool>> selectedListsRupiah = List.generate(
    4, // Jumlah list dalam list utama
    (index) => List.generate(
      31, // Jumlah elemen dalam setiap list dalam list utama
      (index) => false, // Default status pilihan
    ),
  );

  @override
  void initState() {
    super.initState();
    numberFocusNode.addListener(() {
      bool hasFocus = numberFocusNode.hasFocus;
      if (hasFocus) {
        KeyboardOverlay.showOverlay(context);
      } else {
        KeyboardOverlay.removeOverlay();
      }
    });
    numberFocusNode2.addListener(() {
      bool hasFocus = numberFocusNode2.hasFocus;
      if (hasFocus) {
        KeyboardOverlay.showOverlay(context);
      } else {
        KeyboardOverlay.removeOverlay();
      }
    });
    loadData();
  }

  updateDiskonDollar() async {
    String tanggal_diskon1 = tanggalDiskonDollar[0].join(',');
    String tanggal_diskon2 = tanggalDiskonDollar[1].join(',');
    String tanggal_diskon3 = tanggalDiskonDollar[2].join(',');
    String tanggal_diskon4 = tanggalDiskonDollar[3].join(',');

    Map<String, String> body = {
      "id": '1',
      "name": "diskon_dollar",
      "type": "diskon_dollar",
      "diskon1": listDiskonDollar[0],
      "diskon2": listDiskonDollar[1],
      "diskon3": listDiskonDollar[2],
      "diskon4": listDiskonDollar[3],
      "name_diskon1": listNamaDiskonDollar[0],
      "name_diskon2": listNamaDiskonDollar[1],
      "name_diskon3": listNamaDiskonDollar[2],
      "name_diskon4": listNamaDiskonDollar[3],
      "tanggal_diskon1": tanggal_diskon1,
      "tanggal_diskon2": tanggal_diskon2,
      "tanggal_diskon3": tanggal_diskon3,
      "tanggal_diskon4": tanggal_diskon4,
    };

    try {
      final response = await http.post(
          Uri.parse(ApiConstants.baseUrl + ApiConstants.UPDATEdiskon),
          headers: <String, String>{
            'Authorization': 'Bearer $token',
          },
          body: body);
      if (response.statusCode != 200) {
        btnController.error(); //sucses
        btnController.reset();
        // ignore: use_build_context_synchronously
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (c) => TransaksiGagal(
                      title: 'Save diskon gagal',
                      err: response.body,
                    )));
      } else {
        btnController.success(); //sucses
        print(response.body);
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
      }
    } catch (c) {
      btnController.error(); //sucses
      btnController.reset();
      // ignore: use_build_context_synchronously
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (c) => TransaksiGagal(
                    title: 'Save diskon gagal',
                    err: '$c',
                  )));
    }
  }

  updateDiskonRupiah() async {
    String tanggal_diskon1 = tanggalDiskonRupiah[0].join(',');
    String tanggal_diskon2 = tanggalDiskonRupiah[1].join(',');
    String tanggal_diskon3 = tanggalDiskonRupiah[2].join(',');
    String tanggal_diskon4 = tanggalDiskonRupiah[3].join(',');

    Map<String, String> body = {
      "id": '2',
      "name": "diskon_rupiah",
      "type": "diskon_rupiah",
      "diskon1": listDiskonRupiah[0],
      "diskon2": listDiskonRupiah[1],
      "diskon3": listDiskonRupiah[2],
      "diskon4": listDiskonRupiah[3],
      "name_diskon1": listNamaDiskonRupiah[0],
      "name_diskon2": listNamaDiskonRupiah[1],
      "name_diskon3": listNamaDiskonRupiah[2],
      "name_diskon4": listNamaDiskonRupiah[3],
      "tanggal_diskon1": tanggal_diskon1,
      "tanggal_diskon2": tanggal_diskon2,
      "tanggal_diskon3": tanggal_diskon3,
      "tanggal_diskon4": tanggal_diskon4,
    };
    try {
      final response = await http.post(
          Uri.parse(ApiConstants.baseUrl + ApiConstants.UPDATEdiskon),
          headers: <String, String>{
            'Authorization': 'Bearer $token',
          },
          body: body);
      if (response.statusCode != 200) {
        btnController.error(); //sucses
        btnController.reset();
        // ignore: use_build_context_synchronously
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (c) => TransaksiGagal(
                      title: 'Save diskon gagal',
                      err: response.body,
                    )));
      } else {
        btnController.success(); //sucses
        print(response.body);
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
      }
    } catch (c) {
      btnController.error(); //sucses
      btnController.reset();
      // ignore: use_build_context_synchronously
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (c) => TransaksiGagal(
                    title: 'Save diskon gagal',
                    err: '$c',
                  )));
    }
  }

  updateVocher(
      String id, String name, String nominal, String minimalProduk) async {
    Map<String, String> body = {
      "id": id,
      "name": name,
      "nilai_rupiah": nominal,
      "minimal_produk": minimalProduk,
    };
    try {
      final response = await http.post(
          Uri.parse(ApiConstants.baseUrl + ApiConstants.UPDATEvocher),
          headers: <String, String>{
            'Authorization': 'Bearer $token',
          },
          body: body);
      if (response.statusCode != 200) {
        btnController.error(); //sucses
        btnController.reset();
        // ignore: use_build_context_synchronously
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (c) => TransaksiGagal(
                      title: 'Save vocher gagal',
                      err: response.body,
                    )));
      } else {
        btnController.success(); //sucses
        // ignore: use_build_context_synchronously
      }
    } catch (c) {
      btnController.error(); //sucses
      btnController.reset();
      // ignore: use_build_context_synchronously
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (c) => TransaksiGagal(
                    title: 'Save vocher gagal',
                    err: '$c',
                  )));
    }
  }

  @override
  void dispose() {
    // Clean up the focus node
    numberFocusNode.dispose();
    numberFocusNode2.dispose();
    super.dispose();
  }

  loadData() async {
    setState(() {
      isLoading = true;
    });
    await getDiskon();
    // for (int i = 0; i < tanggalDiskonDollar.length; i++) {
    //   for (int j = 0; j < tanggalDiskonDollar[i].length; j++) {
    //     List<int> tanggalList = tanggalDiskonDollar[i][j]
    //         .split(",")
    //         .map((str) => int.parse(str))
    //         .toList();

    //     // Lakukan sesuatu dengan tanggalList di sini
    //     // Tandai tanggal yang ada dalam daftar tanggal
    //     for (int tanggal in tanggalList) {
    //       selectedLists[i][tanggal - 1] = true;
    //     }
    //   }
    // }
    // for (int i = 0; i < tanggalDiskonRupiah.length; i++) {
    //   for (int j = 0; j < tanggalDiskonRupiah[i].length; j++) {
    //     List<int> tanggalListRupiah = tanggalDiskonRupiah[i][j]
    //         .split(",")
    //         .map((str) => int.parse(str))
    //         .toList();

    //     // Lakukan sesuatu dengan tanggalList di sini
    //     // Tandai tanggal yang ada dalam daftar tanggal
    //     for (int tanggal in tanggalListRupiah) {
    //       selectedListsRupiah[i][tanggal - 1] = true;
    //     }
    //   }
    // }
    await getVocher();

    setState(() {
      isLoading = false;
    });
  }

  getDiskon() async {
    listDiskonDollar = [];
    listDiskonRupiah = [];
    tanggalDiskonDollar.clear();
    tanggalDiskonRupiah.clear();

    try {
      var url = ApiConstants.baseUrl + ApiConstants.GETlimitdiskon;
      Response response = await Dio().get(url,
          options: Options(headers: {"Authorization": "Bearer $token"}));
      var dataDollar = response.data[0];
      var dataRupiah = response.data[1];
      listDiskonDollar.add(dataDollar['diskon1'].toString());
      listDiskonDollar.add(dataDollar['diskon2'].toString());
      listDiskonDollar.add(dataDollar['diskon3'].toString());
      listDiskonDollar.add(dataDollar['diskon4'].toString());
      listNamaDiskonDollar.add(dataDollar['name_diskon1'].toString());
      listNamaDiskonDollar.add(dataDollar['name_diskon2'].toString());
      listNamaDiskonDollar.add(dataDollar['name_diskon3'].toString());
      listNamaDiskonDollar.add(dataDollar['name_diskon4'].toString());
      listDiskonRupiah.add(dataRupiah['diskon1'].toString());
      listDiskonRupiah.add(dataRupiah['diskon2'].toString());
      listDiskonRupiah.add(dataRupiah['diskon3'].toString());
      listDiskonRupiah.add(dataRupiah['diskon4'].toString());
      listNamaDiskonRupiah.add(dataRupiah['name_diskon1'].toString());
      listNamaDiskonRupiah.add(dataRupiah['name_diskon2'].toString());
      listNamaDiskonRupiah.add(dataRupiah['name_diskon3'].toString());
      listNamaDiskonRupiah.add(dataRupiah['name_diskon4'].toString());
      tanggalDiskonDollar
          .add([(dataDollar['tanggal_diskon1'] ?? '').toString()]);
      tanggalDiskonDollar
          .add([(dataDollar['tanggal_diskon2'] ?? '').toString()]);
      tanggalDiskonDollar
          .add([(dataDollar['tanggal_diskon3'] ?? '').toString()]);
      tanggalDiskonDollar
          .add([(dataDollar['tanggal_diskon4'] ?? '').toString()]);
      tanggalDiskonRupiah
          .add([(dataRupiah['tanggal_diskon1'] ?? '').toString()]);
      tanggalDiskonRupiah
          .add([(dataRupiah['tanggal_diskon2'] ?? '').toString()]);
      tanggalDiskonRupiah
          .add([(dataRupiah['tanggal_diskon3'] ?? '').toString()]);
      tanggalDiskonRupiah
          .add([(dataRupiah['tanggal_diskon4'] ?? '').toString()]);
      setState(() {
        print(tanggalDiskonDollar);
        print(tanggalDiskonRupiah);
      });
    } catch (e) {
      // ignore: use_build_context_synchronously
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (c) => TransaksiGagal(
                    title: 'Error Get blacklist',
                    err: '$e',
                  )));
    }

    try {
      var urlRate = ApiConstants.baseUrl + ApiConstants.GETlistrate;
      Response response = await Dio().get(urlRate,
          options: Options(headers: {"Authorization": "Bearer $token"}));
      var dataRate = response.data;
      for (var i = 0; i < dataRate.length; i++) {
        listRate.add(int.parse(dataRate[i]['rate']));
      }
      setState(() {
        print(listRate);
      });
    } catch (e) {
      // ignore: use_build_context_synchronously
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (c) => TransaksiGagal(
                    title: 'Error Get rate',
                    err: '$e',
                  )));
    }
  }

  getVocher() async {
    listVoucher = [];
    listNamaVoucher = [];
    listIdVoucher = [];
    listMinTransaksi = [];

    try {
      var url = ApiConstants.baseUrl + ApiConstants.GETVocherBB;
      Response response = await Dio().get(url,
          options: Options(headers: {"Authorization": "Bearer $token"}));

      List<dynamic> responseData =
          response.data; // Akses properti 'data' dari respons

      for (int i = 0; i < responseData.length; i++) {
        listVoucher.add(responseData[i]['nilai_rupiah'].toString());
        listNamaVoucher.add(responseData[i]['name'].toString());
        listIdVoucher.add(responseData[i]['id'].toString());
        listMinTransaksi.add(responseData[i]['minimal_produk'].toString());
        // Lakukan sesuatu dengan setiap item dalam respons di sini
      }
      setState(() {});
    } catch (e) {
      // ignore: use_build_context_synchronously
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (c) => TransaksiGagal(
                    title: 'Error Get Voucher',
                    err: '$e',
                  )));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
          "SET DISCOUNT",
          style: TextStyle(
              fontSize: 25, color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: isLoading == true
          ? Center(
              child: Container(
                  padding: const EdgeInsets.all(0),
                  width: 90,
                  height: 90,
                  child: Lottie.asset("json/loading_black.json")),
            )
          : SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: ExpansionTile(
                        title: Container(
                          constraints: const BoxConstraints(maxHeight: 18),
                          width: double.infinity,
                          child: Row(
                            children: [
                              Flexible(
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'List Discount Event (dollar \$.)',
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.grey.shade600,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        children: [
                          Container(
                            height: 300,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade500.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  for (int i = 0;
                                      i < listDiskonDollar.length;
                                      i++)
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          //* HINTS
                                          Expanded(
                                            child: SizedBox(
                                              child: TextFormField(
                                                initialValue:
                                                    listNamaDiskonDollar[i],
                                                style: const TextStyle(
                                                    fontSize: 25),
                                                onChanged: (value) {
                                                  listNamaDiskonDollar[i] =
                                                      value; // Simpan nilai saat teks berubah
                                                },
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 80,
                                            child: TextFormField(
                                              initialValue: listDiskonDollar[i],
                                              style:
                                                  const TextStyle(fontSize: 25),
                                              keyboardType: const TextInputType
                                                  .numberWithOptions(
                                                  decimal: true),
                                              inputFormatters: <TextInputFormatter>[
                                                FilteringTextInputFormatter
                                                    .allow(RegExp(
                                                        r'^\d+\.?\d{0,2}')),
                                              ], // Memperbolehkan input desimal dengan maksimal 2 digit di belakang koma

                                              onChanged: (value) {
                                                setState(() {
                                                  listDiskonDollar[i] =
                                                      value; // Simpan nilai saat teks berubah
                                                  if (value.isNotEmpty) {
                                                    double enteredValue =
                                                        double.tryParse(
                                                                value) ??
                                                            0;
                                                    if (enteredValue > 100) {
                                                      //*HINTS Panggil fungsi showCustomDialog
                                                      showCustomDialog(
                                                        context: context,
                                                        dialogType:
                                                            DialogType.warning,
                                                        title: 'Max diskon 100',
                                                        description: '',
                                                      );
                                                    }
                                                  }
                                                });
                                              },
                                            ),
                                          ),
                                          const Text(
                                            '%',
                                            style: TextStyle(fontSize: 25),
                                          ),
                                          IconButton(
                                              onPressed: () {
                                                showGeneralDialog(
                                                    transitionDuration:
                                                        const Duration(
                                                            milliseconds: 200),
                                                    barrierDismissible: false,
                                                    barrierLabel: '',
                                                    context: context,
                                                    pageBuilder: (context,
                                                        animation1,
                                                        animation2) {
                                                      return const Text('');
                                                    },
                                                    barrierColor: Colors.black
                                                        .withOpacity(0.5),
                                                    transitionBuilder: (context,
                                                        a1, a2, widget) {
                                                      return Transform.scale(
                                                          scale: a1.value,
                                                          child: Opacity(
                                                              opacity: a1.value,
                                                              child:
                                                                  StatefulBuilder(
                                                                builder: (context,
                                                                        setState) =>
                                                                    AlertDialog(
                                                                  shape: RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              8)),
                                                                  content:
                                                                      SizedBox(
                                                                    child:
                                                                        SingleChildScrollView(
                                                                      scrollDirection:
                                                                          Axis.vertical,
                                                                      child:
                                                                          Column(
                                                                        children: [
                                                                          Text(
                                                                            'Choose a date ${listNamaDiskonDollar[i]}',
                                                                            style: const TextStyle(
                                                                                color: Colors.black,
                                                                                fontSize: 18,
                                                                                fontWeight: FontWeight.bold),
                                                                          ),
                                                                          for (var j = 0;
                                                                              j < 31;
                                                                              j++)
                                                                            Container(
                                                                              padding: const EdgeInsets.only(top: 15),
                                                                              child: Row(
                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                children: [
                                                                                  ElevatedButton(
                                                                                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0))),
                                                                                    onPressed: () {
                                                                                      setState(() {
                                                                                        selectedLists[i][j] = !selectedLists[i][j]; //* HINTS Mengubah nilai selectedList[j] menjadi kebalikan dari nilai sebelumnya
                                                                                      });
                                                                                    },
                                                                                    child: SizedBox(
                                                                                      width: 150,
                                                                                      child: Text(
                                                                                        '${j + 1}',
                                                                                        textAlign: TextAlign.center, // Menengahkan teks secara horizontal
                                                                                        style: const TextStyle(fontSize: 16),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  Checkbox(value: selectedLists[i][j], onChanged: null)
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          Container(
                                                                            width:
                                                                                350,
                                                                            padding:
                                                                                const EdgeInsets.only(top: 15),
                                                                            child: ElevatedButton(
                                                                                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0))),
                                                                                onPressed: () {
                                                                                  Navigator.pop(context);
                                                                                  for (int i = 0; i < selectedLists.length; i++) {
                                                                                    List<String> selectedDates = [];
                                                                                    for (int j = 0; j < selectedLists[i].length; j++) {
                                                                                      if (selectedLists[i][j]) {
                                                                                        selectedDates.add((j + 1).toString());
                                                                                      }
                                                                                    }
                                                                                    tanggalDiskonDollar[i] = [
                                                                                      selectedDates.join(",")
                                                                                    ];
                                                                                  }
                                                                                },
                                                                                child: const Text('Simpan')),
                                                                          ),
                                                                          Container(
                                                                            width:
                                                                                350,
                                                                            padding:
                                                                                const EdgeInsets.only(top: 15),
                                                                            child: ElevatedButton(
                                                                                style: ElevatedButton.styleFrom(backgroundColor: Colors.red, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0))),
                                                                                onPressed: () {
                                                                                  Navigator.pop(context);
                                                                                },
                                                                                child: const Text('Batal')),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              )));
                                                    });
                                              },
                                              icon: const Icon(
                                                  Icons.edit_calendar_outlined))
                                        ],
                                      ),
                                    ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 0),
                                      child: CustomLoadingButton(
                                        controller: btnController,
                                        onPressed: () {
                                          updateDiskonDollar();
                                          showSimpleNotification(
                                            const Text('Success'),
                                            background: Colors.green,
                                            duration:
                                                const Duration(seconds: 1),
                                          );
                                        },
                                        child: const Text(
                                          "Save Discount (\$)",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  //? list rupiah
                  Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: ExpansionTile(
                        title: Container(
                          constraints: const BoxConstraints(maxHeight: 18),
                          width: double.infinity,
                          child: Row(
                            children: [
                              Flexible(
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'List Discount Event (rupiah Rp.)',
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.grey.shade600,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        children: [
                          Container(
                            height: 300,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade500.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  for (int i = 0;
                                      i < listDiskonRupiah.length;
                                      i++)
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          //* HINTS
                                          Expanded(
                                            child: SizedBox(
                                              child: TextFormField(
                                                initialValue:
                                                    listNamaDiskonRupiah[i],
                                                style: const TextStyle(
                                                    fontSize: 25),
                                                onChanged: (value) {
                                                  listNamaDiskonRupiah[i] =
                                                      value; // Simpan nilai saat teks berubah
                                                },
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 80,
                                            child: TextFormField(
                                              initialValue: listDiskonRupiah[i],
                                              style:
                                                  const TextStyle(fontSize: 25),
                                              keyboardType: const TextInputType
                                                  .numberWithOptions(
                                                  decimal: true),
                                              inputFormatters: <TextInputFormatter>[
                                                FilteringTextInputFormatter
                                                    .allow(RegExp(
                                                        r'^\d+\.?\d{0,2}')),
                                              ], // Memperbolehkan input desimal dengan maksimal 2 digit di belakang koma
                                              onChanged: (value) {
                                                setState(() {
                                                  if (value.isNotEmpty) {
                                                    listDiskonRupiah[i] =
                                                        value; // Simpan nilai saat teks berubah

                                                    double enteredValue =
                                                        double.tryParse(
                                                                value) ??
                                                            0;
                                                    if (enteredValue > 100) {
                                                      // Tampilkan pemberitahuan jika nilai melebihi 100
                                                      showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return AlertDialog(
                                                              shape: RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8)),
                                                              title: const Text(
                                                                'Diskon tidak bisa lebih dari 100',
                                                              ),
                                                            );
                                                          });
                                                    }
                                                  }
                                                });
                                              },
                                            ),
                                          ),

                                          const Text(
                                            '%',
                                            style: TextStyle(fontSize: 25),
                                          ),
                                          IconButton(
                                              onPressed: () {
                                                showGeneralDialog(
                                                    transitionDuration:
                                                        const Duration(
                                                            milliseconds: 200),
                                                    barrierDismissible: false,
                                                    barrierLabel: '',
                                                    context: context,
                                                    pageBuilder: (context,
                                                        animation1,
                                                        animation2) {
                                                      return const Text('');
                                                    },
                                                    barrierColor: Colors.black
                                                        .withOpacity(0.5),
                                                    transitionBuilder: (context,
                                                        a1, a2, widget) {
                                                      return Transform.scale(
                                                          scale: a1.value,
                                                          child: Opacity(
                                                              opacity: a1.value,
                                                              child:
                                                                  StatefulBuilder(
                                                                builder: (context,
                                                                        setState) =>
                                                                    AlertDialog(
                                                                  shape: RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              8)),
                                                                  content:
                                                                      SizedBox(
                                                                    child:
                                                                        SingleChildScrollView(
                                                                      scrollDirection:
                                                                          Axis.vertical,
                                                                      child:
                                                                          Column(
                                                                        children: [
                                                                          Text(
                                                                            'Choose a date ${listNamaDiskonRupiah[i]}',
                                                                            style: const TextStyle(
                                                                                color: Colors.black,
                                                                                fontSize: 18,
                                                                                fontWeight: FontWeight.bold),
                                                                          ),
                                                                          for (var j = 0;
                                                                              j < 31;
                                                                              j++)
                                                                            Container(
                                                                              padding: const EdgeInsets.only(top: 15),
                                                                              child: Row(
                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                children: [
                                                                                  ElevatedButton(
                                                                                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0))),
                                                                                    onPressed: () {
                                                                                      setState(() {
                                                                                        selectedListsRupiah[i][j] = !selectedListsRupiah[i][j]; //* HINTS Mengubah nilai selectedList[j] menjadi kebalikan dari nilai sebelumnya
                                                                                      });
                                                                                    },
                                                                                    child: SizedBox(
                                                                                      width: 150,
                                                                                      child: Text(
                                                                                        '${j + 1}',
                                                                                        textAlign: TextAlign.center, // Menengahkan teks secara horizontal
                                                                                        style: const TextStyle(fontSize: 16),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  Checkbox(value: selectedListsRupiah[i][j], onChanged: null)
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          Container(
                                                                            width:
                                                                                350,
                                                                            padding:
                                                                                const EdgeInsets.only(top: 15),
                                                                            child: ElevatedButton(
                                                                                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0))),
                                                                                onPressed: () {
                                                                                  Navigator.pop(context);
                                                                                  for (int i = 0; i < selectedListsRupiah.length; i++) {
                                                                                    List<String> selectedDates = [];
                                                                                    for (int j = 0; j < selectedListsRupiah[i].length; j++) {
                                                                                      if (selectedListsRupiah[i][j]) {
                                                                                        selectedDates.add((j + 1).toString());
                                                                                      }
                                                                                    }
                                                                                    tanggalDiskonRupiah[i] = [
                                                                                      selectedDates.join(",")
                                                                                    ];
                                                                                  }
                                                                                },
                                                                                child: const Text('Simpan')),
                                                                          ),
                                                                          Container(
                                                                            width:
                                                                                350,
                                                                            padding:
                                                                                const EdgeInsets.only(top: 15),
                                                                            child: ElevatedButton(
                                                                                style: ElevatedButton.styleFrom(backgroundColor: Colors.red, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0))),
                                                                                onPressed: () {
                                                                                  Navigator.pop(context);
                                                                                },
                                                                                child: const Text('Batal')),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              )));
                                                    });
                                              },
                                              icon: const Icon(
                                                  Icons.edit_calendar_outlined))
                                        ],
                                      ),
                                    ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 0),
                                      child: CustomLoadingButton(
                                        controller: btnController,
                                        onPressed: () {
                                          updateDiskonRupiah();
                                          showSimpleNotification(
                                            const Text('Success'),
                                            background: Colors.green,
                                            duration:
                                                const Duration(seconds: 1),
                                          );
                                        },
                                        child: const Text(
                                          "Save Discount (Rp.)",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  //? List voucher
                  Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: ExpansionTile(
                        title: Container(
                          constraints: const BoxConstraints(maxHeight: 18),
                          width: double.infinity,
                          child: Row(
                            children: [
                              Flexible(
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'List Voucher Event',
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.grey.shade600,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        children: [
                          Container(
                            height: 700,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade500.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  for (int i = 0; i < listVoucher.length; i++)
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              //* HINTS
                                              SizedBox(
                                                width: 220,
                                                child: TextFormField(
                                                  initialValue:
                                                      listNamaVoucher[i],
                                                  style: const TextStyle(
                                                      fontSize: 25),
                                                  onChanged: (value) {
                                                    setState(() {
                                                      listNamaVoucher[i] =
                                                          value;
                                                    });
                                                  },
                                                ),
                                              ),
                                              Expanded(
                                                child: SizedBox(
                                                  child: TextFormField(
                                                    initialValue:
                                                        listVoucher[i],
                                                    style: const TextStyle(
                                                        fontSize: 25),
                                                    keyboardType:
                                                        const TextInputType
                                                            .numberWithOptions(
                                                            decimal: true),
                                                    inputFormatters: <TextInputFormatter>[
                                                      FilteringTextInputFormatter
                                                          .digitsOnly,
                                                    ],
                                                    onChanged: (value) {
                                                      setState(() {
                                                        listVoucher[i] = value;
                                                      });
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              //* HINTS
                                              const SizedBox(
                                                width: 220,
                                                child: Text(
                                                  'Min Transaksi',
                                                  style:
                                                      TextStyle(fontSize: 25),
                                                ),
                                              ),
                                              Expanded(
                                                child: SizedBox(
                                                  child: TextFormField(
                                                    initialValue:
                                                        listMinTransaksi[i],
                                                    style: const TextStyle(
                                                        fontSize: 25),
                                                    keyboardType:
                                                        const TextInputType
                                                            .numberWithOptions(
                                                            decimal: true),
                                                    inputFormatters: <TextInputFormatter>[
                                                      FilteringTextInputFormatter
                                                          .digitsOnly,
                                                    ],
                                                    onChanged: (value) {
                                                      setState(() {
                                                        listMinTransaksi[i] =
                                                            value;
                                                      });
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 0),
                                      child: CustomLoadingButton(
                                        controller: btnController,
                                        onPressed: () {
                                          updateDiskon();
                                        },
                                        child: const Text(
                                          "Save Voucher",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
    );
  }

  updateDiskon() async {
    for (int i = 0; i < listVoucher.length; i++) {
      await updateVocher(listIdVoucher[i], listNamaVoucher[i], listVoucher[i],
          listMinTransaksi[i]);
    }
    showSimpleNotification(
      const Text('Success'),
      background: Colors.green,
      duration: const Duration(seconds: 1),
    );
    // ignore: use_build_context_synchronously
    Navigator.pop(context);
  }
}

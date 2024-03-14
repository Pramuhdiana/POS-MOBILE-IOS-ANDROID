// ignore_for_file: library_private_types_in_public_api, avoid_print, prefer_const_literals_to_create_immutables, unnecessary_string_interpolations, use_build_context_synchronously, unused_local_variable, unused_element, prefer_const_constructors, unnecessary_new, prefer_collection_literals, non_constant_identifier_names, unused_import

import 'package:dio/dio.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:e_shop/api/api_constant.dart';
import 'package:e_shop/api/api_services.dart';
import 'package:e_shop/database/db_alldetailtransaksi.dart';
import 'package:e_shop/database/db_alltransaksi.dart';
import 'package:e_shop/database/db_alltransaksi_baru.dart';
import 'package:e_shop/event/add_customer_event.dart';
import 'package:e_shop/event/cart_event_screen.dart';
import 'package:e_shop/models/user_model.dart';
import 'package:e_shop/provider/provider_cart_event.dart';
import 'package:e_shop/splashScreen/my_splas_screen_transaksi.dart';
import 'package:e_shop/splashScreen/transaksi_gagal.dart';
import 'package:e_shop/widgets/custom_loading.dart';
import 'package:e_shop/widgets/keyboard_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:http/http.dart' as http;

import '../global/currency_format.dart';
import '../global/global.dart';

// ignore: must_be_immutable
class TransaksiScreenEvent extends StatefulWidget {
  String lotNumber = '';
  String pricePerBarang = '';

  TransaksiScreenEvent(
      {super.key, required this.lotNumber, required this.pricePerBarang});

  @override
  _TransaksiScreenEventState createState() => _TransaksiScreenEventState();
}

class _TransaksiScreenEventState extends State<TransaksiScreenEvent> {
  final NumberFormat _currencyFormatter =
      NumberFormat.currency(symbol: 'Rp ', decimalDigits: 0, locale: 'id-ID');
  FocusNode numberFocusNodeSurprise = FocusNode();
  FocusNode numberFocusNode = FocusNode();
  FocusNode numberFocusNode2 = FocusNode();
  FocusNode numberFocusNode3 = FocusNode();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  RoundedLoadingButtonController btnController =
      RoundedLoadingButtonController();
  List<String> listBlacklistLot = [];
  bool isBlaclist = false;
  String? kodeVocher;
  int nilaiVocher = 0;
  List<String> gimmick = [];
  bool isClear = false;
  bool isSurprise = false;
  bool isDiskon1 = false;
  bool isDiskon2 = false;
  bool isDiskon3 = false;
  bool isDiskon4 = false;
  int getLimitAddDis1 = 0;
  int getLimitAddDis2 = 0;
  int getLimitAddDis3 = 0;
  int getLimitSurprise = 0;
  List<String> listTanggalDiskon1 = [];
  List<String> listTanggalDiskon2 = [];
  List<String> listTanggalDiskon3 = [];
  List<String> listTanggalDiskon4 = [];
  List<String> listTanggalSurprise = [];
  String valueSurprise = '';
  String qty = '';
  String orderId = DateTime.now().second.toString();
  String uid = '';
  String? form;
  String? toko;
  int? idtoko = 0;
  double wid = 80;
  int idform = 0;
  int idformAPI = 0;
  int rate = 1;
  int diskonrequest = 90;
  int result = 0;
  bool isGift = false;
  bool isVoriskin = false;
  bool isVbb500 = false;
  bool isVbb250 = false;
  bool isVbb100 = false;
  bool isVbb50 = false;
  bool isTaspink = false;
  bool isPouchbb = false;
  bool isLm025 = false;
  bool isLm05 = false;
  bool isCash500 = false;
  bool isLoading = false;

  int dumDiskon = 0;
  int diskon = 0;
  TextEditingController dp = TextEditingController();
  TextEditingController addSurprise = TextEditingController();
  TextEditingController addDiskon = TextEditingController();
  TextEditingController addDiskon2 = TextEditingController();
  TextEditingController addDiskon3 = TextEditingController();
  String tanggalNow = '';
  int dpp = 0;
  int addesdiskon = 0;
  int addesdiskon2 = 0;
  int addesdiskon3 = 0;
  int surpriseApi = 0;
  String? idBarang = '';
  bool isRupiah = false;

  List<Map<String, dynamic>> vocherList = [];
  List<String> listNamaDiskon = [];

  final _formKey = GlobalKey<FormState>();

  double get totalPrice {
    // var dpin = int.parse(dp);
    var total = ((context.read<PCartEvent>().totalPrice2) * rate) *
            (1 - (diskon / 100)) *
            (1 - (surpriseApi / 100)) -
        dpp -
        addesdiskon -
        nilaiVocher -
        addesdiskon2 -
        addesdiskon3;
    return total;
  }

  double get totalPriceSurprise {
    // var dpin = int.parse(dp);
    var total = ((context.read<PCartEvent>().totalPrice2) * rate) *
        (1 - (diskon / 100)) *
        ((surpriseApi / 100));
    return total;
  }

  // double get limitDisSurprise {
  //   // var dpin = int.parse(dp);
  //   var totalAwal = ((context.read<PCartEvent>().totalPrice2) * rate) *
  //       (1 - (diskon / 100));
  //   var total = ((context.read<PCartEvent>().totalPrice2) * rate) *
  //       (1 - (diskon / 100));
  //   var max = totalAwal - (total * (1 - (getLimitSurprise / 100)));
  //   return max;
  // }

  double get limitDis1 {
    // var dpin = int.parse(dp);
    var totalAwal = ((context.read<PCartEvent>().totalPrice2) * rate) *
        (1 - (diskon / 100)) *
        (1 - (surpriseApi / 100));
    var total = ((context.read<PCartEvent>().totalPrice2) * rate) *
        (1 - (diskon / 100)) *
        (1 - (surpriseApi / 100));
    var max10 = totalAwal - (total * (1 - (getLimitAddDis1 / 100)));
    return max10;
  }

  double get limitDis2 {
    // var dpin = int.parse(dp);
    var totalAwal = ((context.read<PCartEvent>().totalPrice2) * rate) *
            (1 - (diskon / 100)) *
            (1 - (surpriseApi / 100)) -
        addesdiskon;
    var total = ((context.read<PCartEvent>().totalPrice2) * rate) *
            (1 - (diskon / 100)) *
            (1 - (surpriseApi / 100)) -
        addesdiskon;
    var max10 = totalAwal - (total * (1 - (getLimitAddDis2 / 100)));
    return max10;
  }

  double get limitDis3 {
    // var dpin = int.parse(dp);
    var totalAwal = ((context.read<PCartEvent>().totalPrice2) * rate) *
            (1 - (diskon / 100)) *
            (1 - (surpriseApi / 100)) -
        addesdiskon -
        addesdiskon2;
    var total = ((context.read<PCartEvent>().totalPrice2) * rate) *
            (1 - (diskon / 100)) *
            (1 - (surpriseApi / 100)) -
        addesdiskon -
        addesdiskon2;
    var max10 = totalAwal - (total * (1 - (getLimitAddDis3 / 100)));
    return max10;
  }

  double get disSurprise {
    var totalAwal = ((context.read<PCartEvent>().totalPrice2) * rate) *
        (1 - (diskon / 100));
    var addDis1 = addesdiskon;
    var result = (addDis1 / totalAwal) * 100;
    return result;
  }

  double get disAdd1 {
    var totalAwal = ((context.read<PCartEvent>().totalPrice2) * rate) *
        (1 - (diskon / 100)) *
        (1 - (surpriseApi / 100));
    var addDis1 = addesdiskon;
    var result = (addDis1 / totalAwal) * 100;
    return result;
  }

  double get disAdd2 {
    var totalAwal = ((context.read<PCartEvent>().totalPrice2) * rate) *
            (1 - (diskon / 100)) *
            (1 - (surpriseApi / 100)) -
        addesdiskon;
    var addDis2 = addesdiskon2;
    var result = (addDis2 / totalAwal) * 100;

    return addDiskon.text.isEmpty ? 0 : result;
  }

  double get disAdd3 {
    var totalAwal = ((context.read<PCartEvent>().totalPrice2) * rate) *
            (1 - (diskon / 100)) *
            (1 - (surpriseApi / 100)) -
        addesdiskon -
        addesdiskon2;
    var addDis3 = addesdiskon3;
    var result = (addDis3 / totalAwal) * 100;
    return result;
  }

  String get totalPrice3 {
    // var dpin = int.parse(dp);

    var total = ((context.read<PCartEvent>().totalPrice2) * rate) *
            (1 - (diskon / 100)) *
            (1 - (surpriseApi / 100)) -
        dpp -
        addesdiskon -
        nilaiVocher -
        addesdiskon2 -
        addesdiskon3;
    if (isGift != true) {
      if (rate <= 2) {
        return 'Rp. ${CurrencyFormat.convertToDollar(total, 0)}';
      } else {
        return CurrencyFormat.convertToIdr(total, 0);
      }
    } else {
      return CurrencyFormat.convertToIdr(0, 0);
    }
  }

  String get totalPriceAPI {
    // var dpin = int.parse(dp);
    var total = ((context.read<PCartEvent>().totalPrice2) * rate) *
            (1 - (diskon / 100)) *
            (1 - (surpriseApi / 100)) -
        dpp -
        addesdiskon -
        nilaiVocher -
        addesdiskon2 -
        addesdiskon3;
    return total.toString();
  }

  String get totalDiskonRp {
    // var dpin = int.parse(dp);
    var total1 = ((context.read<PCartEvent>().totalPrice2) * rate) *
            (1 - (diskon / 100)) *
            (1 - (surpriseApi / 100)) -
        dpp -
        addesdiskon -
        nilaiVocher -
        addesdiskon2 -
        addesdiskon3;
    var total = ((context.read<PCartEvent>().totalPrice2) * rate);
    var result = total - total1;

    return result.toString();
  }

  String get totalRp {
    // var dpin = int.parse(dp);
    var total = ((context.read<PCartEvent>().totalPrice2) * rate);
    return total.toString();
  }

  void showProgress() {
    ProgressDialog progress = ProgressDialog(context: context);
    progress.show(max: 100, msg: 'please wait ..', progressBgColor: Colors.red);
  }

  @override
  void initState() {
    super.initState();
    if (isRupiah) {
      isRupiah = true;
    }
    DateTime today = DateTime.now();
    // tanggalNow = '1';
    tanggalNow = today.day.toString();
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
    numberFocusNode3.addListener(() {
      bool hasFocus = numberFocusNode3.hasFocus;
      if (hasFocus) {
        KeyboardOverlay.showOverlay(context);
      } else {
        KeyboardOverlay.removeOverlay();
      }
    });
    numberFocusNodeSurprise.addListener(() {
      bool hasFocus = numberFocusNodeSurprise.hasFocus;
      if (hasFocus) {
        KeyboardOverlay.showOverlay(context);
      } else {
        KeyboardOverlay.removeOverlay();
      }
    });
    loadData();
  }

  loadData() async {
    setState(() {
      isLoading = true;
    });
    await cekBlacklist();
    await getLimitDiskon();
    await getVoucher();
    idBarang = sharedPreferences!.getString('idBarang');
    isRupiah ? rate = 1 : rate = 16000;
    // sharedPreferences!.getString('role_sales_brand') == '3'
    //     ? idform = 2
    //     : idform = 0;
    //? mode admin
    if (sharedPreferences!.getString('email').toString().toLowerCase() ==
        'andy@sanivokasi.com') {
      setState(() {
        idform = 1;
        idformAPI = 1;
        isRupiah ? diskon = 0 : diskon = 50;
        if (isSurprise == true) {
          // surpriseApi = getLimitSurprise;
          valueSurprise = totalPriceSurprise.toString();
        } else {
          surpriseApi = 0;
          valueSurprise = '0';
        }
        // if (totalPrice <= 2000000) {
        //   isBlaclist = true;
        // }
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  cekBlacklist() async {
    print('blaclist on');
    listBlacklistLot = [];
    String token = sharedPreferences!.getString("token").toString();
    try {
      var url = ApiConstants.baseUrl + ApiConstants.GETblackListM;
      Response response = await Dio().get(url,
          options: Options(headers: {"Authorization": "Bearer $token"}));

      if (response.statusCode == 200) {
        var data = response.data;
        for (var i = 0; i < data.length; i++) {
          listBlacklistLot.add(data[i]['lot']);
        }
        isBlaclist = listBlacklistLot.contains(
            widget.lotNumber); //! hints : cara cek item di daftar list item

        setState(() {});
      } else {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (c) => TransaksiGagal(
                      title: 'Error Get blacklist',
                      err: response.data,
                    )));
      }
    } catch (e) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (c) => TransaksiGagal(
                    title: 'Error Get blacklist',
                    err: '$c',
                  )));
    }
    // try {
    //   final response = await http.get(Uri.parse(
    //       '${ApiConstants.baseUrlsandy}${ApiConstants.GETblackListM}'));
    //   // if response successful
    //   if (response.statusCode == 200) {
    //     List jsonResponse = json.decode(response.body);

    //     var allData =
    //         jsonResponse.map((data) => BlacklistModel.fromJson(data)).toList();
    //     for (var i = 0; i < allData.length; i++) {
    //       listBlacklistLot.add(allData[i].lot); //! nanti ganti dengan theme
    //     }
    //     isBlaclist = listBlacklistLot.contains(
    //         widget.lotNumber); //! hints : cara cek item di daftar list item
    //     print('210420074 = ${listBlacklistLot.contains('210420074')}');
    //   } else {
    //     throw Exception('Unexpected error occured!');
    //   }
    // } catch (c) {
    //   print('Err msg get data : $c');
    //   return throw Exception(c);
    // }
  }

  getLimitDiskon() async {
    try {
      listNamaDiskon = [];
      String token = sharedPreferences!.getString("token").toString();
      var url = ApiConstants.baseUrl + ApiConstants.GETlimitdiskon;
      Response response = await Dio().get(url,
          options: Options(headers: {"Authorization": "Bearer $token"}));
      if (response.statusCode == 200) {
        dumDiskon = isRupiah
            ? int.parse(response.data[1]['diskon1'] ?? '0')
            : int.parse(response.data[0]['diskon1'] ?? '0');
        getLimitAddDis1 = isRupiah
            ? int.parse(response.data[1]['diskon2'] ?? '0')
            : int.parse(response.data[0]['diskon2'] ?? '0');
        getLimitAddDis2 = isRupiah
            ? int.parse(response.data[1]['diskon3'] ?? '0')
            : int.parse(response.data[0]['diskon3'] ?? '0');
        getLimitAddDis3 = isRupiah
            ? int.parse(response.data[1]['diskon4'] ?? '0')
            : int.parse(response.data[0]['diskon4'] ?? '0');
        getLimitSurprise = isBlaclist == true
            ? 0
            : isRupiah
                ? int.parse(response.data[1]['diskon4'] ?? '0')
                : int.parse(response.data[0]['diskon4'] ?? '0');

        var getTanggalDiskon1 = isRupiah
            ? response.data[1]['tanggal_diskon1'] ?? '0'
            : response.data[0]['tanggal_diskon1'] ?? '0';
        var getTanggalDiskon2 = isRupiah
            ? response.data[1]['tanggal_diskon2'] ?? '0'
            : response.data[0]['tanggal_diskon2'] ?? '0';
        var getTanggalDiskon3 = isRupiah
            ? response.data[1]['tanggal_diskon3'] ?? '0'
            : response.data[0]['tanggal_diskon3'] ?? '0';
        var getTanggalDiskon4 = isRupiah
            ? response.data[1]['tanggal_diskon4'] ?? '0'
            : response.data[0]['tanggal_diskon4'] ?? '0';
        var getTanggalSurprise = isRupiah
            ? response.data[1]['tanggal_diskon4'] ?? '0'
            : response.data[0]['tanggal_diskon4'] ?? '0';

        String? nameDiskon1 = isRupiah
            ? response.data[1]['name_diskon1']
            : response.data[0]['name_diskon1'];
        listNamaDiskon.add(nameDiskon1 ?? 'no name');

        String? nameDiskon2 = isRupiah
            ? response.data[1]['name_diskon2']
            : response.data[0]['name_diskon2'];
        listNamaDiskon.add(nameDiskon2 ?? 'no name');
        String? nameDiskon3 = isRupiah
            ? response.data[1]['name_diskon3']
            : response.data[0]['name_diskon3'];
        listNamaDiskon.add(nameDiskon3 ?? 'no name');
        String? nameDiskon4 = isRupiah
            ? response.data[1]['name_diskon4']
            : response.data[0]['name_diskon4'];
        listNamaDiskon.add(nameDiskon4 ?? 'no name');
        print('Tanggal berlaku ${listNamaDiskon[0]} \n $getTanggalDiskon1');
        print('Tanggal berlaku ${listNamaDiskon[1]} \n $getTanggalDiskon2');
        print('Tanggal berlaku ${listNamaDiskon[2]} \n $getTanggalDiskon3');
        print('Tanggal berlaku ${listNamaDiskon[3]} \n $getTanggalDiskon4');
        //* HINTS cara memisahkan data dengan koma menjadi data int
        listTanggalDiskon1 = getTanggalDiskon1.split(',');
        listTanggalDiskon2 = getTanggalDiskon2.split(',');
        listTanggalDiskon3 = getTanggalDiskon3.split(',');
        listTanggalDiskon4 = getTanggalDiskon4.split(',');
        //? looping lebih simple
        for (var item in listTanggalDiskon1) {
          if (item == tanggalNow) {
            print('${listNamaDiskon[0]} on');
            setState(() {
              isDiskon1 = true;
            });
          } else {
            print('${listNamaDiskon[0]} off');
          }
        }
        for (var item in listTanggalDiskon2) {
          if (item == tanggalNow) {
            print('${listNamaDiskon[1]} on');
            setState(() {
              isDiskon2 = true;
            });
          } else {
            print('${listNamaDiskon[1]} off');
          }
        }
        for (var item in listTanggalDiskon3) {
          if (item == tanggalNow) {
            print('${listNamaDiskon[2]} on');
            setState(() {
              isDiskon3 = true;
            });
          } else {
            print('${listNamaDiskon[2]} off');
          }
        }
        for (var item in listTanggalDiskon4) {
          if (item == tanggalNow) {
            print('${listNamaDiskon[3]} on');
            setState(() {
              isDiskon4 = true;
            });
          } else {
            print('${listNamaDiskon[3]} off');
          }
        }
      } else {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (c) => TransaksiGagal(
                      title: 'Error get diskon',
                      err: response.data,
                    )));
      }
    } catch (e) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (c) => TransaksiGagal(
                    title: 'Error get diskon',
                    err: '$e',
                  )));
    }
  }

  getVoucher() async {
    try {
      String token = sharedPreferences!.getString("token").toString();
      var url = ApiConstants.baseUrl + ApiConstants.GETVocherBB;
      Response response = await Dio().get(url,
          options: Options(headers: {"Authorization": "Bearer $token"}));
      if (response.statusCode == 200) {
        //* HINST get vocher dan nominal
        var responseData = response.data;
        // Iterasi setiap objek dalam respons dan tambahkan nama dan nominal ke dalam list
        for (var data in responseData) {
          String name = data["name"].toString();
          int nominal = int.parse((data["nilai_rupiah"] ?? 0).toString());
          int minimalTransaksi =
              int.parse((data["minimal_produk"] ?? 0).toString());

          // Buat map untuk menyimpan nama dan nominal, kemudian tambahkan ke dalam list
          Map<String, dynamic> limitDiskonData = {
            "name": name,
            "nominal": nominal,
            "minimalTransaksi": minimalTransaksi,
          };
          vocherList.add(limitDiskonData);
        }
      } else {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (c) => TransaksiGagal(
                      title: 'Error get voucher',
                      err: response.data,
                    )));
      }
    } catch (e) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (c) => TransaksiGagal(
                    title: 'Error get voucher',
                    err: '$e',
                  )));
    }
  }

  @override
  void dispose() {
    // Clean up the focus node
    numberFocusNode.dispose();
    numberFocusNode2.dispose();
    numberFocusNode3.dispose();
    numberFocusNodeSurprise.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: const Text(
            "Billing Event",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: Image.asset(
              "assets/arrow.png",
              width: 35,
              height: 35,
            ),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (c) => const CartEventScreen()));
            },
          ),
        ),
        body: isLoading == true
            ? Center(
                child: Container(
                    padding: const EdgeInsets.all(0),
                    width: 90,
                    height: 90,
                    child: Lottie.asset("json/loading_black.json")),
              )
            : Padding(
                padding: const EdgeInsets.all(25),
                child: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: ListView(
                    padding: const EdgeInsets.all(4),
                    children: <Widget>[
                      //choose customer
                      // sharedPreferences!.getString('role_sales_brand') == '3'
                      //     ? SizedBox()
                      //     :
                      Container(
                        padding: const EdgeInsets.only(top: 10),
                        height: 80,
                        child: DropdownSearch<UserModel>(
                          asyncItems: (String? filter) => getData(filter),
                          popupProps: PopupPropsMultiSelection.modalBottomSheet(
                            searchFieldProps: TextFieldProps(
                                decoration: InputDecoration(
                              labelText: "Search..",
                              prefixIcon: Icon(Icons.search),
                              //* fungsi add customer
                              suffixIcon: InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (c) =>
                                                AddCustomerEventScreen()));
                                  },
                                  child: Icon(
                                    Icons.add,
                                    color: Colors.black,
                                  )),
                              //! end fungsi
                            )),
                            showSelectedItems: true,
                            itemBuilder: _customPopupItemBuilderExample2,
                            showSearchBox: true,
                          ),
                          compareFn: (item, sItem) => item.id == sItem.id,
                          onChanged: (item) {
                            setState(() {
                              idform = 1;
                              idformAPI = 1;
                              print('toko : ${item?.name}');
                              print('id  : ${item?.id}');
                              print('diskonnya  : ${item?.diskon_customer}');
                              idtoko = item?.id; // menyimpan id toko
                              toko = item?.name; // menyimpan nama toko
                              if (isDiskon1 == true) {
                                diskon = dumDiskon;
                              }
                              if (isSurprise == true) {
                                // surpriseApi = getLimitSurprise;
                                valueSurprise = totalPriceSurprise.toString();
                              } else {
                                surpriseApi = 0;
                                valueSurprise = '0';
                              }
                              if (totalPrice <= 2000000) {
                                isBlaclist = true;
                              }
                              print(isBlaclist);
                              print('value sur: $valueSurprise');
                            });
                          },
                          dropdownDecoratorProps: DropDownDecoratorProps(
                            dropdownSearchDecoration: InputDecoration(
                              labelText: 'Choose customer',
                              filled: true,
                              fillColor: Theme.of(context)
                                  .inputDecorationTheme
                                  .fillColor,
                            ),
                          ),
                        ),
                      ),

                      //? Diskon ke 1

                      idform == 0
                          ? const SizedBox()
                          : isDiskon1 == false
                              ? const SizedBox()
                              : Container(
                                  padding: const EdgeInsets.only(top: 10),
                                  // height: 80,
                                  child: Text(
                                    '${listNamaDiskon[0]} $diskon%',
                                    style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.italic),
                                  )),

                      //diskon ke 2
                      idform == 0
                          ? const SizedBox()
                          : isDiskon2 == false
                              ? const SizedBox()
                              : getLimitAddDis1 == 0
                                  ? SizedBox()
                                  : Stack(clipBehavior: Clip.none, children: [
                                      // getLimitAddDis1.toStringAsFixed(2).length > 6
                                      //     ?
                                      // SizedBox(),
                                      // :
                                      Positioned(
                                        right: 2,
                                        bottom: 15,
                                        child: Text(
                                          '${disAdd1.toStringAsFixed(2)}%',
                                          style: TextStyle(
                                              color: Colors.red,
                                              fontSize: 30,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      sharedPreferences!
                                                  .getString('email')
                                                  .toString()
                                                  .toLowerCase() !=
                                              'andy@sanivokasi.com'
                                          ? SizedBox()
                                          : Positioned(
                                              left: 2,
                                              bottom: 15,
                                              child: Text(
                                                getLimitAddDis1
                                                            .toStringAsFixed(2)
                                                            .length >
                                                        6
                                                    ? 'Limit ${CurrencyFormat.convertToIdr(getLimitAddDis1, 0)}'
                                                    : 'Limit ${getLimitAddDis1.toStringAsFixed(2)}%',
                                                style: TextStyle(
                                                    color: Colors.red,
                                                    fontSize: 10,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                      Container(
                                        padding: const EdgeInsets.only(top: 10),
                                        height: 80,
                                        child: TextFormField(
                                          // enabled: isBlaclist == true
                                          //     ? false
                                          //     : isSurprise == true
                                          //         ? false
                                          //         : true,
                                          style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                          textInputAction: TextInputAction.next,
                                          controller: addDiskon,
                                          focusNode: numberFocusNode,
                                          keyboardType: TextInputType.number,
                                          inputFormatters: <TextInputFormatter>[
                                            FilteringTextInputFormatter
                                                .digitsOnly
                                          ],
                                          onChanged: (valueaddDiskon) {
                                            valueaddDiskon.isEmpty
                                                ? setState(() {
                                                    addesdiskon = 0;
                                                    addesdiskon2 = 0;
                                                    addesdiskon3 = 0;
                                                    addDiskon2.clear();
                                                    addDiskon3.clear();
                                                  })
                                                : setState(() {
                                                    addesdiskon = int.parse(
                                                        valueaddDiskon);
                                                  });

                                            if (getLimitAddDis1
                                                    .toStringAsFixed(2)
                                                    .length >
                                                6) {
                                              addesdiskon > getLimitAddDis1
                                                  ? showDialog(
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
                                                            'Diskon tambahan melebihi limit',
                                                          ),
                                                        );
                                                      })
                                                  : print('oke');
                                            } else {
                                              addesdiskon > limitDis1
                                                  ? showDialog(
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
                                                            'Diskon tambahan melebihi limit',
                                                          ),
                                                        );
                                                      })
                                                  : print('oke');

                                              if (valueaddDiskon.isNotEmpty) {
                                                final numericValue =
                                                    int.parse(valueaddDiskon);
                                                addDiskon.value =
                                                    addDiskon.value.copyWith(
                                                  text: _currencyFormatter
                                                      .format(numericValue),
                                                  selection:
                                                      TextSelection.collapsed(
                                                          offset:
                                                              _currencyFormatter
                                                                  .format(
                                                                      numericValue)
                                                                  .length),
                                                );
                                              }
                                            }
                                          },
                                          decoration: InputDecoration(
                                            labelText: "${listNamaDiskon[1]}",
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5.0)),
                                          ),
                                        ),
                                      ),
                                    ]),

                      idform == 0
                          ? const SizedBox()
                          : isDiskon3 == false
                              ? const SizedBox()
                              : getLimitAddDis2 == 0
                                  ? SizedBox()
                                  : Stack(clipBehavior: Clip.none, children: [
                                      Positioned(
                                        right: 2,
                                        bottom: 15,
                                        child: Text(
                                          addDiskon.text.isEmpty
                                              ? '0'
                                              : '${disAdd2.toStringAsFixed(2)}%',
                                          style: TextStyle(
                                              color: Colors.red,
                                              fontSize: 30,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      sharedPreferences!
                                                  .getString('email')
                                                  .toString()
                                                  .toLowerCase() !=
                                              'andy@sanivokasi.com'
                                          ? SizedBox()
                                          : Positioned(
                                              left: 2,
                                              bottom: 15,
                                              child: Text(
                                                getLimitAddDis2
                                                            .toStringAsFixed(2)
                                                            .length >
                                                        6
                                                    ? 'Limit ${CurrencyFormat.convertToIdr(getLimitAddDis2, 0)}'
                                                    : 'Limit ${getLimitAddDis2.toStringAsFixed(2)}%',
                                                style: TextStyle(
                                                    color: Colors.red,
                                                    fontSize: 10,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                      Container(
                                        padding: const EdgeInsets.only(top: 10),
                                        height: 80,
                                        child: TextFormField(
                                          style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                          textInputAction: TextInputAction.next,
                                          controller: addDiskon2,
                                          focusNode: numberFocusNode2,
                                          keyboardType: TextInputType.number,
                                          inputFormatters: <TextInputFormatter>[
                                            FilteringTextInputFormatter
                                                .digitsOnly
                                          ],
                                          onChanged: (valueaddDiskon2) {
                                            valueaddDiskon2.isEmpty
                                                ? setState(() {
                                                    addesdiskon2 = 0;
                                                  })
                                                : setState(() {
                                                    addesdiskon2 = int.parse(
                                                        valueaddDiskon2);
                                                  });
                                            addesdiskon2 > limitDis2
                                                ? showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertDialog(
                                                        shape:
                                                            RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8)),
                                                        title: const Text(
                                                          'Diskon tambahan melebihi limit',
                                                        ),
                                                      );
                                                    })
                                                : print('oke');
                                            if (valueaddDiskon2.isNotEmpty) {
                                              final numericValue =
                                                  int.parse(valueaddDiskon2);
                                              addDiskon2.value =
                                                  addDiskon2.value.copyWith(
                                                text: _currencyFormatter
                                                    .format(numericValue),
                                                selection:
                                                    TextSelection.collapsed(
                                                        offset:
                                                            _currencyFormatter
                                                                .format(
                                                                    numericValue)
                                                                .length),
                                              );
                                            }
                                          },
                                          decoration: InputDecoration(
                                            labelText: "${listNamaDiskon[2]}",
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5.0)),
                                          ),
                                        ),
                                      ),
                                    ]),

                      //diskon ke 4
                      idform == 0
                          ? const SizedBox()
                          : isDiskon4 == false
                              ? const SizedBox()
                              : getLimitAddDis3 == 0
                                  ? SizedBox()
                                  : Stack(clipBehavior: Clip.none, children: [
                                      Positioned(
                                        right: 2,
                                        bottom: 15,
                                        child: Text(
                                          '${disAdd3.toStringAsFixed(2)}%',
                                          style: TextStyle(
                                              color: Colors.red,
                                              fontSize: 30,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      sharedPreferences!
                                                  .getString('email')
                                                  .toString()
                                                  .toLowerCase() !=
                                              'andy@sanivokasi.com'
                                          ? SizedBox()
                                          : Positioned(
                                              left: 2,
                                              bottom: 15,
                                              child: Text(
                                                getLimitAddDis3
                                                            .toStringAsFixed(2)
                                                            .length >
                                                        6
                                                    ? 'Limit ${CurrencyFormat.convertToIdr(getLimitAddDis3, 0)}'
                                                    : 'Limit ${getLimitAddDis3.toStringAsFixed(2)}%',
                                                style: TextStyle(
                                                    color: Colors.red,
                                                    fontSize: 10,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                      Container(
                                        padding: const EdgeInsets.only(top: 10),
                                        height: 80,
                                        child: TextFormField(
                                          style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                          textInputAction: TextInputAction.next,
                                          controller: addDiskon3,
                                          focusNode: numberFocusNode3,
                                          keyboardType: TextInputType.number,
                                          inputFormatters: <TextInputFormatter>[
                                            FilteringTextInputFormatter
                                                .digitsOnly
                                          ],
                                          onChanged: (valueaddDiskon) {
                                            setState(() {
                                              addesdiskon3 =
                                                  int.parse(valueaddDiskon);
                                            });

                                            if (getLimitAddDis3
                                                    .toStringAsFixed(2)
                                                    .length >
                                                6) {
                                              addesdiskon3 > getLimitAddDis3
                                                  ? showDialog(
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
                                                            'Diskon tambahan melebihi limit',
                                                          ),
                                                        );
                                                      })
                                                  : print('oke');
                                            } else {
                                              addesdiskon3 > limitDis3
                                                  ? showDialog(
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
                                                            'Diskon tambahan melebihi limit',
                                                          ),
                                                        );
                                                      })
                                                  : print('oke');

                                              if (valueaddDiskon.isNotEmpty) {
                                                final numericValue =
                                                    int.parse(valueaddDiskon);
                                                addDiskon3.value =
                                                    addDiskon3.value.copyWith(
                                                  text: _currencyFormatter
                                                      .format(numericValue),
                                                  selection:
                                                      TextSelection.collapsed(
                                                          offset:
                                                              _currencyFormatter
                                                                  .format(
                                                                      numericValue)
                                                                  .length),
                                                );
                                              }
                                            }
                                          },
                                          decoration: InputDecoration(
                                            labelText: "${listNamaDiskon[3]}",
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5.0)),
                                          ),
                                        ),
                                      ),
                                    ]),

                      //DP
                      idform == 0
                          ? const SizedBox()
                          : idform == 4
                              ? const SizedBox()
                              : Row(
                                  children: [
                                    Container(
                                      width: 225,
                                      padding: const EdgeInsets.only(
                                          left: 0, right: 0),
                                      child: DecoratedBox(
                                        decoration: BoxDecoration(
                                            color: kodeVocher != null
                                                ? Colors.black
                                                : const Color.fromRGBO(
                                                    238,
                                                    240,
                                                    235,
                                                    1), //background color of dropdown button
                                            border: Border.all(
                                                color: Colors.black38,
                                                width:
                                                    3), //border of dropdown button
                                            borderRadius: BorderRadius.circular(
                                                50), //border raiuds of dropdown button
                                            boxShadow: const <BoxShadow>[
                                              //apply shadow on Dropdown button
                                              BoxShadow(
                                                  color: Color.fromRGBO(0, 0, 0,
                                                      0.57), //shadow for button
                                                  blurRadius:
                                                      5) //blur radius of shadow
                                            ]),
                                        child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 20, right: 20),
                                            child: DropdownButton(
                                              value: kodeVocher,
                                              items: [
                                                //* HINTS Menambahkan item dari vocherList
                                                for (var item in vocherList)
                                                  if (totalPrice >=
                                                      int.parse(item[
                                                              "minimalTransaksi"]
                                                          .toString()))
                                                    DropdownMenuItem<String>(
                                                      value: item["nominal"]
                                                          .toString(),
                                                      child: Text(item["name"]),
                                                    ),
                                              ],

                                              hint:
                                                  const Text('Select a cupon'),
                                              onChanged: (String? value) {
                                                print('total : $totalPrice');
                                                setState(() {
                                                  kodeVocher = value;
                                                  nilaiVocher =
                                                      int.parse(kodeVocher!);
                                                  isClear = true;
                                                });
                                              },
                                              icon: const Padding(
                                                  padding:
                                                      EdgeInsets.only(left: 20),
                                                  child: Icon(Icons
                                                      .arrow_circle_down_sharp)),
                                              iconEnabledColor: kodeVocher !=
                                                      null
                                                  ? Colors.white //Icon color
                                                  : Colors.black, //Icon color
                                              style: TextStyle(
                                                  color: kodeVocher != null
                                                      ? Colors.white
                                                      : Colors
                                                          .black, //Font color
                                                  fontSize:
                                                      15 //font size on dropdown button
                                                  ),

                                              dropdownColor: kodeVocher != null
                                                  ? Colors.black
                                                  : Colors
                                                      .white, //dropdown background color
                                              underline:
                                                  Container(), //remove underline
                                              isExpanded:
                                                  true, //make true to make width 100%
                                            )),
                                      ),
                                    ),
                                    isClear == false
                                        ? SizedBox(
                                            height: 20,
                                          )
                                        : SizedBox(
                                            width: 80,
                                            child: InkResponse(
                                              onTap: () {
                                                setState(() {
                                                  kodeVocher = null;
                                                  nilaiVocher = 0;
                                                  isClear = false;
                                                });
                                              },
                                              child: Lottie.asset(
                                                  "json/icon_delete.json"),
                                              // child: const CircleAvatar(
                                              //   backgroundColor: Colors.red,
                                              //   child: Icon(Icons.close),
                                              // ),
                                            ),
                                          )
                                  ],
                                ),

                      kodeVocher != null
                          ? Container(
                              padding: EdgeInsets.only(top: 5, left: 15),
                              child: Text(
                                'Diskon Vocher ${CurrencyFormat.convertToIdr(nilaiVocher, 0)}',
                                style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic),
                              ))
                          : SizedBox(),
                      idform == 0
                          ? SizedBox()
                          : Container(
                              alignment: Alignment.bottomLeft,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  //! baris kiri
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: wid,
                                            child: Text(
                                              'Voucher oriskin',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Checkbox(
                                            value: isVoriskin,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                isVoriskin = value!;
                                                isVoriskin == true
                                                    ? gimmick
                                                        .add('Voucher oriskin')
                                                    : gimmick.removeWhere(
                                                        (element) =>
                                                            element ==
                                                            'Voucher oriskin');
                                                print(gimmick);
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: wid,
                                            child: Text(
                                              'Voucher BB 500.000',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Checkbox(
                                            value: isVbb500,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                isVbb500 = value!;
                                                isVbb500 == true
                                                    ? gimmick.add(
                                                        'Voucher BB 500.000')
                                                    : gimmick.removeWhere(
                                                        (element) =>
                                                            element ==
                                                            'Voucher BB 500.000');
                                                print(gimmick);
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: wid,
                                            child: Text(
                                              'Voucher BB 250.000',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Checkbox(
                                            value: isVbb250,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                isVbb250 = value!;
                                                isVbb250 == true
                                                    ? gimmick.add(
                                                        'Voucher BB 250.000')
                                                    : gimmick.removeWhere(
                                                        (element) =>
                                                            element ==
                                                            'Voucher BB 250.000');
                                                print(gimmick);
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: wid,
                                            child: Text(
                                              'Voucher BB 100.000',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Checkbox(
                                            value: isVbb100,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                isVbb100 = value!;
                                                isVbb100 == true
                                                    ? gimmick.add(
                                                        'Voucher BB 100.000')
                                                    : gimmick.removeWhere(
                                                        (element) =>
                                                            element ==
                                                            'Voucher BB 100.000');
                                                print(gimmick);
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: wid,
                                            child: Text(
                                              'Voucher BB 50.000',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Checkbox(
                                            value: isVbb50,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                isVbb50 = value!;
                                                isVbb50 == true
                                                    ? gimmick.add(
                                                        'Voucher BB 50.000')
                                                    : gimmick.removeWhere(
                                                        (element) =>
                                                            element ==
                                                            'Voucher BB 50.000');
                                                print(gimmick);
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),

                                  //* baris kanan
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: wid,
                                            child: Text(
                                              'Tas pink',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Checkbox(
                                            value: isTaspink,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                isTaspink = value!;
                                                isTaspink == true
                                                    ? gimmick.add('Tas pink')
                                                    : gimmick.removeWhere(
                                                        (element) =>
                                                            element ==
                                                            'Tas pink');
                                                print(gimmick);
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: wid,
                                            child: Text(
                                              'Pouch BB',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Checkbox(
                                            value: isPouchbb,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                isPouchbb = value!;
                                                isPouchbb == true
                                                    ? gimmick.add('Pouch BB')
                                                    : gimmick.removeWhere(
                                                        (element) =>
                                                            element ==
                                                            'Pouch BB');
                                                print(gimmick);
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: wid,
                                            child: Text(
                                              'LM 0.25',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Checkbox(
                                            value: isLm025,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                isLm025 = value!;
                                                isLm025 == true
                                                    ? gimmick.add('LM 0.25')
                                                    : gimmick.removeWhere(
                                                        (element) =>
                                                            element ==
                                                            'LM 0.25');
                                                print(gimmick);
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: wid,
                                            child: Text(
                                              'LM 0.5',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Checkbox(
                                            value: isLm05,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                isLm05 = value!;
                                                isLm05 == true
                                                    ? gimmick.add('LM 0.5')
                                                    : gimmick.removeWhere(
                                                        (element) =>
                                                            element ==
                                                            'LM 0.5');
                                                print(gimmick);
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: wid,
                                            child: Text(
                                              'Cash 500.000',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Checkbox(
                                            value: isCash500,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                isCash500 = value!;
                                                isCash500 == true
                                                    ? gimmick.add('LM 0.5')
                                                    : gimmick.removeWhere(
                                                        (element) =>
                                                            element ==
                                                            'LM 0.5');
                                                print(gimmick);
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                      const SizedBox(height: 30),
                      // Container(
                      //   alignment: Alignment.bottomLeft,
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.start,
                      //     children: [
                      //       Text(
                      //         'Gift ? ',
                      //         style: TextStyle(
                      //             color: Colors.black,
                      //             fontSize: 24,
                      //             fontWeight: FontWeight.bold),
                      //       ),
                      //       Checkbox(
                      //         value: isGift,
                      //         onChanged: (bool? value) {
                      //           setState(() {
                      //             isGift = value!;
                      //           });
                      //         },
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      const Divider(
                        color: Colors.black,
                        thickness: 5,
                      ),
                      const Text("Total"),
                      Text(
                        "$totalPrice3",
                        style: const TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Colors.red),
                      ),
                    ],
                  ),
                ),
              ),
        bottomNavigationBar: idform == 0
            ? const SizedBox()
            : addesdiskon > limitDis1 || addesdiskon2 > limitDis2
                ? SizedBox()
                : Padding(
                    padding: const EdgeInsets.only(bottom: 40),
                    child: CustomLoadingButton(
                      controller: btnController,
                      onPressed: () async {
                        if (isGift != true) {
                          await postAPI();
                        } else {
                          await postAPIGift();
                        }
                      },
                      child: const Text(
                        "Save Transaction",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ));
  }

  Widget _customPopupItemBuilderExample2(
    BuildContext context,
    UserModel? item,
    bool isSelected,
  ) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      decoration: !isSelected
          ? null
          : BoxDecoration(
              border: Border.all(color: Theme.of(context).primaryColor),
              borderRadius: BorderRadius.circular(5),
              color: Colors.white,
            ),
      child: ListTile(
        selected: isSelected,
        title: Text(item?.name ?? ''), // menampilkan nama
        subtitle: Text(item?.alamat?.toString() ?? ''), // menampilkan alamat
      ),
    );
  }

  Future<List<UserModel>> getData(filter) async {
    String token = sharedPreferences!.getString("token").toString();
    var response = await Dio().get(
      ApiConstants.baseUrl + ApiConstants.GETcustomerMetier,
      options: Options(headers: {"Authorization": 'Bearer $token'}),
      queryParameters: {"filter": filter},
    );

    final data = response.data;
    if (data != null) {
      return UserModel.fromJsonList(data);
    }

    return [];
  }

  postAPI() async {
    String resultGimmick = gimmick.join(', ');
    String token = sharedPreferences!.getString("token").toString();
    String cart_total = context.read<PCartEvent>().totalPrice2.toString();
    String cart_totalquantity = context.read<PCartEvent>().count.toString();
    String customer_id = '440'; //id beliberlian
    String jenisform_id = '1';
    String basicdiskon = diskon.toString();
    String customerbeliberlian = idtoko.toString();
    String pajak = '0';
    String rate = '16000';
    String total = totalRp;
    String total_potongan = totalDiskonRp; //? total
    String totalkurangdiskon = totalPriceAPI; //? ini net
    String totalkurangpajak = totalRp;
    String addesdiskonApi = addesdiskon.toString();
    String addesdiskonApi2 = addesdiskon2.toString();
    String nilaiVoucherApi = nilaiVocher.toString();
    String surprise = addesdiskon3.toString();

    Map<String, String> body = {
      'cart_total': cart_total,
      'cart_totalquantity': cart_totalquantity, //total item di cart
      'customer_id': customer_id,
      'jenisform_id': jenisform_id,
      'basic_discount': basicdiskon,
      'customerbeliberlian': customerbeliberlian,
      'pajak': pajak,
      'rate': rate,
      'total': total,
      'total_potongan': total_potongan,
      'totalkurangdiskon': totalkurangdiskon,
      'totalkurangpajak': totalkurangpajak,
      'addesdiskon': addesdiskonApi,
      'addesdiskon2': addesdiskonApi2,
      'voucher_diskon': nilaiVoucherApi,
      'surprise': valueSurprise,
      'gimmick': resultGimmick,
    };
    print(body);
    try {
      final response = await http.post(
          Uri.parse(ApiConstants.baseUrl +
              ApiConstants.POSTtokobeliberliancheckoutendpoint),
          headers: <String, String>{
            'Authorization': 'Bearer $token',
          },
          body: body);
      print(response.body);
      print(response.statusCode);
      if (response.statusCode != 200) {
        btnController.error(); //sucses
        btnController.reset();
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (c) => TransaksiGagal(
                      title: 'Transaksi Event gagal',
                      err: '${response.body}',
                    )));
      } else {
        context.read<PCartEvent>().clearCart(); //clear cart
        await DbAlldetailtransaksi.db.deleteAlldetailtransaksi();
        await DbAlltransaksi.db.deleteAlltransaksiBaru();
        var apiProvider = ApiServices();
        try {
          await apiProvider.getAllTransaksiBaru();
        } catch (c) {
          Fluttertoast.showToast(msg: "Failed To Load Data all transaksi");
        }
        try {
          await apiProvider.getAllDetailTransaksi();
        } catch (c) {
          Fluttertoast.showToast(
              msg: "Failed To Load Data all details transaksi");
        }
        btnController.success(); //sucses

        Navigator.push(context,
            MaterialPageRoute(builder: (c) => const MySplashScreenTransaksi()));
      }
    } catch (c) {
      btnController.error(); //sucses
      btnController.reset();
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (c) => TransaksiGagal(
                    title: 'Transaksi Event gagal',
                    err: '$c',
                  )));
    }
  }

  postAPIGift() async {
    String token = sharedPreferences!.getString("token").toString();
    String cart_total = '0';
    String cart_totalquantity = context.read<PCartEvent>().count.toString();
    String customer_id = '440'; //id beliberlian
    String jenisform_id = '1';
    String basicdiskon = '0';
    String customerbeliberlian = idtoko.toString();
    String pajak = '0';
    String rate = '0';
    String total = '0';
    String total_potongan = '0';
    String totalkurangdiskon = '0';
    String totalkurangpajak = '0';
    String addesdiskonApi = '0';
    String nilaiVoucherApi = '0';
    Map<String, String> body = {
      'cart_total': cart_total,
      'cart_totalquantity': cart_totalquantity, //total item di cart
      'customer_id': customer_id,
      'jenisform_id': jenisform_id,
      'basic_discount': basicdiskon,
      'customerbeliberlian': customerbeliberlian,
      'pajak': pajak,
      'rate': rate,
      'total': total,
      'total_potongan': total_potongan,
      'totalkurangdiskon': totalkurangdiskon,
      'totalkurangpajak': totalkurangpajak,
      'addesdiskon': addesdiskonApi,
      'voucher_diskon': nilaiVoucherApi,
    };
    final response = await http.post(
        Uri.parse(ApiConstants.baseUrl +
            ApiConstants.POSTtokobeliberliancheckoutendpoint),
        headers: <String, String>{
          'Authorization': 'Bearer $token',
        },
        body: body);
    print(response.body);
  }
}

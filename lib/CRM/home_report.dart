// ignore_for_file: avoid_print, non_constant_identifier_names, sized_box_for_whitespace, depend_on_referenced_packages

import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:e_shop/CRM/dashboard_erick.dart';
import 'package:e_shop/api/api_constant.dart';
import 'package:e_shop/database/db_alltransaksi.dart';
import 'package:e_shop/database/db_crm.dart';
import 'package:e_shop/database/model_crm.dart';
import 'package:e_shop/global/global.dart';
import 'package:e_shop/mainScreens/main_screen.dart';
import 'package:e_shop/models/user_model.dart';
import 'package:e_shop/widgets/custom_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:rounded_loading_button/rounded_loading_button.dart';

// ignore: use_key_in_widget_constructors
class HomeReport extends StatefulWidget {
  @override
  State<HomeReport> createState() => _HomeReportState();
}

class _HomeReportState extends State<HomeReport> {
  //dropdwon future start
  List<DropdownMenuItem<String>>? list;
  //end dropdown
  RoundedLoadingButtonController btnController =
      RoundedLoadingButtonController();
  final TextEditingController reportinput = TextEditingController();
  TextEditingController dateinput = TextEditingController();
  bool cek_wa = false;
  TextEditingController omzetS = TextEditingController();
  String cek_error_customer = 'null';
  String cek_error_date = 'null';
  String cek_error_report = 'null';
  String cek_error_activity = 'null';
  bool cek_tlp = false;
  bool cek_visit = false;
  bool cek_canvasing = false;
  bool cek_kunjungan = false;
  bool cek_omzet = false;
  DateTime? pickedDate;
  String formattedDate = 'null';
  String tanggal_aktivitas = '';
  int? idomzet = 0;
  int? canvasing = 0;
  int? kunjungan = 0;
  int? omzet = 0;
  int? idaktivitas = 0;
  int? idvisit = 0;
  int? wa = 0;
  int? tlp = 0;
  int? visit = 0;
  String? resultValue = '';
  String? toko = '';
  String? selectedItemName = '';
  String? selectedOmzet = '';
  int? idtoko = 0;
  //text editing controller for text field
  final _formKey = GlobalKey<FormState>();

  //start image
  XFile? image;
  final ImagePicker picker = ImagePicker();
  //we can upload image from camera or from gallery based on parameter
  Future getImage(ImageSource media) async {
    var img = await picker.pickImage(source: media);
    setState(() {
      image = img;
    });
  }
  //end image

  //start video

  //end video
  late FToast fToast;
  @override
  void initState() {
    _timeController.text = '00:00';
    fToast = FToast();
    fToast.init(context);
    dateinput.text = ""; //set the initial value of text field
    super.initState();
    list = [];
  }

  bool _rangeDate(DateTime day) {
    if ((day.isAfter(DateTime.now().subtract(const Duration(days: 8))) &&
        day.isBefore(DateTime.now().add(const Duration(days: 0))))) {
      return true;
    }
    return false;
  }

  // start image multi
  final ImagePicker imgpicker = ImagePicker();
  List<XFile>? imagefiles;

  openImages() async {
    try {
      var pickedfiles = await imgpicker.pickMultiImage();
      //you can use ImageCourse.camera for Camera capture
      // ignore: unnecessary_null_comparison
      if (pickedfiles != null) {
        imagefiles = pickedfiles;
        setState(() {});
      } else {
        print("No image is selected.");
      }
    } catch (e) {
      print("error while picking file.");
    }
  }
//end image mult

// start date & time
  // ignore: unused_field
  String? _setTime = '';

  String? _hour = '0', _minute = '0', _time = '0';

  String? dateTime = '';

  DateTime selectedDate = DateTime.now();

  TimeOfDay selectedTime = const TimeOfDay(hour: 00, minute: 00);

  final TextEditingController _timeController = TextEditingController();

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null) {
      setState(() {
        selectedTime = picked;
        _hour = selectedTime.hour.toString();
        _minute = selectedTime.minute.toString();
        _time = '$_hour:$_minute';
        _timeController.text = _time!;
        print(_timeController.text);
        // _timeController.text = DateFormat(
        //     DateTime(2019, 08, 1, selectedTime.hour, selectedTime.minute).toString(),
        //     [hh, ':', nn, " ", am]).toString();
      });
    }
  }

//end date time

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade200,
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
            "Report",
            style: TextStyle(
              fontSize: 20,
              letterSpacing: 3,
            ),
          ),
          centerTitle: true,
          actions: [
            // ignore: unrelated_type_equality_checks
            sharedPreferences!.getString('id') != '21'
                ? const SizedBox()
                : IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (c) => const DashboardErick()));
                    },
                    icon: const Icon(
                      Icons.security_rounded,
                      color: Colors.white,
                    ),
                  ),
          ],
        ),
        body: Column(
          children: <Widget>[
            Row(
              children: [
                const Padding(padding: EdgeInsets.all(4)),
                Expanded(
                  child: DropdownSearch<UserModel>(
                    asyncItems: (String? filter) => getData(filter),
                    popupProps: PopupPropsMultiSelection.modalBottomSheet(
                      showSelectedItems: true,
                      itemBuilder: _customPopupItemBuilderExample2,
                      showSearchBox: true,
                    ),
                    compareFn: (item, sItem) => item.id == sItem.id,
                    onChanged: (item) {
                      setState(() {
                        selectedOmzet = null;
                        cek_omzet = false;
                        // print(text);
                        print('toko : ${item?.name}');
                        print('id  : ${item?.id}');
                        idtoko = item?.id; // menyimpan id toko
                        toko = item?.name; // menyimpan nama toko
                        cek_error_customer = 'customer oke';
                        list?.clear();
                        DbAlltransaksi.db.getAllinvoicesnumber(idtoko);
                        btnController.reset();
                      });
                      DbAlltransaksi.db
                          .getAllinvoicesnumber(idtoko)
                          .then((listMap) {
                        listMap.map((map) {
                          return getDropDownWidget(map);
                        }).forEach((dropDownItem) {
                          list?.add(dropDownItem);
                        });
                      });
                    },
                    dropdownDecoratorProps: DropDownDecoratorProps(
                      dropdownSearchDecoration: InputDecoration(
                        labelText: 'Customer',
                        filled: true,
                        fillColor:
                            Theme.of(context).inputDecorationTheme.fillColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            if (cek_error_customer == 'error customer')
              const Padding(
                padding: EdgeInsets.only(right: 280),
                child: SizedBox(
                  child: Text(
                    'Required*',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 10,
                    ),
                  ),
                ),
              ),
            Expanded(
              child: Padding(
                  padding: const EdgeInsets.only(left: 25, right: 25),
                  child: Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: ListView(
                        padding: const EdgeInsets.all(4),
                        children: <Widget>[
                          const SizedBox(
                            height: 10,
                          ),
                          //date
                          const Text("Date"),
                          const Divider(),
                          Row(children: [
                            const Padding(padding: EdgeInsets.all(4)),
                            Expanded(
                                child: TextField(
                              controller:
                                  dateinput, //editing controller of this TextField
                              decoration: const InputDecoration(
                                  icon: Icon(
                                    Icons.calendar_month,
                                    color: Colors.blue,
                                  ), //icon of text field
                                  labelText: "Enter Date" //label text of field
                                  ),
                              readOnly:
                                  true, //set it true, so that user will not able to edit text
                              onTap: () async {
                                DateTime? pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(
                                        2000), //DateTime.now() - not to allow to choose before today.
                                    lastDate: DateTime(2024),
                                    selectableDayPredicate: _rangeDate);

                                if (pickedDate != null) {
                                  print(
                                      pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                                  String formattedDate =
                                      DateFormat('dd-MM-yyyy')
                                          .format(pickedDate);
                                  tanggal_aktivitas = DateFormat('yyyy-MM-dd')
                                      .format(pickedDate);
                                  print(
                                      formattedDate); //formatted date output using intl package =>  2021-03-16
                                  //you can implement different kind of Date Format here according to your requirement
                                  setState(() {
                                    btnController.reset();
                                    cek_error_date = 'date oke';
                                    dateinput.text =
                                        formattedDate; //set output date to TextField value.

                                    // tanggal_aktivitas = pickedDate.toString();
                                  });
                                } else {
                                  print("Date is not selected");
                                }
                              },
                            )),
                          ]),

                          if (cek_error_date == 'error date')
                            const Padding(
                              padding: EdgeInsets.only(right: 1),
                              child: SizedBox(
                                child: Text(
                                  'Required*',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                            ),
                          //time
                          const Text(
                            'Choose Time',
                            style: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5),
                          ),
                          InkWell(
                            onTap: () {
                              // Fluttertoast.showToast(msg: 'oke');
                              _selectTime(context);
                            },
                            child: Container(
                              margin: const EdgeInsets.only(top: 30),
                              width: 15,
                              height: 5,
                              alignment: Alignment.center,
                              decoration:
                                  const BoxDecoration(color: Colors.blue),
                              child: TextFormField(
                                style: const TextStyle(fontSize: 30),
                                textAlign: TextAlign.center,
                                onSaved: (String? val) {
                                  _setTime = val!;
                                },
                                enabled: false,
                                keyboardType: TextInputType.text,
                                controller: _timeController,
                                decoration: const InputDecoration(
                                  disabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide.none),
                                  // labelText: 'Time',
                                  // contentPadding: EdgeInsets.all(5)
                                ),
                              ),
                            ),
                          ),
                          //wa

                          const Text("Activity"),
                          const Divider(),
                          Column(
                            children: [
                              Row(
                                children: <Widget>[
                                  Checkbox(
                                    value: cek_wa,
                                    onChanged:
                                        cek_visit == true || cek_tlp == true
                                            ? null
                                            : (bool? value) {
                                                setState(() {
                                                  btnController.reset();
                                                  cek_wa = value!;
                                                  cek_wa == true
                                                      ? idaktivitas = 1
                                                      : idaktivitas = 0;
                                                  print(
                                                      'whatsapp : status $cek_wa & vl : $wa');
                                                  cek_error_activity =
                                                      'activity oke';
                                                });
                                              },
                                  ),
                                  const Text(
                                    'WhatsApp',
                                    style: TextStyle(fontSize: 14.0),
                                  ),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Checkbox(
                                    value: cek_tlp,
                                    onChanged:
                                        cek_visit == true || cek_wa == true
                                            ? null
                                            : (bool? value) {
                                                setState(() {
                                                  btnController.reset();
                                                  cek_error_activity =
                                                      'activity oke';
                                                  cek_tlp = value!;
                                                  cek_tlp == true
                                                      ? idaktivitas = 2
                                                      : idaktivitas = 0;
                                                });
                                              },
                                  ),
                                  const Text(
                                    'Telephone',
                                    style: TextStyle(fontSize: 14.0),
                                  ),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Checkbox(
                                    value: cek_visit,
                                    onChanged: cek_tlp == true || cek_wa == true
                                        ? null
                                        : (bool? value) {
                                            setState(() {
                                              btnController.reset();
                                              cek_error_activity =
                                                  'activity oke';
                                              cek_visit = value!;
                                              cek_canvasing = false;
                                              cek_kunjungan = false;
                                              cek_visit == true
                                                  ? idaktivitas = 3
                                                  : idaktivitas = 0;
                                            });
                                          },
                                  ),
                                  const Text(
                                    'Visit',
                                    style: TextStyle(fontSize: 14.0),
                                  ),
                                  //kunjungan
                                  if (idaktivitas == 3)
                                    Checkbox(
                                      value: cek_kunjungan,
                                      onChanged: cek_canvasing == true
                                          ? null
                                          : (bool? value) {
                                              setState(() {
                                                btnController.reset();
                                                cek_error_activity =
                                                    'activity oke';
                                                cek_kunjungan = value!;
                                                cek_kunjungan == true
                                                    ? idvisit = 1
                                                    : idvisit = 0;
                                                print(
                                                    'kunjungan : status $cek_kunjungan & vl : $kunjungan');
                                              });
                                            },
                                    ),
                                  if (idaktivitas == 3)
                                    const Text(
                                      'Kunjungan',
                                      style: TextStyle(fontSize: 14.0),
                                    ),

                                  //canvasing
                                  if (idaktivitas == 3)
                                    Checkbox(
                                      value: cek_canvasing,
                                      onChanged: cek_kunjungan == true
                                          ? null
                                          : (bool? value) {
                                              setState(() {
                                                btnController.reset();
                                                cek_error_activity =
                                                    'activity oke';
                                                cek_canvasing = value!;
                                                cek_canvasing == true
                                                    ? idvisit = 2
                                                    : idvisit = 0;
                                                print(
                                                    'canvasing : status $cek_kunjungan & vl : $canvasing');
                                              });
                                            },
                                    ),
                                  if (idaktivitas == 3)
                                    const Text(
                                      'Canvasing',
                                      style: TextStyle(fontSize: 14.0),
                                    ),
                                ],
                              ),
                            ],
                          ),
                          if (cek_error_activity == 'error activity')
                            const Padding(
                              padding: EdgeInsets.only(right: 250),
                              child: SizedBox(
                                child: Text(
                                  'Required*',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                            ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text("Report"),
                          const Divider(),
                          Card(
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(0),
                                child: TextField(
                                  onChanged: (reportinput) {
                                    setState(() {
                                      btnController.reset();
                                      cek_error_report = 'report oke';
                                      reportinput = reportinput;
                                      print(reportinput);
                                    });
                                  },
                                  maxLines: 8, //or null
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      hintText: "Enter your report"),
                                  controller: reportinput,
                                ),
                              )),
                          if (cek_error_report == 'error report')
                            const Padding(
                              padding: EdgeInsets.only(right: 250),
                              child: SizedBox(
                                child: Text(
                                  'Required*',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                            ),
                          //omzet
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              const Text("Omzet"),
                              Checkbox(
                                value: cek_omzet,
                                onChanged: (bool? value) {
                                  setState(() {
                                    cek_omzet = value!;
                                    if (cek_omzet == true) {
                                      idomzet = 1;
                                      selectedOmzet = null;
                                      omzetS.text = '0';
                                    } else {
                                      idomzet = 0;
                                    }
                                  });
                                },
                              ),
                              cek_omzet == false
                                  ? const Text('')
                                  :
                                  //no invoices
                                  DropdownButton(
                                      icon: selectedOmzet == null
                                          ? IconButton(
                                              onPressed: () {},
                                              icon: const Icon(
                                                Icons.arrow_drop_down,
                                                color: Colors.blue,
                                              ),
                                            )
                                          : IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  selectedOmzet = null;
                                                  omzetS.text = '0';
                                                  omzet = 0;
                                                });
                                              },
                                              icon: const Icon(
                                                Icons.cancel,
                                                color: Colors.blue,
                                              ),
                                            ),
                                      underline: Container(
                                        height: 2,
                                        color: Colors.blue, //<-- SEE HERE
                                      ),
                                      value: selectedOmzet,
                                      hint: const Text(
                                          'Select transaction codes'),
                                      onChanged: (value) {
                                        setState(() {
                                          selectedOmzet = value;
                                        });
                                        //fungsi show value without builder
                                        DbAlltransaksi.db
                                            .getAllNominalTransaksi(
                                                selectedOmzet)
                                            .then((result) {
                                          result.isEmpty
                                              ? setState(() {
                                                  resultValue = '0';
                                                  omzet = 0;
                                                  omzetS.text = resultValue!;
                                                  //CurrencyFormat
                                                  //.convertToIdr(
                                                  //int.parse(
                                                  //resultValue!),
                                                  //2);
                                                })
                                              : setState(() {
                                                  resultValue =
                                                      result.first.total_rupiah;
                                                  omzetS.text = resultValue!;
                                                  omzet =
                                                      int.parse(resultValue!);
                                                });
                                        });
                                      },
                                      //end of fungsi
                                      items: list,
                                    )
                            ],
                          ),
                          const Divider(),
                          //total nominal omzet
                          cek_omzet == false
                              ? const Text('')
                              : SizedBox(
                                  width: 250,
                                  child: TextField(
                                    enabled:
                                        selectedOmzet != null ? false : true,
                                    onChanged: (omzetS) {
                                      setState(() {
                                        omzet = int.parse(omzetS);
                                      });
                                    },
                                    controller: omzetS,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                  ),
                                ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                ),
                                onPressed: () {
                                  // null;
                                  // myAlert();
                                  Fluttertoast.showToast(msg: "Not Available");
                                  // openImages();
                                },
                                child: const Text('Upload Photo'),
                              ),
                              const SizedBox(
                                height: 10,
                              ),

                              //multi img
                              imagefiles != null
                                  ? Wrap(
                                      children: imagefiles!.map((imageone) {
                                        return Card(
                                          child: Container(
                                            height: 100,
                                            width: 100,
                                            child: Image.file(
                                              File(imageone.path),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    )
                                  : Container()
                            ],
                          ),
                          //   //video
                          //   const SizedBox(
                          //     height: 10,
                          //   ),
                          //   const Divider(),
                          //   Column(
                          //     mainAxisAlignment: MainAxisAlignment.center,
                          //     children: [
                          //       ElevatedButton(
                          //         onPressed: () {
                          //           myAlertVideo();
                          //         },
                          //         child: const Text('Upload Video'),
                          //       ),
                          //       const SizedBox(
                          //         height: 10,
                          //       ),
                          //       //if image not null show the image
                          //       //if image null show text
                          //       image != null
                          //           ? Padding(
                          //               padding:
                          //                   const EdgeInsets.symmetric(horizontal: 20),
                          //               child: ClipRRect(
                          //                 borderRadius: BorderRadius.circular(8),
                          //                 child: Image.file(
                          //                   //to show image, you type like this.
                          //                   File(image!.path),
                          //                   fit: BoxFit.cover,
                          //                   width: MediaQuery.of(context).size.width,
                          //                   height: 300,
                          //                 ),
                          //               ),
                          //             )
                          //           : const Text(
                          //               "No Video",
                          //               style: TextStyle(fontSize: 20),
                          //             )
                          //     ],
                          //   ),
                          //   const SizedBox(
                          //     height: 10,
                          //   ),
                          //   const Divider(),
                        ]),
                  )),
            ),
          ],
        ), //Row
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.only(left: 50, right: 50, bottom: 5),
          child: CustomLoadingButton(
            controller: btnController,
            onPressed: () {
              formValidation();
            },
            //  c: Colors.blue,
            child: const Text("Save Report"),
          ),
        ));
  }

  Future<List<UserModel>> getData(filter) async {
    String token = sharedPreferences!.getString("token").toString();
    var response = await Dio().get(
      ApiConstants.baseUrl + ApiConstants.GETcustomerendpoint,
      options: Options(headers: {"Authorization": 'Bearer $token'}),
      queryParameters: {"filter": filter},
    );

    final data = response.data;
    if (data != null) {
      return UserModel.fromJsonList(data);
    }

    return [];
  }

  Widget _customPopupItemBuilderExample2(
    BuildContext context,
    UserModel? item,
    bool isSelected,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
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

  //show popup dialog
  void myAlert() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            title: const Text('Please choose media to select'),
            content: Container(
              height: MediaQuery.of(context).size.height / 6,
              child: Column(
                children: [
                  ElevatedButton(
                    //if user click this button, user can upload image from gallery
                    onPressed: () {
                      Navigator.pop(context);
                      // getImage(ImageSource.gallery);
                      openImages();
                    },
                    child: const Row(
                      children: [
                        Icon(Icons.image),
                        Text('From Gallery'),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    //if user click this button. user can upload image from camera
                    onPressed: () {
                      Navigator.pop(context);
                      getImage(ImageSource.camera);
                    },
                    child: const Row(
                      children: [
                        Icon(Icons.camera),
                        Text('From Camera'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  void myAlertVideo() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            title: const Text('Please choose media to select'),
            content: Container(
              height: MediaQuery.of(context).size.height / 6,
              child: Column(
                children: [
                  ElevatedButton(
                    //if user click this button, user can upload image from gallery
                    onPressed: () {
                      Fluttertoast.showToast(msg: "Not Available");

                      // Navigator.pop(context);
                      // getImage(ImageSource.gallery);
                    },
                    child: const Row(
                      children: [
                        Icon(Icons.image),
                        Text('From Gallery'),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    //if user click this button. user can upload image from camera
                    onPressed: () {
                      Fluttertoast.showToast(msg: "Not Available");

                      // Navigator.pop(context);
                      // getImage(ImageSource.camera);
                    },
                    child: const Row(
                      children: [
                        Icon(Icons.camera),
                        Text('From Camera'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  //form validasi
  formValidation() async {
    if (toko == null ||
        dateinput.text.isEmpty ||
        reportinput.text.isEmpty ||
        cek_wa == false && cek_tlp == false && cek_visit == false) {
      setState(() {
        cek_error_customer = 'error customer';
        cek_error_date = 'error date';
        cek_error_report = 'error report';
        cek_error_activity = 'error activity';
      });
      Future.delayed(const Duration(seconds: 1)).then((value) {
        btnController.error(); //error
      });
    } else {
      Future.delayed(const Duration(seconds: 1)).then((value) async {
        // ignore: unnecessary_null_comparison
        btnController.success(); //sucses
        print(toko);
        await DbCRM.db.createAllcrm(ModelCRM(
            user_id: id.toString(),
            customer_id: idtoko,
            tanggal_aktivitas:
                '$tanggal_aktivitas ${_timeController.text}:00.000',
            aktivitas_id: idaktivitas.toString(),
            visit_id: idvisit.toString(),
            hasil_aktivitas: idomzet.toString(),
            nominal_hasil: omzet,
            nomor_invoice: selectedOmzet ?? '',
            detail: reportinput.text,
            nama_toko: toko));
        // await postAPIreport();
        // sendMotificationToBc(fcmTokensandy);
        Fluttertoast.showToast(msg: 'Report success');
        Future.delayed(const Duration(seconds: 1)).then((value) {
          Navigator.push(
              context, MaterialPageRoute(builder: (c) => const MainScreen()));
        });
      });
    }
  }

//mengirim notif
  sendMotificationToBc(tokenBC) {
    String? bcName = sharedPreferences!.getString('name');
    Map bodyNotification = {
      'title': 'Report CRM',
      'body':
          'Report $bcName \nDetail report : ${reportinput.text}\nTotal omzet : ${omzetS.text}',
      'sound': 'default'
    };
    Map<String, String> headersAPI = {
      'Content-Type': 'application/json',
      'Authorization': 'key=$fcmServerToken',
    };
    Map bodyAPI = {
      'to': tokenBC,
      'priority': 'high',
      'notification': bodyNotification,
      // 'data': dataMap,
    };
    http.post(Uri.parse("https://fcm.googleapis.com/fcm/send"),
        headers: headersAPI, body: jsonEncode(bodyAPI));
  }

//send data to DATABASE with API
  postAPIreport() async {
    String token = sharedPreferences!.getString("token").toString();
    Map<String, String> body = {
      'user_id': id.toString(),
      'customer_id': idtoko.toString(),
      'tanggal_aktivitas': '$tanggal_aktivitas ${_timeController.text}:00.000',
      'aktivitas_id': idaktivitas.toString(),
      'visit_id': idvisit.toString(),
      'hasil_aktivitas': idomzet.toString(),
      'nominal_hasil': omzetS.text,
      'nomor_invoice': selectedOmzet ?? '',
      'detail': reportinput.text
    };
    final response = await http.post(
        Uri.parse(ApiConstants.baseUrl + ApiConstants.POSTcreateCRMendpoint),
        headers: <String, String>{
          'Authorization': 'Bearer $token',
        },
        body: body);
    print(response.body);
  }

  //dropdwon
  DropdownMenuItem<String> getDropDownWidget(Map<String, dynamic> map) {
    return DropdownMenuItem<String>(
      value: map['invoices_number'],
      child: Text(map['invoices_number']),
    );
  }
}

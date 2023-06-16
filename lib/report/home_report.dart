// ignore_for_file: avoid_print, non_constant_identifier_names, sized_box_for_whitespace, depend_on_referenced_packages

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:e_shop/api/api_constant.dart';
import 'package:e_shop/global/global.dart';
import 'package:e_shop/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

// ignore: use_key_in_widget_constructors
class HomeReport extends StatefulWidget {
  @override
  State<HomeReport> createState() => _HomeReportState();
}

class _HomeReportState extends State<HomeReport> {
  final TextEditingController reportinput = TextEditingController();
  TextEditingController dateinput = TextEditingController();
  bool cek_wa = false;
  bool cek_tlp = false;
  bool cek_visit = false;
  bool cek_canvasing = false;
  bool cek_kunjungan = false;
  int? canvasing = 0;
  int? kunjungan = 0;
  int? wa = 0;
  int? tlp = 0;
  int? visit = 0;
  String? toko;
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

  @override
  void initState() {
    dateinput.text = ""; //set the initial value of text field
    super.initState();
  }

  bool _rangeDate(DateTime day) {
    if ((day.isAfter(DateTime.now().subtract(const Duration(days: 8))) &&
        day.isBefore(DateTime.now().add(const Duration(days: 0))))) {
      return true;
    }
    return false;
  }

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
            // Navigator.push(
            //     context, MaterialPageRoute(builder: (c) => PosSalesScreen()));
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
      ),
      body: Padding(
          padding: const EdgeInsets.all(25),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child:
                ListView(padding: const EdgeInsets.all(4), children: <Widget>[
              //date
              const Text("Date"),
              const Divider(),
              Row(children: [
                const Padding(padding: EdgeInsets.all(4)),
                Expanded(
                    child: TextField(
                  controller: dateinput, //editing controller of this TextField
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
                          DateFormat('dd-MM-yyyy').format(pickedDate);
                      print(
                          formattedDate); //formatted date output using intl package =>  2021-03-16
                      //you can implement different kind of Date Format here according to your requirement
                      setState(() {
                        dateinput.text =
                            formattedDate; //set output date to TextField value.
                      });
                    } else {
                      print("Date is not selected");
                    }
                  },
                ))
              ]),

              //customer / toko
              const SizedBox(
                height: 10,
              ),
              const Text("Customer"),
              const Divider(),
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
                          // print(text);
                          print('toko : ${item?.name}');
                          print('id  : ${item?.id}');
                          print('diskonnya  : ${item?.diskon_customer}');
                          idtoko = item?.id; // menyimpan id toko
                          toko = item?.name; // menyimpan nama toko
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

              //wa
              const SizedBox(
                height: 10,
              ),
              const Text("Activity"),
              const Divider(),
              Column(
                children: [
                  Row(
                    children: <Widget>[
                      Checkbox(
                        value: cek_wa,
                        onChanged: (bool? value) {
                          setState(() {
                            cek_wa = value!;
                            wa = 1;
                            print(cek_wa);
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
                        onChanged: (bool? value) {
                          setState(() {
                            cek_tlp = value!;
                            tlp = 1;
                            print(cek_tlp);
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
                        onChanged: (bool? value) {
                          setState(() {
                            if (value == true) {
                              visit = 1;
                              cek_visit = value!;
                            } else {
                              visit = 0;
                              cek_visit = value!;
                            }
                            print('$cek_visit dan $visit');
                          });
                        },
                      ),
                      const Text(
                        'Visit',
                        style: TextStyle(fontSize: 14.0),
                      ),
                      //kunjungan
                      if (visit != 0)
                        Checkbox(
                          value: cek_kunjungan,
                          onChanged: (bool? value) {
                            setState(() {
                              if (value == true) {
                                kunjungan = 1;
                                cek_kunjungan = value!;
                              } else {
                                kunjungan = 0;
                                cek_kunjungan = value!;
                              }
                              print('$cek_kunjungan dan $kunjungan');
                            });
                          },
                        ),
                      if (visit != 0)
                        const Text(
                          'Kunjungan',
                          style: TextStyle(fontSize: 14.0),
                        ),

                      //canvasing
                      if (visit != 0)
                        Checkbox(
                          value: cek_canvasing,
                          onChanged: (bool? value) {
                            setState(() {
                              if (value == true) {
                                canvasing = 1;
                                cek_canvasing = value!;
                              } else {
                                canvasing = 0;
                                cek_canvasing = value!;
                              }
                              print('$cek_canvasing dan $canvasing');
                            });
                          },
                        ),
                      if (visit != 0)
                        const Text(
                          'Canvasing',
                          style: TextStyle(fontSize: 14.0),
                        ),
                    ],
                  ),
                ],
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
                          reportinput = reportinput;
                          print(reportinput);
                        });
                      },
                      maxLines: 8, //or null
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          hintText: "Enter your report"),
                      controller: reportinput,
                    ),
                  )),
              //DP
              const SizedBox(
                height: 10,
              ),
              const Text("Omzet"),
              const Divider(),
              SizedBox(
                width: 250,
                child: TextField(
                  onChanged: (omzet) {
                    setState(() {
                      // dpp = int.parse(dp);
                    });
                  },
                  decoration: const InputDecoration(labelText: "Omzet"),
                  // controller: omzet,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      myAlert();
                    },
                    child: const Text('Upload Photo'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  //if image not null show the image
                  //if image null show text
                  image != null
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              //to show image, you type like this.
                              File(image!.path),
                              fit: BoxFit.cover,
                              width: MediaQuery.of(context).size.width,
                              height: 300,
                            ),
                          ),
                        )
                      : const Text(
                          "No Image",
                          style: TextStyle(fontSize: 20),
                        )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              const Divider(),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      myAlertVideo();
                    },
                    child: const Text('Upload Video'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  //if image not null show the image
                  //if image null show text
                  image != null
                      ? const Text(
                          "No Video",
                          style: TextStyle(fontSize: 20),
                        )
                      // Padding(
                      //     padding: const EdgeInsets.symmetric(horizontal: 20),
                      //     child: ClipRRect(
                      //       borderRadius: BorderRadius.circular(8),
                      //       child: Image.file(
                      //         //to show image, you type like this.
                      //         File(image!.path),
                      //         fit: BoxFit.cover,
                      //         width: MediaQuery.of(context).size.width,
                      //         height: 300,
                      //       ),
                      //     ),
                      //   )
                      : const Text(
                          "No Video",
                          style: TextStyle(fontSize: 20),
                        )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              const Divider(),
            ]),
          )), //Row
    );
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
                      getImage(ImageSource.gallery);
                    },
                    child: Row(
                      children: const [
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
                    child: Row(
                      children: const [
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
                    child: Row(
                      children: const [
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
                    child: Row(
                      children: const [
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
}

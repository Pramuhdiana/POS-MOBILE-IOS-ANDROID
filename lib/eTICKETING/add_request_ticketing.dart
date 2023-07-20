// ignore_for_file: avoid_print, non_constant_identifier_names, sized_box_for_whitespace, depend_on_referenced_packages

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:e_shop/api/api_constant.dart';
import 'package:e_shop/global/global.dart';
import 'package:e_shop/models/user_model.dart';
import 'package:e_shop/widgets/custom_loading.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:intl/intl.dart';

// ignore: use_key_in_widget_constructors
class AddRequestEticketing extends StatefulWidget {
  @override
  State<AddRequestEticketing> createState() => _AddRequestEticketingState();
}

class _AddRequestEticketingState extends State<AddRequestEticketing> {
  final _formKey = GlobalKey<FormState>();
  double nilaiSlider = 1;
  bool nilaiCheckBox = false;
  bool nilaiSwitch = true;
  RoundedLoadingButtonController btnController =
      RoundedLoadingButtonController();
  final TextEditingController reportinput = TextEditingController();
  final TextEditingController customerName = TextEditingController();
  final TextEditingController searchKeyword = TextEditingController();
  final TextEditingController productSize = TextEditingController();
  final TextEditingController estimatePrice = TextEditingController();
  TextEditingController requestDate = TextEditingController();
  TextEditingController bcName = TextEditingController();
  TextEditingController departement = TextEditingController();

  TextEditingController dateinput = TextEditingController();
  DateTime? pickedDate;
  String formattedDate = 'null';
  String? product;
  String? categoryProduct;
  String? jenisRequest;
  String? warnaProduct;
  String? qualitasProduct;

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
    super.initState();
    bcName.text = sharedPreferences!.getString("name")!;
    departement.text = "Parva";
    requestDate.text = DateFormat('dd-MM-yyyy | HH:mm').format(DateTime.now());
    fToast = FToast();
    fToast.init(context);
    dateinput.text = ""; //set the initial value of text field
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
            "FORM ADD REQUEST",
            style: TextStyle(
                fontSize: 25, color: Colors.black, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  //request date
                  Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 8, left: 40),
                    child: SizedBox(
                      width: 315,
                      child: TextFormField(
                          enabled: false,
                          textAlign: TextAlign.center,
                          readOnly: true,
                          controller: requestDate,
                          decoration: const InputDecoration(
                            hintStyle:
                                TextStyle(fontSize: 18.0, color: Colors.white),
                            fillColor: Colors.black12,
                            filled: true,
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black12, width: 1),
                            ),
                          )
                          // validator: (value) {
                          //   if (value!.isEmpty) {
                          //     return 'Required *';
                          //   }
                          //   return null;
                          // },
                          ),
                    ),
                  ),

                  //Nama pemohon
                  Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 8, left: 40),
                    child: SizedBox(
                      width: 315,
                      child: TextFormField(
                          enabled: false,
                          textAlign: TextAlign.center,
                          readOnly: true,
                          controller: bcName,
                          decoration: const InputDecoration(
                            hintStyle:
                                TextStyle(fontSize: 18.0, color: Colors.white),
                            fillColor: Colors.black12,
                            filled: true,
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black12, width: 1),
                            ),
                          )
                          // validator: (value) {
                          //   if (value!.isEmpty) {
                          //     return 'Required *';
                          //   }
                          //   return null;
                          // },
                          ),
                    ),
                  ),

                  //departemen
                  Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 8, left: 40),
                    child: SizedBox(
                      width: 315,
                      child: TextFormField(
                          enabled: false,
                          textAlign: TextAlign.center,
                          readOnly: true,
                          controller: departement,
                          decoration: const InputDecoration(
                            hintStyle:
                                TextStyle(fontSize: 18.0, color: Colors.white),
                            fillColor: Colors.black12,
                            filled: true,
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black12, width: 1),
                            ),
                          )
                          // validator: (value) {
                          //   if (value!.isEmpty) {
                          //     return 'Required *';
                          //   }
                          //   return null;
                          // },
                          ),
                    ),
                  ),

                  //customer name
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      textInputAction: TextInputAction.next,
                      autofocus: true,
                      controller: customerName,
                      decoration: InputDecoration(
                        hintText: "example: Cahaya Sanivokasi",
                        labelText: "Customer name",
                        icon: const Icon(Icons.people),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Required *';
                        }
                        return null;
                      },
                    ),
                  ),

                  //search keyword
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      textInputAction: TextInputAction.next,

                      controller: searchKeyword,
                      decoration: InputDecoration(
                        // hintText: "example: Cahaya Sanivokasi",
                        labelText: "Search keyword",
                        icon: const Icon(Icons.manage_search_rounded),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                      ),
                      // validator: (value) {
                      //     if (value!.isEmpty) {
                      //       return 'Required *';
                      //     }
                      //     return null;
                      //   },
                    ),
                  ),

                  //pilih produk
                  Padding(
                    padding: const EdgeInsets.only(left: 40, right: 0),
                    child: SizedBox(
                      width: 300,
                      child: DecoratedBox(
                          decoration: BoxDecoration(
                              color: product != null
                                  ? const Color.fromARGB(255, 8, 209, 69)
                                  : const Color.fromRGBO(238, 240, 235,
                                      1), //background color of dropdown button
                              border: Border.all(
                                  color: Colors.black38,
                                  width: 3), //border of dropdown button
                              borderRadius: BorderRadius.circular(
                                  50), //border raiuds of dropdown button
                              boxShadow: const <BoxShadow>[
                                //apply shadow on Dropdown button
                                BoxShadow(
                                    color: Color.fromRGBO(
                                        0, 0, 0, 0.57), //shadow for button
                                    blurRadius: 5) //blur radius of shadow
                              ]),
                          child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 20, right: 20),
                              child: DropdownButton(
                                value: product,
                                items: const [
                                  //add items in the dropdown
                                  DropdownMenuItem(
                                    value: "001 (Parva)",
                                    child: Text("001 (Parva)"),
                                  )
                                ],
                                hint: const Text('Select a product'),
                                onChanged: (value) {
                                  print("You have selected $value");
                                  setState(() {
                                    product = value;
                                  });
                                },
                                icon: const Padding(
                                    padding: EdgeInsets.only(left: 20),
                                    child: Icon(Icons.arrow_circle_down_sharp)),
                                iconEnabledColor: Colors.black, //Icon color
                                style: const TextStyle(
                                    color: Colors.black, //Font color
                                    fontSize: 15 //font size on dropdown button
                                    ),

                                dropdownColor:
                                    Colors.white, //dropdown background color
                                underline: Container(), //remove underline
                                isExpanded: true, //make true to make width 100%
                              ))),
                    ),
                  ),

                  //CATEGORY PRODUCT
                  Padding(
                    padding: const EdgeInsets.only(left: 40, right: 0, top: 10),
                    child: SizedBox(
                      width: 300,
                      child: DecoratedBox(
                          decoration: BoxDecoration(
                              color: categoryProduct != null
                                  ? const Color.fromARGB(255, 8, 209, 69)
                                  : const Color.fromRGBO(238, 240, 235,
                                      1), //background color of dropdown button
                              border: Border.all(
                                  color: Colors.black38,
                                  width: 3), //border of dropdown button
                              borderRadius: BorderRadius.circular(
                                  50), //border raiuds of dropdown button
                              boxShadow: const <BoxShadow>[
                                //apply shadow on Dropdown button
                                BoxShadow(
                                    color: Color.fromRGBO(
                                        0, 0, 0, 0.57), //shadow for button
                                    blurRadius: 5) //blur radius of shadow
                              ]),
                          child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 20, right: 20),
                              child: DropdownButton(
                                value: categoryProduct,
                                items: const [
                                  //add items in the dropdown
                                  DropdownMenuItem(
                                    value: "Bangle",
                                    child: Text("Bangle"),
                                  ),
                                  DropdownMenuItem(
                                    value: "Bracelet",
                                    child: Text("Bracelet"),
                                  ),
                                  DropdownMenuItem(
                                    value: "Earings",
                                    child: Text("Earings"),
                                  ),
                                  DropdownMenuItem(
                                    value: "Koye",
                                    child: Text("Koye"),
                                  ),
                                  DropdownMenuItem(
                                    value: "Necklace",
                                    child: Text("Necklace"),
                                  ),
                                  DropdownMenuItem(
                                    value: "Pendant",
                                    child: Text("Pendant"),
                                  ),
                                  DropdownMenuItem(
                                    value: "Rings",
                                    child: Text("Rings"),
                                  )
                                ],
                                hint: const Text('Select product category'),
                                onChanged: (value) {
                                  print("You have selected $value");
                                  setState(() {
                                    categoryProduct = value;
                                  });
                                },
                                icon: const Padding(
                                    padding: EdgeInsets.only(left: 20),
                                    child: Icon(Icons.arrow_circle_down_sharp)),
                                iconEnabledColor: Colors.black, //Icon color
                                style: const TextStyle(
                                    color: Colors.black, //Font color
                                    fontSize: 15 //font size on dropdown button
                                    ),

                                dropdownColor:
                                    Colors.white, //dropdown background color
                                underline: Container(), //remove underline
                                isExpanded: true, //make true to make width 100%
                              ))),
                    ),
                  ),

                  //JENIS REQUEST
                  Padding(
                    padding: const EdgeInsets.only(left: 40, right: 0, top: 10),
                    child: SizedBox(
                      width: 300,
                      child: DecoratedBox(
                          decoration: BoxDecoration(
                              color: jenisRequest != null
                                  ? const Color.fromARGB(255, 8, 209, 69)
                                  : const Color.fromRGBO(238, 240, 235,
                                      1), //background color of dropdown button
                              border: Border.all(
                                  color: Colors.black38,
                                  width: 3), //border of dropdown button
                              borderRadius: BorderRadius.circular(
                                  50), //border raiuds of dropdown button
                              boxShadow: const <BoxShadow>[
                                //apply shadow on Dropdown button
                                BoxShadow(
                                    color: Color.fromRGBO(
                                        0, 0, 0, 0.57), //shadow for button
                                    blurRadius: 5) //blur radius of shadow
                              ]),
                          child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 20, right: 20),
                              child: DropdownButton(
                                value: jenisRequest,
                                items: const [
                                  //add items in the dropdown
                                  DropdownMenuItem(
                                    value: "Baru",
                                    child: Text("Baru"),
                                  ),
                                  DropdownMenuItem(
                                    value: "Revisi",
                                    child: Text("Revisi"),
                                  ),
                                  DropdownMenuItem(
                                    value: "Ro",
                                    child: Text("Ro"),
                                  ),
                                  DropdownMenuItem(
                                    value: "Reparasi",
                                    child: Text("Reparasi"),
                                  )
                                ],
                                hint: const Text('Select type of request'),
                                onChanged: (value) {
                                  print("You have selected $value");
                                  setState(() {
                                    jenisRequest = value;
                                  });
                                },
                                icon: const Padding(
                                    padding: EdgeInsets.only(left: 20),
                                    child: Icon(Icons.arrow_circle_down_sharp)),
                                iconEnabledColor: Colors.black, //Icon color
                                style: const TextStyle(
                                    color: Colors.black, //Font color
                                    fontSize: 15 //font size on dropdown button
                                    ),

                                dropdownColor:
                                    Colors.white, //dropdown background color
                                underline: Container(), //remove underline
                                isExpanded: true, //make true to make width 100%
                              ))),
                    ),
                  ),

                  //warna
                  Padding(
                    padding: const EdgeInsets.only(left: 40, right: 0, top: 10),
                    child: SizedBox(
                      width: 300,
                      child: DecoratedBox(
                          decoration: BoxDecoration(
                              color: warnaProduct != null
                                  ? const Color.fromARGB(255, 8, 209, 69)
                                  : const Color.fromRGBO(238, 240, 235,
                                      1), //background color of dropdown button
                              border: Border.all(
                                  color: Colors.black38,
                                  width: 3), //border of dropdown button
                              borderRadius: BorderRadius.circular(
                                  50), //border raiuds of dropdown button
                              boxShadow: const <BoxShadow>[
                                //apply shadow on Dropdown button
                                BoxShadow(
                                    color: Color.fromRGBO(
                                        0, 0, 0, 0.57), //shadow for button
                                    blurRadius: 5) //blur radius of shadow
                              ]),
                          child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 20, right: 20),
                              child: DropdownButton(
                                value: warnaProduct,
                                items: const [
                                  //add items in the dropdown
                                  DropdownMenuItem(
                                    value: "Rose gold",
                                    child: Text("Rose gold"),
                                  ),
                                  DropdownMenuItem(
                                    value: "White gold",
                                    child: Text("White gold"),
                                  ),
                                  DropdownMenuItem(
                                    value: "Yellow gold",
                                    child: Text("Yellow gold"),
                                  ),
                                  DropdownMenuItem(
                                    value: "Plating rose gold",
                                    child: Text("Plating rose gold"),
                                  ),
                                  DropdownMenuItem(
                                    value: "Plating yellow gold",
                                    child: Text("Plating yellow gold"),
                                  )
                                ],
                                hint:
                                    const Text('Select the product color type'),
                                onChanged: (value) {
                                  print("You have selected $value");
                                  setState(() {
                                    warnaProduct = value;
                                  });
                                },
                                icon: const Padding(
                                    padding: EdgeInsets.only(left: 20),
                                    child: Icon(Icons.arrow_circle_down_sharp)),
                                iconEnabledColor: Colors.black, //Icon color
                                style: const TextStyle(
                                    color: Colors.black, //Font color
                                    fontSize: 15 //font size on dropdown button
                                    ),

                                dropdownColor:
                                    Colors.white, //dropdown background color
                                underline: Container(), //remove underline
                                isExpanded: true, //make true to make width 100%
                              ))),
                    ),
                  ),

                  //kualitas
                  Padding(
                    padding: const EdgeInsets.only(left: 40, right: 0, top: 10),
                    child: SizedBox(
                      width: 300,
                      child: DecoratedBox(
                          decoration: BoxDecoration(
                              color: qualitasProduct != null
                                  ? const Color.fromARGB(255, 8, 209, 69)
                                  : const Color.fromRGBO(238, 240, 235,
                                      1), //background color of dropdown button
                              border: Border.all(
                                  color: Colors.black38,
                                  width: 3), //border of dropdown button
                              borderRadius: BorderRadius.circular(
                                  50), //border raiuds of dropdown button
                              boxShadow: const <BoxShadow>[
                                //apply shadow on Dropdown button
                                BoxShadow(
                                    color: Color.fromRGBO(
                                        0, 0, 0, 0.57), //shadow for button
                                    blurRadius: 5) //blur radius of shadow
                              ]),
                          child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 20, right: 20),
                              child: DropdownButton(
                                value: qualitasProduct,
                                items: const [
                                  //add items in the dropdown
                                  DropdownMenuItem(
                                    value: "SA - VVS",
                                    child: Text("SA - VVS"),
                                  ),
                                  DropdownMenuItem(
                                    value: "ZA - VS",
                                    child: Text("ZA - VS"),
                                  ),
                                  DropdownMenuItem(
                                    value: "GIA",
                                    child: Text("GIA"),
                                  ),
                                  DropdownMenuItem(
                                    value: "SI",
                                    child: Text("SI"),
                                  )
                                ],
                                hint: const Text('Select quality type'),
                                onChanged: (value) {
                                  print("You have selected $value");
                                  setState(() {
                                    qualitasProduct = value;
                                  });
                                },
                                icon: const Padding(
                                    padding: EdgeInsets.only(left: 20),
                                    child: Icon(Icons.arrow_circle_down_sharp)),
                                iconEnabledColor: Colors.black, //Icon color
                                style: const TextStyle(
                                    color: Colors.black, //Font color
                                    fontSize: 15 //font size on dropdown button
                                    ),

                                dropdownColor:
                                    Colors.white, //dropdown background color
                                underline: Container(), //remove underline
                                isExpanded: true, //make true to make width 100%
                              ))),
                    ),
                  ),

                  //product size
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      textInputAction: TextInputAction.next,
                      controller: productSize,
                      decoration: InputDecoration(
                        // hintText: "example: Cahaya Sanivokasi",
                        labelText: "Product size",
                        icon: const Icon(Icons.photo_size_select_large),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                      ),
                      // validator: (value) {
                      //     if (value!.isEmpty) {
                      //       return 'Required *';
                      //     }
                      //     return null;
                      //   },
                    ),
                  ),

                  //estimate price
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      textInputAction: TextInputAction.next,
                      controller: estimatePrice,
                      decoration: InputDecoration(
                        // hintText: "example: Cahaya Sanivokasi",
                        labelText: "Price estimate",
                        icon: const Icon(Icons.price_check),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                      ),
                      // validator: (value) {
                      //     if (value!.isEmpty) {
                      //       return 'Required *';
                      //     }
                      //     return null;
                      //   },
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black),
                        onPressed: () {
                          // myAlert();
                          openImages();
                        },
                        child: const Text(
                          'Upload Photo',
                          style: TextStyle(color: Colors.white),
                        ),
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
                  Card(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(0),
                        child: TextField(
                          keyboardType: TextInputType.text,

                          onChanged: (reportinput) {
                            setState(() {
                              btnController.reset();
                              reportinput = reportinput;
                            });
                          },
                          maxLines: 8, //or null
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              hintText: "Note"),
                          controller: reportinput,
                        ),
                      )),
                ],
              ),
            ),
          ),
        ),
        //save e ticketing
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.only(bottom: 40),
          child: CustomLoadingButton(
            controller: btnController,
            onPressed: () {
              print(fcmTokensandy);
              if (_formKey.currentState!.validate()) {
                Future.delayed(const Duration(milliseconds: 80))
                    .then((value) async {
                  btnController.success(); //sucses
                  await notif.sendNotificationTo(fcmTokensandy, 'E-TICKETING',
                      'BC : ${bcName.text} \nAdd request TICKETING to ${customerName.text}');
                  Future.delayed(const Duration(seconds: 1)).then((value) {
                    btnController.reset(); //reset
                  });
                });
              } else {
                Future.delayed(const Duration(milliseconds: 80))
                    .then((value) async {
                  btnController.error(); //error

                  Future.delayed(const Duration(seconds: 1)).then((value) {
                    btnController.reset(); //reset
                  });
                });
              }
            },
            child: const Text(
              "Save Request",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ));
  }

  // //mengirim notif
  // sendMotificationToBc(tokenBC) {
  //   Map bodyNotification = {
  //     'title': 'E-TICKETING',
  //     'body':
  //         'BC : ${bcName.text} \nAdd request TICKETING to ${customerName.text}',
  //     'sound': 'default'
  //   };
  //   Map<String, String> headersAPI = {
  //     'Content-Type': 'application/json',
  //     'Authorization': 'key=$fcmServerToken',
  //   };
  //   Map bodyAPI = {
  //     'to': tokenBC,
  //     'priority': 'high',
  //     'notification': bodyNotification,
  //     // 'data': dataMap,
  //   };
  //   http.post(Uri.parse("https://fcm.googleapis.com/fcm/send"),
  //       headers: headersAPI, body: jsonEncode(bodyAPI));
  // }

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
  formValidation() async {}
}

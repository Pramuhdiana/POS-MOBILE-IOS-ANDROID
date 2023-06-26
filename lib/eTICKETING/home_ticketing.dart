// ignore_for_file: avoid_print, non_constant_identifier_names, sized_box_for_whitespace, depend_on_referenced_packages

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
class HomeEticketing extends StatefulWidget {
  @override
  State<HomeEticketing> createState() => _HomeEticketingState();
}

class _HomeEticketingState extends State<HomeEticketing> {
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
            "E-TICKETING",
            style: TextStyle(
              fontSize: 20,
              letterSpacing: 3,
            ),
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

                  //product size
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
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
                      controller: estimatePrice,
                      decoration: InputDecoration(
                        // hintText: "example: Cahaya Sanivokasi",
                        labelText: "Estimate price",
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
                  // Padding(
                  //   padding: const EdgeInsets.all(8.0),
                  //   child: TextFormField(
                  //     obscureText: true,
                  //     decoration: InputDecoration(
                  //       labelText: "Password",
                  //       icon: const Icon(Icons.security),
                  //       border: OutlineInputBorder(
                  //           borderRadius: BorderRadius.circular(5.0)),
                  //     ),
                  //     validator: (value) {
                  //       if (value!.isEmpty) {
                  //         return 'Password tidak boleh kosong';
                  //       }
                  //       return null;
                  //     },
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.only(left: 50, right: 50, bottom: 5),
          child: CustomLoadingButton(
            controller: btnController,
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                Future.delayed(const Duration(milliseconds: 80)).then((value) {
                  btnController.success(); //sucses
                  Future.delayed(const Duration(seconds: 1)).then((value) {
                    btnController.reset(); //reset
                  });
                });
              } else {
                Future.delayed(const Duration(milliseconds: 80)).then((value) {
                  btnController.error(); //error
                  Future.delayed(const Duration(seconds: 1)).then((value) {
                    btnController.reset(); //reset
                  });
                });
              }
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

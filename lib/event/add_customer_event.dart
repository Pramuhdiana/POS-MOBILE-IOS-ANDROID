// ignore_for_file: avoid_print, non_constant_identifier_names, sized_box_for_whitespace, depend_on_referenced_packages

import 'package:e_shop/api/api_constant.dart';
import 'package:e_shop/event/transaksi_event_screen.dart';
import 'package:e_shop/global/global.dart';
import 'package:e_shop/widgets/custom_loading.dart';
import 'package:e_shop/widgets/keyboard_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:rounded_loading_button/rounded_loading_button.dart';

// ignore: use_key_in_widget_constructors
class AddCustomerEventScreen extends StatefulWidget {
  @override
  State<AddCustomerEventScreen> createState() =>
      _AddCustomerEventScreenState();
}

class _AddCustomerEventScreenState extends State<AddCustomerEventScreen> {
  FocusNode numberFocusNode = FocusNode();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  RoundedLoadingButtonController btnController =
      RoundedLoadingButtonController();

  TextEditingController name = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController customerGroup = TextEditingController();
  TextEditingController dateinput = TextEditingController();

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
  }

  @override
  void dispose() {
    // Clean up the focus node
    numberFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false, //? keyboard overflowed
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
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
            "ADD CUSTOMER",
            style: TextStyle(
                fontSize: 25, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          centerTitle: true,
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          alignment: Alignment.center,
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: TextFormField(
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                    textInputAction: TextInputAction.next,
                    controller: name,
                    autofocus: true,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      label: const Text(
                        "Name",
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
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
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: TextFormField(
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                    textInputAction: TextInputAction.next,
                    controller: phone,
                    keyboardType: TextInputType.number,
                    focusNode: numberFocusNode,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      label: const Text(
                        "Phone",
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
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
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: TextFormField(
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                    textInputAction: TextInputAction.newline,
                    controller: address,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      label: const Text(
                        "Address",
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(0.0)),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Required *';
                      }
                      return null;
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: TextFormField(
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                    //? function send langsung dari keyboard atau bisa memanggil funcion lain
                    textInputAction: TextInputAction.send,
                    onFieldSubmitted: (value) {
                      formValidasi();
                    },
                    controller: customerGroup,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      label: const Text(
                        "Detail Address",
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(0.0)),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Required *';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
          ),
        ), //Row
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.only(bottom: 40),
          child: CustomLoadingButton(
            controller: btnController,
            onPressed: () {
              formValidasi();
            },
            child: const Text(
              "Save Customer",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ));
  }

  formValidasi() async {
    //validasi
    final isValid = formKey.currentState?.validate();
    if (!isValid!) {
      btnController.error();
      Future.delayed(const Duration(seconds: 1)).then((value) {
        btnController.reset(); //reset
      });
      // return;
    } else {
      await postAPIreport();
    }
  }

//send data to DATABASE with API
  postAPIreport() async {
    String token = sharedPreferences!.getString("token").toString();
    Map<String, String> body = {
      'name': name.text,
      'phone': phone.text,
      'alamat': address.text,
      'customer_group': customerGroup.text,
    };
    final response = await http.post(
        Uri.parse(ApiConstants.baseUrl + ApiConstants.POSTcreateCustomerMetier),
        headers: <String, String>{
          'Authorization': 'Bearer $token',
        },
        body: body);
    print(response.statusCode);
    if (response.statusCode != 200) {
      btnController.error();
      Fluttertoast.showToast(msg: 'Add customer error (database off)');

      Future.delayed(const Duration(seconds: 1)).then((value) {
        btnController.reset(); //reset
      });
    } else {
      btnController.success();
      Fluttertoast.showToast(msg: 'Add customer success');
      Future.delayed(const Duration(seconds: 1)).then((value) {
        btnController.reset(); //reset
        setState(() {
          
        });
        Navigator.pop(
            context, MaterialPageRoute(builder: (c) => const TransaksiScreenEvent()));
      });
    }
  }
}

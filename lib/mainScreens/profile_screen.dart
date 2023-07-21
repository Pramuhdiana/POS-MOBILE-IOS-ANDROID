import 'package:e_shop/global/global.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController bcName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController since = TextEditingController();

  @override
  void initState() {
    super.initState();
    bcName.text = sharedPreferences!.getString("name")!;
    email.text = sharedPreferences!.getString("email")!;
    DateTime tempDate = DateFormat("yyyy-MM-dd")
        .parse(sharedPreferences!.getString("created_at")!);
    since.text = DateFormat('dd-MM-yyyy').format(tempDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: const Text(
            "Profile",
            style: TextStyle(fontSize: 25, color: Colors.black),
          ),
          // title: const FakeSearch(),
          automaticallyImplyLeading: false,
          centerTitle: true,
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
            child: Container(
                padding: const EdgeInsets.only(left: 25, right: 25),
                child: Column(children: [
                  //Nama pemohon
                  Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 8),
                    child: SizedBox(
                      width: 315,
                      child: TextFormField(
                          enabled: false,
                          textAlign: TextAlign.left,
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
                            label: Text(
                              'Name',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                            ),
                          )),
                    ),
                  ),

                  //email
                  Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 8),
                    child: SizedBox(
                      width: 315,
                      child: TextFormField(
                          enabled: false,
                          textAlign: TextAlign.left,
                          readOnly: true,
                          controller: email,
                          decoration: const InputDecoration(
                            hintStyle:
                                TextStyle(fontSize: 18.0, color: Colors.white),
                            fillColor: Colors.black12,
                            filled: true,
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black12, width: 1),
                            ),
                            label: Text(
                              'Email',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                            ),
                          )),
                    ),
                  ),
                  //since
                  Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 8),
                    child: SizedBox(
                      width: 315,
                      child: TextFormField(
                          enabled: false,
                          textAlign: TextAlign.left,
                          readOnly: true,
                          controller: since,
                          decoration: const InputDecoration(
                            hintStyle:
                                TextStyle(fontSize: 18.0, color: Colors.white),
                            fillColor: Colors.black12,
                            filled: true,
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black12, width: 1),
                            ),
                            label: Text(
                              'Since',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                            ),
                          )),
                    ),
                  ),
                ]))));
  }
}

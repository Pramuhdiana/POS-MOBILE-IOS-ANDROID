// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously, avoid_print, unused_local_variable

import 'dart:convert' as convert;

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:e_shop/api/api_constant.dart';
import 'package:e_shop/global/global.dart';
import 'package:e_shop/mainScreens/home_screen.dart';
import 'package:e_shop/splashScreen/my_splas_screen.dart';
import 'package:e_shop/widgets/custom_dialog.dart';
import 'package:e_shop/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class LoginTabPage extends StatefulWidget {
  const LoginTabPage({super.key});

  @override
  State<LoginTabPage> createState() => _LoginTabPageState();
}

class _LoginTabPageState extends State<LoginTabPage> {
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  Future<GetToken>? _futureGetToken;
  String? pilihEmail;
  // ignore: unused_field
  final _formKey = GlobalKey<FormState>();

  //validasi form
  validateForm() async {
    if (emailTextEditingController.text.isNotEmpty &&
        passwordTextEditingController.text.isNotEmpty) {
      //allow user to login
      try {
        await sharedPreferences?.setBool('dbDummy', false);
        await loginNow();
      } catch (e) {
        showCustomDialog(
          context: context,
          dialogType: DialogType.error,
          title: 'Error Login',
          description: "$e",
        );
      }
    } else {
      showCustomDialog(
        context: context,
        dialogType: DialogType.info,
        title: 'Info',
        description: "Please provide email and password.",
      );
    }
  }

//login dengan API
  loginNow() async {
    bool? dbDummy = sharedPreferences?.getBool('dbDummy');
    showDialog(
        context: context,
        builder: (c) {
          return const LoadingDialogWidget(
            message: "Checking credentials,",
          );
        });

    // User? currentUser;

    String email = emailTextEditingController.text;
    String password = passwordTextEditingController.text;
    final response = await http.post(
      Uri.parse(ApiConstants.baseUrl + ApiConstants.POSTloginendpoint),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: convert.jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      checkIfUserRecordExists(response.body);
    } else {
      Navigator.pop(context);
      showCustomDialog(
        context: context,
        dialogType: DialogType.info,
        title: 'Info',
        description: 'Email & Password Incorrect',
      );
    }
  }

  //method jika user sudah ada
  checkIfUserRecordExists(getToken) async {
    var jsonResponse = convert.jsonDecode(getToken) as Map<String, dynamic>;
    var token = jsonResponse['access_token'];
    print(jsonResponse);
    print(token);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', token);
    Navigator.push(
        context, MaterialPageRoute(builder: (c) => const MySplashScreen()));
  }

  FutureBuilder<GetToken> setToken() {
    return FutureBuilder<GetToken>(
        future: _futureGetToken,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            String token = '';
            print(snapshot.data!.access_token);
            sharedPreferences!.setString("token", snapshot.data!.access_token);
            return Column(
              children: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (c) => const HomeScreen()));
                    },
                    child: const Text('Back')),
              ],
            );
          } else if (snapshot.hasError) {
            return const Text('datanya error');
          }
          return Center(
              child: Container(
                  padding: const EdgeInsets.all(0),
                  width: 90,
                  height: 90,
                  child: Lottie.asset("json/loading_black.json")));
        });
  }

  Future refresh() async {
    await sharedPreferences?.setBool('dbDummy', false);

    TextEditingController kodeAkses = TextEditingController();

    setState(() {
      showGeneralDialog(
          pageBuilder: (context, animation1, animation2) {
            return const Text('');
          },
          context: context,
          transitionDuration: const Duration(milliseconds: 200),
          barrierDismissible: true,
          barrierLabel: '',
          transitionBuilder: (context, a1, a2, widget) => Transform.scale(
              scale: a1.value,
              child: Opacity(
                  opacity: a1.value,
                  child: StatefulBuilder(
                      builder: (context, setState) => AlertDialog(
                            content: Stack(
                              clipBehavior: Clip.none,
                              children: <Widget>[
                                Positioned(
                                  right: -47.0,
                                  top: -47.0,
                                  child: InkResponse(
                                    onTap: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const CircleAvatar(
                                      backgroundColor: Colors.red,
                                      child: Icon(Icons.close),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  child: Form(
                                    key: _formKey,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        const Padding(
                                          padding: EdgeInsets.only(
                                              top: 5, bottom: 10),
                                          child: Text(
                                              'Masukan Kode Akses Untuk Login Ke Database Dummy'),
                                        ),
                                        // Container(
                                        //   alignment: Alignment.bottomLeft,
                                        //   child: Row(
                                        //     mainAxisAlignment:
                                        //         MainAxisAlignment.start,
                                        //     children: [
                                        //       const Text(
                                        //         'Dummy Database ? ',
                                        //         style: TextStyle(
                                        //             color: Colors.black,
                                        //             fontSize: 12,
                                        //             fontWeight:
                                        //                 FontWeight.bold),
                                        //       ),
                                        //       Checkbox(
                                        //         value: dbDummy,
                                        //         onChanged: (bool? value) {
                                        //           dbDummy = value!;
                                        //           setState(() => dbDummy);
                                        //           print(dbDummy);
                                        //         },
                                        //       ),
                                        //     ],
                                        //   ),
                                        // ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: DecoratedBox(
                                              decoration: BoxDecoration(
                                                  color: const Color.fromRGBO(
                                                      238,
                                                      240,
                                                      235,
                                                      1), //background color of dropdown button
                                                  border: Border.all(
                                                      color: Colors.black38,
                                                      width:
                                                          3), //border of dropdown button
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          50), //border raiuds of dropdown button
                                                  boxShadow: const <BoxShadow>[
                                                    //apply shadow on Dropdown button
                                                    BoxShadow(
                                                        color: Color.fromRGBO(
                                                            0,
                                                            0,
                                                            0,
                                                            0.57), //shadow for button
                                                        blurRadius:
                                                            5) //blur radius of shadow
                                                  ]),
                                              child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 20, right: 20),
                                                  child: DropdownButton(
                                                    value: pilihEmail,
                                                    items: const [
                                                      //add items in the dropdown
                                                      DropdownMenuItem(
                                                        value:
                                                            "andy@sanivokasi.com",
                                                        child: Text(
                                                            "andy@sanivokasi.com"),
                                                      ),
                                                      DropdownMenuItem(
                                                        value:
                                                            "andhika@sanivokasi.com",
                                                        child: Text(
                                                            "andhika@sanivokasi.com"),
                                                      ),
                                                      DropdownMenuItem(
                                                        value:
                                                            "erick@sanivokasi.com",
                                                        child: Text(
                                                            "erick@sanivokasi.com"),
                                                      ),
                                                      DropdownMenuItem(
                                                        value:
                                                            "hendrik@sanivokasi.com",
                                                        child: Text(
                                                            "hendrik@sanivokasi.com"),
                                                      ),
                                                      DropdownMenuItem(
                                                        value:
                                                            "jonathan@sanivokasi.com",
                                                        child: Text(
                                                            "jonathan@sanivokasi.com"),
                                                      )
                                                    ],
                                                    hint: const Text(
                                                        'Select account'),
                                                    onChanged: (value) {
                                                      print(
                                                          "You have selected $value");
                                                      setState(() {
                                                        pilihEmail = value;
                                                        emailTextEditingController
                                                            .text = value ?? '';
                                                      });
                                                    },
                                                    icon: const Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 20),
                                                        child: Icon(Icons
                                                            .arrow_circle_down_sharp)),
                                                    iconEnabledColor: Colors
                                                        .black, //Icon color
                                                    style: const TextStyle(
                                                        color: Colors
                                                            .black, //Font color
                                                        fontSize:
                                                            15 //font size on dropdown button
                                                        ),

                                                    dropdownColor: Colors
                                                        .white, //dropdown background color
                                                    underline:
                                                        Container(), //remove underline
                                                    isExpanded:
                                                        true, //make true to make width 100%
                                                  ))),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: TextFormField(
                                            style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                            textInputAction:
                                                TextInputAction.next,
                                            controller:
                                                passwordTextEditingController,
                                            decoration: InputDecoration(
                                              labelText: "Password",
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.0)),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: TextFormField(
                                            obscureText: true,
                                            style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                            textInputAction:
                                                TextInputAction.next,
                                            controller: kodeAkses,
                                            validator: (value) {
                                              if (value! != '121019') {
                                                return 'Kode akses salah';
                                              }
                                              return null;
                                            },
                                            decoration: InputDecoration(
                                              labelText: "Kode Akses",
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.0)),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: 200,
                                          height: 50,
                                          padding:
                                              const EdgeInsets.only(top: 10),
                                          child: ElevatedButton(
                                            child: const Text("Submit"),
                                            onPressed: () async {
                                              if (_formKey.currentState!
                                                  .validate()) {
                                                _formKey.currentState!.save();
                                                await sharedPreferences
                                                    ?.setBool('dbDummy', true);
                                                await loginNow();
                                              } else {}
                                            },
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )))));
    });
  }

  @override
  void initState() {
    super.initState();
    print('No Version : $noBuild');
    print(ApiConstants.baseUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: refresh,
        child: Stack(clipBehavior: Clip.none, children: [
          Positioned(
            right: -150,
            top: 35,
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 1,
              child: Transform.scale(
                  scale: 1.7,
                  child: SizedBox(
                      child: Lottie.asset("json/backgroundAnimasi.json"))),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 25),
            child: ListView(children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 112),
                    child: SizedBox(
                        height: 120,
                        child: Column(
                          children: [
                            Text(
                              'POS',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 55),
                            ),
                            Text(
                              'Mobile',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 25),
                            )
                          ],
                        )),
                  ),
                  const Padding(
                      padding: EdgeInsets.only(top: 52, bottom: 10),
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          'Welcome!',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      )),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'please login or sign up to continue our app',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ),
                  const SizedBox(height: 66),

                  //email
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    style: const TextStyle(fontSize: 14, color: Colors.black),
                    controller: emailTextEditingController,
                    onChanged: (value) {
                      setState(() {});
                    },
                    decoration: InputDecoration(
                      floatingLabelStyle: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                      labelText: 'Email',
                      suffixIcon: emailTextEditingController.text.isEmpty
                          ? const Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: Icon(
                                Icons.check_circle,
                                size: 20,
                              ),
                            )
                          : const Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: Icon(
                                Icons.check_circle,
                                color: Colors.green,
                                size: 20,
                              ),
                            ),
                    ),
                  ),

                  //pasword
                  TextFormField(
                    obscureText: true,
                    style: const TextStyle(fontSize: 14, color: Colors.black),
                    controller: passwordTextEditingController,
                    onChanged: (value) {
                      setState(() {});
                    },
                    decoration: InputDecoration(
                      floatingLabelStyle: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                      labelText: 'Password',
                      suffixIcon: passwordTextEditingController.text.isEmpty
                          ? const Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: Icon(
                                Icons.check_circle,
                                size: 20,
                              ),
                            )
                          : const Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: Icon(
                                Icons.check_circle,
                                color: Colors.green,
                                size: 20,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(
                    height: 52,
                  ),
                  //button login
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 1,
                    height: 50,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ))),
                      onPressed: () {
                        validateForm();
                      },
                      child: const Text('Login',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 10),
                    child: Row(children: <Widget>[
                      Expanded(
                          child: Divider(
                        thickness: 1,
                      )),
                      Text("or"),
                      Expanded(
                          child: Divider(
                        thickness: 1,
                      )),
                    ]),
                  ),
                  //button login facebook

                  SizedBox(
                    width: MediaQuery.of(context).size.width * 1,
                    height: 50,
                    child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                const Color(0xFB3B5998)),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ))),
                        onPressed: () {
                          Fluttertoast.showToast(msg: "Not available");
                        },
                        child: const Padding(
                          padding: EdgeInsets.only(left: 45),
                          child: Row(
                            children: [
                              Icon(Icons.facebook),
                              Text('  Continue with ',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  )),
                              Text(
                                'Facebook',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        )),
                  ),

                  //button login google
                  Padding(
                    padding: const EdgeInsets.only(top: 15, bottom: 15),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 1,
                      height: 50,
                      child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.white),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                      side: BorderSide(
                                          color: Colors.grey.shade200)))),
                          onPressed: () {
                            Fluttertoast.showToast(msg: "Not available");
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left: 50),
                            child: Row(
                              children: [
                                Image.asset(
                                  "assets/icon.png",
                                  height: 15,
                                  width: 15,
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(left: 4),
                                  child: Text('  Continue with ',
                                      style: TextStyle(
                                        color: Color(0xF6666666),
                                        fontSize: 16,
                                      )),
                                ),
                                const Text(
                                  'Google',
                                  style: TextStyle(
                                      color: Color(0xF6666666),
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          )),
                    ),
                  ),

                  //button login apple
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 1,
                    height: 50,
                    child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.white),
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                    side: BorderSide(
                                        color: Colors.grey.shade200)))),
                        onPressed: () {
                          Fluttertoast.showToast(msg: "Not available");
                        },
                        child: const Padding(
                          padding: EdgeInsets.only(left: 45),
                          child: Row(
                            children: [
                              Icon(
                                Icons.apple,
                                color: Colors.black,
                              ),
                              Text('  Continue with ',
                                  style: TextStyle(
                                    color: Color(0xF6666666),
                                    fontSize: 16,
                                  )),
                              Text(
                                'Apple',
                                style: TextStyle(
                                    color: Color(0xF6666666),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        )),
                  ),
                ],
              ),
            ]),
          ),
        ]),
      ),
    );
  }
}

class GetToken {
  final String message;
  final String access_token;
  final String token_type;

  const GetToken(
      {required this.message,
      required this.access_token,
      required this.token_type});

  factory GetToken.fromJson(Map<String, dynamic> json) {
    return GetToken(
      message: json['message'],
      access_token: json['access_token'],
      token_type: json['token_type'],
    );
  }
}

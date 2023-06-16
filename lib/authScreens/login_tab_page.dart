// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously, avoid_print, unused_local_variable

import 'dart:convert' as convert;

import 'package:e_shop/api/api_constant.dart';
import 'package:e_shop/global/global.dart';
import 'package:e_shop/mainScreens/home_screen.dart';
import 'package:e_shop/splashScreen/my_splas_screen.dart';
import 'package:e_shop/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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

  //validasi form
  validateForm() async {
    if (emailTextEditingController.text.isNotEmpty &&
        passwordTextEditingController.text.isNotEmpty) {
      //allow user to login
      await loginNow();
    } else {
      Fluttertoast.showToast(msg: "Please provide email and password.");
    }
  }

//login dengan API
  loginNow() async {
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
      Fluttertoast.showToast(msg: "Email & Password Incorrect ");
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
            // return Text('${snapshot.error}');
          }
          return const CircularProgressIndicator();
        });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.all(30.0),
          child: Image.asset(
            "images/try.png",
            height: MediaQuery.of(context).size.height * 0.40,
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.2,
        ),
        Form(
          key: formKey,
          child: Column(
            children: [
              SizedBox(
                width: 257,
                child: TextFormField(
                    textAlign: TextAlign.center,
                    controller: emailTextEditingController,
                    decoration: InputDecoration(
                      hintStyle:
                          const TextStyle(fontSize: 18.0, color: Colors.white),
                      hintText: "Email",
                      fillColor: Colors.black26,
                      filled: true,
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.white, width: 1),
                        borderRadius: BorderRadius.circular(100.0),
                      ),
                    )),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: 257,
                child: TextFormField(
                    textAlign: TextAlign.center,
                    obscureText: true,
                    controller: passwordTextEditingController,
                    decoration: InputDecoration(
                      hintStyle:
                          const TextStyle(fontSize: 18.0, color: Colors.white),
                      hintText: "Password",
                      fillColor: Colors.black26,
                      filled: true,
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.white, width: 1),
                        borderRadius: BorderRadius.circular(100.0),
                      ),
                    )),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Transform.scale(
            scale: 1.5,
            child: OutlinedButton(
              onPressed: () {
                validateForm();
              },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.white, width: 7.9),
                shape: const CircleBorder(),
              ),
              child: IconButton(
                onPressed: () {
                  validateForm();
                },
                icon: Image.asset(
                  "images/log-in.png",
                ),
              ),
            ),
          ),
        ),
      ]),
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
//method login
  // loginNow() async {
  //   showDialog(
  //       context: context,
  //       builder: (c) {
  //         return const LoadingDialogWidget(
  //           message: "Checking credentials",
  //         );
  //       });

  //   User? currentUser;

  //   await FirebaseAuth.instance
  //       .signInWithEmailAndPassword(
  //     email: emailTextEditingController.text.trim(),
  //     password: passwordTextEditingController.text.trim(),
  //   )
  //       .then((auth) {
  //     currentUser = auth.user;
  //   }).catchError((errorMessage) {
  //     Navigator.pop(context);
  //     Fluttertoast.showToast(msg: "Error Occurred: \n $errorMessage");
  //   });

  //   if (currentUser != null) {
  //     checkIfUserRecordExists(currentUser!);
  //   }
  // }
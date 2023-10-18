// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously, avoid_print, unused_local_variable

import 'dart:convert' as convert;

import 'package:e_shop/api/api_constant.dart';
import 'package:e_shop/global/global.dart';
import 'package:e_shop/mainScreens/home_screen.dart';
import 'package:e_shop/splashScreen/my_splas_screen.dart';
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
          return Center(
              child: Container(
                  padding: const EdgeInsets.all(0),
                  width: 90,
                  height: 90,
                  child: Lottie.asset("json/loading_black.json")));
        });
  }

  Future refresh() async {
    setState(() {
      // Fluttertoast.showToast(msg: "Refresh done");
    });
  }

  @override
  void initState() {
    super.initState();
    print('No Version : $noBuild');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: refresh,
        child: Container(
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
                    // IconButton(
                    //     onPressed: emailTextEditingController.clear,
                    //     icon: const Icon(Icons.clear),
                    //   ),
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
                    // IconButton(
                    //     onPressed: emailTextEditingController.clear,
                    //     icon: const Icon(Icons.clear),
                    //   ),
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
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
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
                              // Icon(
                              //   Icons.apple,
                              //   color: Colors.black,
                              // ),
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
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
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

// SingleChildScrollView(
//       child: Column(children: [
//         Padding(
//           padding: const EdgeInsets.all(30.0),
//           child: Image.asset(
//             "images/try.png",
//             height: MediaQuery.of(context).size.height * 0.40,
//           ),
//         ),
//         SizedBox(
//           height: MediaQuery.of(context).size.height * 0.2,
//         ),
//         Form(
//           key: formKey,
//           child: Column(
//             children: [
//               SizedBox(
//                 width: 257,
//                 child: TextFormField(
//                     textAlign: TextAlign.center,
//                     controller: emailTextEditingController,
//                     decoration: InputDecoration(
//                       hintStyle:
//                           const TextStyle(fontSize: 18.0, color: Colors.white),
//                       hintText: "Email",
//                       fillColor: Colors.black26,
//                       filled: true,
//                       enabledBorder: OutlineInputBorder(
//                         borderSide:
//                             const BorderSide(color: Colors.white, width: 1),
//                         borderRadius: BorderRadius.circular(100.0),
//                       ),
//                     )),
//               ),
//               const SizedBox(
//                 height: 20,
//               ),
//               SizedBox(
//                 width: 257,
//                 child: TextFormField(
//                     textAlign: TextAlign.center,
//                     obscureText: true,
//                     controller: passwordTextEditingController,
//                     decoration: InputDecoration(
//                       hintStyle:
//                           const TextStyle(fontSize: 18.0, color: Colors.white),
//                       hintText: "Password",
//                       fillColor: Colors.black26,
//                       filled: true,
//                       enabledBorder: OutlineInputBorder(
//                         borderSide:
//                             const BorderSide(color: Colors.white, width: 1),
//                         borderRadius: BorderRadius.circular(100.0),
//                       ),
//                     )),
//               ),
//             ],
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.only(top: 20),
//           child: Transform.scale(
//             scale: 1.5,
//             child: OutlinedButton(
//               onPressed: () {
//                 validateForm();
//               },
//               style: OutlinedButton.styleFrom(
//                 side: const BorderSide(color: Colors.white, width: 7.9),
//                 shape: const CircleBorder(),
//               ),
//               child: IconButton(
//                 onPressed: () {
//                   validateForm();
//                 },
//                 icon: Image.asset(
//                   "images/log-in.png",
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ]),
//     );
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
// // ignore_for_file: use_build_context_synchronously, avoid_unnecessary_containers, prefer_const_constructors, library_prefixes

// import 'dart:io';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:e_shop/global/global.dart';
// import 'package:e_shop/splashScreen/my_splas_screen.dart';
// import 'package:e_shop/widgets/custom_text_field.dart';
// import 'package:e_shop/widgets/loading_widget.dart';
// // import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:firebase_storage/firebase_storage.dart' as fStorage;
// import 'package:shared_preferences/shared_preferences.dart';

// class RegistrationTabPage extends StatefulWidget {
//   const RegistrationTabPage({super.key});

//   @override
//   State<RegistrationTabPage> createState() => _RegistrationTabPageState();
// }

// class _RegistrationTabPageState extends State<RegistrationTabPage> {
//   TextEditingController nameTextEditingController = TextEditingController();
//   TextEditingController emailTextEditingController = TextEditingController();
//   TextEditingController passwordTextEditingController = TextEditingController();
//   TextEditingController confirmPasswordTextEditingController =
//       TextEditingController();
//   GlobalKey<FormState> formKey = GlobalKey<FormState>();
//   String downloadUrlImage = "";

//   XFile? imgXFile;
//   final ImagePicker imagePicker = ImagePicker();

//   getImageFromGallery() async {
//     imgXFile = await imagePicker.pickImage(source: ImageSource.gallery);

//     setState(() {
//       imgXFile;
//     });
//   }

// //form validasi
//   formValidation() async {
//     if (imgXFile == null) //jika gambar tidak di pilih
//     {
//       Fluttertoast.showToast(msg: "Pleaase select an image");
//     } else //gambar di pilih
//     {
//       //   //cek password
//       if (passwordTextEditingController.text ==
//           confirmPasswordTextEditingController
//               .text) //jika password 1 dan 2 sama
//       {
//         //     //check email & name pasword & confirm text field
//         if (nameTextEditingController.text.isNotEmpty &&
//             emailTextEditingController.text.isNotEmpty &&
//             passwordTextEditingController.text.isNotEmpty &&
//             confirmPasswordTextEditingController
//                 .text.isNotEmpty) //jika semua kolom di isi
//         {
//           showDialog(
//               context: context,
//               builder: (c) {
//                 return LoadingDialogWidget(
//                   message: "Registring Your account",
//                 );
//               });
//           //upload image to storage
//           String fileName = DateTime.now().millisecondsSinceEpoch.toString();
//           fStorage.Reference storageRef = fStorage.FirebaseStorage.instance
//               .ref()
//               .child("usersImages")
//               .child(fileName);

//           fStorage.UploadTask uploadImageTask =
//               storageRef.putFile(File(imgXFile!.path));

//           fStorage.TaskSnapshot taskSnapshot =
//               await uploadImageTask.whenComplete(() {});

//           await taskSnapshot.ref.getDownloadURL().then((urlImage) {
//             downloadUrlImage = urlImage;
//           });

//           //save the user info to firestore database
//           saveInformationToDatabase();
//         } else {
//           Navigator.pop(context);
//           Fluttertoast.showToast(
//               msg:
//                   "Please complete the form. Do not leave any text field empty");
//         }
//       } else {
//         Fluttertoast.showToast(
//             msg: "Password and Confirm Password do not match");
//       }
//     }
//   }

//   //method save data
//   saveInformationToDatabase() async {
//     //authentic user
//     // User? currentUser;

//     // await FirebaseAuth.instance
//     //     .createUserWithEmailAndPassword(
//     //   email: emailTextEditingController.text.trim(),
//     //   password: passwordTextEditingController.text.trim(),
//     // )
//     //     .then((auth) {
//     //   currentUser = auth.user;
//     // }).catchError((errorMessage) {
//     //   Navigator.pop(context);
//     //   Fluttertoast.showToast(msg: "Error Occurred: \n $errorMessage");
//     // });

//     // if (currentUser != null) {
//     //   //save info ke database dan save local
//     //   saveInfoToFirestoreAndLocally(currentUser!);
//     // }
//   }

//   saveInfoToFirestoreAndLocally(User currentUser) async {
//     //save fIrestore MEMBUAT FOLDER USERS
//     FirebaseFirestore.instance
//         .collection("users")
//         .doc(nameTextEditingController.text.trim())
//         .set({
//       "uid": currentUser.uid,
//       "email": currentUser.email,
//       "name": nameTextEditingController.text.trim(),
//       "photoUrl": downloadUrlImage,
//       "sales_id": "0",
//       "status": "approved",
//       "userCart": ["initialValue"],
//     });

//     // save locally
//     sharedPreferences = await SharedPreferences.getInstance();
//     await sharedPreferences!.setString("uid", currentUser.uid);
//     await sharedPreferences!.setString("email", currentUser.email!);
//     await sharedPreferences!
//         .setString("name", nameTextEditingController.text.trim());
//     await sharedPreferences!.setString("photoUrl", downloadUrlImage);
//     await sharedPreferences!.setString("sales_id", "0");
//     await sharedPreferences!.setStringList("userCart", ["initialValue"]);

//     Navigator.push(
//         context, MaterialPageRoute(builder: (c) => MySplashScreen()));
//   }

//   @override
//   Widget build(BuildContext context) {
//     var jarak_20 = const SizedBox(
//       height: 0,
//     );
//     return SingleChildScrollView(
//       child: Container(
//         child: Column(
//           children: [
//             const SizedBox(
//               height: 12,
//             ),

//             //get-capture image
//             GestureDetector(
//               onTap: () {
//                 getImageFromGallery();
//               },
//               child: CircleAvatar(
//                 radius: MediaQuery.of(context).size.width * 0.20,
//                 backgroundColor: Colors.white,
//                 backgroundImage:
//                     imgXFile == null ? null : FileImage(File(imgXFile!.path)),
//                 child: imgXFile == null
//                     ? Icon(
//                         Icons.add_photo_alternate,
//                         color: Colors.grey,
//                         size: MediaQuery.of(context).size.width * 0.20,
//                       )
//                     : null,
//               ),
//             ),

//             const SizedBox(
//               height: 20,
//             ),

//             //input form field
//             Form(
//               key: formKey,
//               child: Column(
//                 children: [
//                   //name
//                   CustomTextField(
//                     textEditingController: nameTextEditingController,
//                     iconData: Icons.person,
//                     hintText: "Name",
//                     isObsecre: false,
//                     enabled: true,
//                   ),
//                   jarak_20,
//                   //email
//                   CustomTextField(
//                     textEditingController: emailTextEditingController,
//                     iconData: Icons.email,
//                     hintText: "Email",
//                     isObsecre: false,
//                     enabled: true,
//                   ),
//                   jarak_20,
//                   //password
//                   CustomTextField(
//                     textEditingController: passwordTextEditingController,
//                     iconData: Icons.lock,
//                     hintText: "Password",
//                     isObsecre: true,
//                     enabled: true,
//                   ),
//                   jarak_20,
//                   //confirm password
//                   CustomTextField(
//                     textEditingController: confirmPasswordTextEditingController,
//                     iconData: Icons.lock,
//                     hintText: "Confirm Password",
//                     isObsecre: true,
//                     enabled: true,
//                   ),

//                   const SizedBox(
//                     height: 20,
//                   ),
//                 ],
//               ),
//             ),

//             ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.pinkAccent,
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 50, vertical: 12),
//                 ),
//                 onPressed: () {
//                   //memanggil fungsi formValidation
//                   formValidation();
//                 },
//                 child: const Text(
//                   "Sign Up",
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 )),

//             const SizedBox(
//               height: 30,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

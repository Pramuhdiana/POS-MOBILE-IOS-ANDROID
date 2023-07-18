import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
// ignore: library_prefixes, unused_import
import 'package:firebase_storage/firebase_storage.dart' as fStorage;

import '../global/global.dart';
import '../mainScreens/home_screen.dart';
import '../widgets/progress_bar.dart';

class UploadTokoScreen extends StatefulWidget {
  const UploadTokoScreen({super.key});

  @override
  State<UploadTokoScreen> createState() => _UploadTokoScreenState();
}

class _UploadTokoScreenState extends State<UploadTokoScreen> {
  XFile? imgXFile;
  final ImagePicker imagePicker = ImagePicker();

  TextEditingController tokoNameTextEditingController = TextEditingController();
  TextEditingController tokoAddressTextEditingController =
      TextEditingController();
  TextEditingController tokoNoKontakController = TextEditingController();

  bool uploading = false;
  String downloadUrlImage = "";
  String tokoUniqueId = DateTime.now().millisecondsSinceEpoch.toString();

//menyimpan inputan form ke firebase
  savetokoInfo() {
    FirebaseFirestore.instance
        .collection("users")
        .doc(sharedPreferences!.getString("uid"))
        .collection("toko")
        .doc(tokoUniqueId)
        .set({
      "tokoID": tokoUniqueId,
      "usersUID": sharedPreferences!.getString("uid"),
      "tokoName": tokoNameTextEditingController.text.trim(),
      "tokoNoKontak": tokoNoKontakController.text.trim(),
      "tokoAddress": tokoAddressTextEditingController.text.trim(),
      "publishedDate": DateTime.now(),
      "status": "available",
      "thumbnailUrl": downloadUrlImage,
    });

    setState(() {
      uploading = false;
      tokoUniqueId = DateTime.now().millisecondsSinceEpoch.toString();
    });

    Navigator.push(
        context, MaterialPageRoute(builder: (c) => const HomeScreen()));
  }

//method validasi form input
  validateUploadForm() async {
    if (imgXFile != null) {
      if (tokoNameTextEditingController.text.isNotEmpty &&
          tokoAddressTextEditingController.text.isNotEmpty) {
        setState(() {
          uploading = true;
        });

        //1. upload image to storage - get downloadUrl
        // String fileName = DateTime.now().millisecondsSinceEpoch.toString();

        // fStorage.Reference storageRef = fStorage.FirebaseStorage.instance
        //     .ref()
        //     .child("sellerstokosImages")
        //     .child(fileName);

        // fStorage.UploadTask uploadImageTask =
        //     storageRef.putFile(File(imgXFile!.path));

        // fStorage.TaskSnapshot taskSnapshot =
        //     await uploadImageTask.whenComplete(() {});

        // await taskSnapshot.ref.getDownloadURL().then((urlImage) {
        //   downloadUrlImage = urlImage;
        // });

        //2. save toko info to firestore database
        // savetokoInfo();
      } else {
        Fluttertoast.showToast(msg: "Please write toko name and toko address.");
      }
    } else {
      Fluttertoast.showToast(msg: "Please choose image.");
    }
  }

//tampilan method form upload
  uploadFormScreen() {
    return Scaffold(
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
        actions: [
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: IconButton(
              onPressed: () {
                //validate upload form
                uploading == true ? null : validateUploadForm();
              },
              icon: const Icon(
                Icons.cloud_upload,
                color: Colors.black,
              ),
            ),
          ),
        ],
        title: const Text(
          "Upload New toko",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          uploading == true ? linearProgressBar() : Container(),

          //image
          SizedBox(
            height: 230,
            width: MediaQuery.of(context).size.width * 0.8,
            child: Center(
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: FileImage(
                        File(
                          imgXFile!.path,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          const Divider(
            color: Colors.black,
            thickness: 1,
          ),

          //toko nama
          ListTile(
            leading: const Icon(
              Icons.store,
              color: Colors.black,
            ),
            title: SizedBox(
              width: 250,
              child: TextField(
                controller: tokoNameTextEditingController,
                decoration: const InputDecoration(
                  hintText: "Name Toko",
                  hintStyle: TextStyle(color: Colors.black),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const Divider(
            color: Colors.black,
            thickness: 1,
          ),

          //toko no hp
          ListTile(
            leading: const Icon(
              Icons.contact_phone,
              color: Colors.black,
            ),
            title: SizedBox(
              width: 250,
              child: TextField(
                controller: tokoNoKontakController,
                decoration: const InputDecoration(
                  hintText: "No Kontak",
                  hintStyle: TextStyle(color: Colors.black),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const Divider(
            color: Colors.black,
            thickness: 1,
          ),

          //toko alamat
          ListTile(
            leading: const Icon(
              Icons.location_on_outlined,
              color: Colors.black,
            ),
            title: SizedBox(
              width: 250,
              child: TextField(
                controller: tokoAddressTextEditingController,
                decoration: const InputDecoration(
                  hintText: "Location",
                  hintStyle: TextStyle(color: Colors.black),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const Divider(
            color: Colors.black,
            thickness: 1,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return imgXFile == null ? defaultScreen() : uploadFormScreen();
  }

//template screen awal (default)
  defaultScreen() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
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
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
            colors: [
              Colors.white,
              Colors.white,
            ],
            begin: FractionalOffset(0.0, 0.0),
            end: FractionalOffset(1.0, 0.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp,
          )),
        ),
        automaticallyImplyLeading: false,
        title: const Text(
          "Add New toko",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
          colors: [
            Colors.white,
            Colors.white,
          ],
          begin: FractionalOffset(0.0, 0.0),
          end: FractionalOffset(1.0, 0.0),
          stops: [0.0, 1.0],
          tileMode: TileMode.clamp,
        )),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.add_photo_alternate_outlined,
                color: Colors.black,
                size: 200,
              ),
              ElevatedButton(
                  onPressed: () {
                    obtainImageDialogBox();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    "Add New toko",
                    style: TextStyle(color: Colors.white),
                  )),
            ],
          ),
        ),
      ),
    );
  }

//method pop up dialog setelah button di klik
  obtainImageDialogBox() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            title: const Text('Please choose media to select'),
            content: SizedBox(
              height: MediaQuery.of(context).size.height / 6,
              child: Column(
                children: [
                  ElevatedButton(
                    //if user click this button, user can upload image from gallery
                    onPressed: () {
                      Navigator.pop(context);
                      // getImage(ImageSource.gallery);
                      getImageFromGallery();
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
                      captureImagewithPhoneCamera();
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

//method mengambil gambar di gallery
  getImageFromGallery() async {
    Navigator.pop(context);

    imgXFile = await imagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      imgXFile;
    });
  }

//method membuka camera
  captureImagewithPhoneCamera() async {
    Navigator.pop(context);

    imgXFile = await imagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      imgXFile;
    });
  }
}

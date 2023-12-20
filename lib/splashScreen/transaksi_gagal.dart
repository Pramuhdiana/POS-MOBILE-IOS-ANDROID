// ignore_for_file: prefer_const_constructors, avoid_print, use_build_context_synchronously, unused_element

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

// ignore: must_be_immutable
class TransaksiGagal extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  var err;
  // ignore: prefer_typing_uninitialized_variables
  var title;
  TransaksiGagal({super.key, this.err, this.title});

  @override
  State<TransaksiGagal> createState() => _TransaksiGagalState();
}

class _TransaksiGagalState extends State<TransaksiGagal>
    with TickerProviderStateMixin {
  @override
  void
      initState() //called automatically when user comes here to this splash screen
  {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
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
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                  height: 200, child: Lottie.asset("json/transaksiGagal.json")),
              const SizedBox(
                height: 0,
              ),
              Text(
                '${widget.title}\nScreenshot dan kirim ke Admin',
                style: TextStyle(
                  fontSize: 16,
                  letterSpacing: 0,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                  height: 500,
                  child: SingleChildScrollView(
                      scrollDirection: Axis.vertical, child: Text(widget.err))),
              Container(
                padding: const EdgeInsets.only(top: 40),
                child: Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Kembali',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 26,
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Acne',
                          letterSpacing: 1.5),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

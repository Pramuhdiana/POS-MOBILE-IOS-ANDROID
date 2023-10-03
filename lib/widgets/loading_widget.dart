import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoadingDialogWidget extends StatelessWidget {
  final String? message;

  const LoadingDialogWidget({
    super.key,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      key: key,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          //circulan progress bar
          Center(
              child: Container(
                  padding: const EdgeInsets.all(0),
                  width: 90,
                  height: 90,
                  child: Lottie.asset("json/loading_black.json"))),

          const SizedBox(
            height: 16,
          ),
          Text(
            "$message Please wait...",
          ),
        ],
      ),
    );
  }
}

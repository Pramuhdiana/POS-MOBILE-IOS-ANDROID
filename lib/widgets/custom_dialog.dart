import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

void showCustomDialog({
  required BuildContext context,
  required DialogType dialogType,
  required String title,
  required String description,
}) {
  AwesomeDialog(
          context: context,
          dialogType: dialogType,
          borderSide: const BorderSide(
            color: Colors.green,
            width: 2,
          ),
          width: 280,
          buttonsBorderRadius: const BorderRadius.all(
            Radius.circular(2),
          ),
          dismissOnTouchOutside: true,
          dismissOnBackKeyPress: true,
          headerAnimationLoop: true,
          animType: AnimType.bottomSlide,
          title: title,
          desc: description)
      .show();
}

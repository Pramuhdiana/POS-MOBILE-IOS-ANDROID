import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

void showCustomDialog({
  required BuildContext context,
  required DialogType dialogType,
  required String title,
  required String description,
  bool dismiss = true,
}) {
  AwesomeDialog(
          context: context,
          dialogType: dialogType,
          borderSide: const BorderSide(
            color: Colors.green,
            width: 2,
          ),
          width: 350,
          buttonsBorderRadius: const BorderRadius.all(
            Radius.circular(2),
          ),
          dismissOnTouchOutside: dismiss,
          dismissOnBackKeyPress: dismiss,
          headerAnimationLoop: true,
          animType: AnimType.bottomSlide,
          title: title,
          btnCancelOnPress: () {},
          desc: description)
      .show();
}

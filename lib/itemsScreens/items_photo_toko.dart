// ignore_for_file: must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_shop/api/api_constant.dart';
import 'package:e_shop/database/model_allitems_toko.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ItemsPhotoToko extends StatefulWidget {
  ModelAllitemsToko? model;

  ItemsPhotoToko({
    super.key,
    this.model,
  });
  @override
  State<ItemsPhotoToko> createState() => _ItemsPhotoToko();
}

class _ItemsPhotoToko extends State<ItemsPhotoToko> {
  late PhotoViewScaleStateController scaleStateController;

  @override
  void initState() {
    super.initState();
    scaleStateController = PhotoViewScaleStateController();
  }

  @override
  void dispose() {
    scaleStateController.dispose();
    super.dispose();
  }

  void goBack() {
    scaleStateController.scaleState = PhotoViewScaleState.originalSize;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Center(
          child: Text(
            '${widget.model!.name}',
            style: const TextStyle(color: Colors.black),
          ),
        ),
        backgroundColor: Colors.white,
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
      ),
      body: Container(
        color: Colors.white,
        child: PhotoView(
          backgroundDecoration: const BoxDecoration(
            color: Colors.white,
          ),
          imageProvider: CachedNetworkImageProvider(
            '${ApiConstants.baseImageUrl}${widget.model!.image_name}',
          ),
          enableRotation: true,
          minScale: PhotoViewComputedScale.covered * 0.2,
        ),
      ),
    );
  }
}

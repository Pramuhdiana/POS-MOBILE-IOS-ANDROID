// ignore_for_file: must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_shop/database/model_allitems.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

import 'approval_pricing_model_eticketing.dart';

class ItemsPhotoPricingEticketing extends StatefulWidget {
  PricingEticketingModel? model;
  String? imgUrl;

  ItemsPhotoPricingEticketing({
    super.key,
    this.model,
    this.imgUrl,
    ModelAllitems? models,
  });
  @override
  State<ItemsPhotoPricingEticketing> createState() =>
      _ItemsPhotoPricingEticketing();
}

class _ItemsPhotoPricingEticketing extends State<ItemsPhotoPricingEticketing> {
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
        title: Text(
          '${widget.model!.id}',
          style: const TextStyle(color: Colors.black),
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
            widget.imgUrl!,
          ),
          enableRotation: true,
          minScale: PhotoViewComputedScale.covered * 0.2,
        ),
      ),
    );
  }
}

// ignore_for_file: must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_shop/database/model_allitems_retur.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ItemsPhotoRetur extends StatefulWidget {
  ModelAllitemsRetur? model;

  ItemsPhotoRetur({
    super.key,
    this.model,
  });
  @override
  State<ItemsPhotoRetur> createState() => _ItemsPhotoRetur();
}

class _ItemsPhotoRetur extends State<ItemsPhotoRetur> {
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
        title: Text('${widget.model!.name} / ${widget.model!.description}'),
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
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
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
            'https://parvabisnis.id/uploads/products/${widget.model!.image_name}',
          ),
          enableRotation: true,
          minScale: PhotoViewComputedScale.covered * 0.2,
        ),
      ),
    );
  }
}

// ignore_for_file: must_be_immutable

import 'package:e_shop/cartScreens/cart_screen_retur.dart';
import 'package:e_shop/provider/provider_cart_retur.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:provider/provider.dart';

class AppbarCartRetur extends StatefulWidget implements PreferredSizeWidget {
  PreferredSizeWidget? preferredSizeWidget;
  String? sellerUID;
  String? title = '';

  AppbarCartRetur({
    super.key,
    this.preferredSizeWidget,
    this.sellerUID,
    this.title,
  });

  @override
  State<AppbarCartRetur> createState() => _AppbarCartReturState();

  @override
  Size get preferredSize => preferredSizeWidget == null
      ? Size(56, AppBar().preferredSize.height)
      : Size(56, 80 + AppBar().preferredSize.height);
}

class _AppbarCartReturState extends State<AppbarCartRetur> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios_new,
          color: Colors.white,
        ),
        onPressed: () {
          // Navigator.push(
          //     context, MaterialPageRoute(builder: (c) => PosSalesScreen()));
          Navigator.pop(context);
        },
      ),
      flexibleSpace: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
          colors: [
            Colors.blueAccent,
            Colors.lightBlueAccent,
          ],
          begin: FractionalOffset(0.0, 0.0),
          end: FractionalOffset(1.0, 0.0),
          stops: [0.0, 1.0],
          tileMode: TileMode.clamp,
        )),
      ),
      automaticallyImplyLeading: false,
      title: Text(
        widget.title!.toString(),
        style: const TextStyle(
          fontSize: 20,
          letterSpacing: 3,
        ),
      ),
      centerTitle: true,
      actions: [
        Stack(
          children: [
            IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (c) => const CartScreenRetur()));
              },
              icon: Padding(
                padding: const EdgeInsets.all(2),
                child: badges.Badge(
                  showBadge: context.read<PCartRetur>().getItems.isEmpty
                      ? false
                      : true,
                  badgeStyle: const badges.BadgeStyle(
                    badgeColor: Colors.green,
                  ),
                  badgeContent: Text(
                    context.watch<PCartRetur>().getItems.length.toString(),
                    style: const TextStyle(
                      fontSize: 8,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  child: const Icon(
                    Icons.shopping_cart,
                    color: Colors.white,
                    size: 35,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ignore_for_file: must_be_immutable

import 'package:e_shop/cartScreens/cart_screen_toko.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:provider/provider.dart';
import '../provider/provider_cart_toko.dart';

class AppbarCartToko extends StatefulWidget implements PreferredSizeWidget {
  PreferredSizeWidget? preferredSizeWidget;
  String? sellerUID;
  String? title = '';

  AppbarCartToko({
    super.key,
    this.preferredSizeWidget,
    this.sellerUID,
    this.title,
  });

  @override
  State<AppbarCartToko> createState() => _AppbarCartTokoState();

  @override
  Size get preferredSize => preferredSizeWidget == null
      ? Size(56, AppBar().preferredSize.height)
      : Size(56, 80 + AppBar().preferredSize.height);
}

class _AppbarCartTokoState extends State<AppbarCartToko> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios_new,
          color: Colors.black,
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
      title: Text(
        widget.title!.toString(),
        style: const TextStyle(
          color: Colors.black,
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
                    MaterialPageRoute(builder: (c) => const CartScreenToko()));
              },
              icon: Padding(
                padding: const EdgeInsets.all(2),
                child: badges.Badge(
                  showBadge:
                      context.read<PCartToko>().getItems.isEmpty ? false : true,
                  badgeStyle: const badges.BadgeStyle(
                    badgeColor: Colors.green,
                  ),
                  badgeContent: Text(
                    context.watch<PCartToko>().getItems.length.toString(),
                    style: const TextStyle(
                      fontSize: 8,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  child: const Icon(
                    Icons.shopping_cart,
                    color: Colors.black,
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

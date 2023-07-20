// ignore_for_file: must_be_immutable

import 'package:e_shop/cartScreens/cart_screen_retur.dart';
import 'package:e_shop/global/global.dart';
import 'package:e_shop/provider/provider_cart_retur.dart';
import 'package:e_shop/testing/app_colors.dart';
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
          fontWeight: FontWeight.bold,
          color: Colors.black,
          fontSize: 20,
        ),
      ),
      centerTitle: true,
      actions: sharedPreferences!.getString('customer_id_retur').toString() ==
              0.toString()
          ? null
          : [
              Stack(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (c) => const CartScreenRetur()));
                    },
                    icon: Padding(
                      padding: const EdgeInsets.all(2),
                      child: badges.Badge(
                        showBadge: context.read<PCartRetur>().getItems.isEmpty
                            ? false
                            : true,
                        badgeStyle: const badges.BadgeStyle(
                          badgeColor: AppColors.contentColorGreen,
                        ),
                        badgeContent: Text(
                          context
                              .watch<PCartRetur>()
                              .getItems
                              .length
                              .toString(),
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 8,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        child: Transform.scale(
                          scale: 1.3,
                          child: Image.asset(
                            "assets/cart.png",
                            width: 45,
                            height: 45,
                          ),
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

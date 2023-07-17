import 'package:e_shop/cartScreens/cart_screen.dart';
import 'package:e_shop/provider/provider_cart.dart';
import 'package:e_shop/testing/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart' as badges;

// ignore: must_be_immutable
class AppBarWithCartBadgeSales extends StatefulWidget
    implements PreferredSizeWidget {
  PreferredSizeWidget? preferredSizeWidget;
  String? sellerUID;
  String? title = 'POS Mobile';

  AppBarWithCartBadgeSales(
      {super.key, this.preferredSizeWidget, this.sellerUID, this.title});

  @override
  State<AppBarWithCartBadgeSales> createState() =>
      _AppBarWithCartBadgeSalesState();

  @override
  Size get preferredSize => preferredSizeWidget == null
      ? Size(56, AppBar().preferredSize.height)
      : Size(56, 80 + AppBar().preferredSize.height);
}

class _AppBarWithCartBadgeSalesState extends State<AppBarWithCartBadgeSales> {
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
                    MaterialPageRoute(builder: (c) => const CartScreen()));
              },
              icon: Padding(
                padding: const EdgeInsets.all(3),
                child: badges.Badge(
                  showBadge:
                      context.read<PCart>().getItems.isEmpty ? false : true,
                  badgeStyle: const badges.BadgeStyle(
                    badgeColor: AppColors.contentColorBlack,
                  ),
                  badgeContent: Text(
                    context.watch<PCart>().getItems.length.toString(),
                    style: const TextStyle(
                      color: Colors.white,
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

import 'package:e_shop/cartScreens/cart_screen.dart';
import 'package:e_shop/provider/provider_cart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart' as badges;

// ignore: must_be_immutable
class AppBarWithCartBadgeSales extends StatefulWidget with PreferredSizeWidget {
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
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (c) => const CartScreen(
                            /*
                              pindah halaman + mengirim data ID
                              di halaman yang di tuju harus ada variabel yang menangkapnya
                              contoh >>>  String? namavariable
                              nama class ({this.nama variable,});
                              */
                            //  sellerUID: widget.sellerUID,
                            )));
                // }
              },
              icon: Padding(
                padding: const EdgeInsets.all(2),
                child: badges.Badge(
                  showBadge:
                      context.read<PCart>().getItems.isEmpty ? false : true,
                  badgeStyle: const badges.BadgeStyle(
                    badgeColor: Colors.green,
                  ),
                  badgeContent: Text(
                    context.watch<PCart>().getItems.length.toString(),
                    style: const TextStyle(
                      fontSize: 8,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  child: const Icon(
                    Icons.shopping_cart,
                    color: Colors.white,
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

// // ignore_for_file: avoid_renaming_method_parameters

// import 'package:flutter/material.dart';

// class TextDelegateHeaderWidget extends SliverPersistentHeaderDelegate {
//   String? title;
//   TextDelegateHeaderWidget({
//     this.title,
//   });

//   @override
//   Widget build(
//     BuildContext context,
//     double shrinkOffSet,
//     bool overlapsContent,
//   ) {
//     return InkWell(
//       child: Container(
//         decoration: const BoxDecoration(
//             gradient: LinearGradient(
//           colors: [
//             Colors.blueAccent,
//             Colors.lightBlueAccent,
//           ],
//           begin: FractionalOffset(0.0, 0.0),
//           end: FractionalOffset(1.0, 0.0),
//           stops: [0.0, 1.0],
//           tileMode: TileMode.clamp,
//         )),
//         height: 82,
//         width: MediaQuery.of(context).size.width,
//         alignment: Alignment.center,
//         child: InkWell(
//           child: Text(
//             title.toString(),
//             maxLines: 2,
//             textAlign: TextAlign.center,
//             style: const TextStyle(
//               fontSize: 22,
//               letterSpacing: 3,
//               color: Colors.white,
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   double get maxExtent => 50;

//   @override
//   double get minExtent => 50;

//   @override
//   bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
//       true;
// }

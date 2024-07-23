// import 'package:flutter/material.dart';
//
// import '../../constants.dart';
//
// class CommonProductFormat extends StatefulWidget {
//   final String title;
//   final String price;
//   const CommonProductFormat({
//     Key? key,
//     this.width = 140,
//     this.aspectRetio = 1.02,
//     required this.title, required this.price, required this.onPress,
//   }) : super(key: key);
//
//   final double width, aspectRetio;
//   final VoidCallback onPress;
//
//   @override
//   State<CommonProductFormat> createState() => _CommonProductFormatState();
// }
//
// class _CommonProductFormatState extends State<CommonProductFormat> {
//   @override
//   Widget build(BuildContext context) {
//     return
//       SizedBox(
//       width: widget.width,
//       child: GestureDetector(
//         onTap: widget.onPress,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             AspectRatio(
//               aspectRatio: 1.02,
//               child: Container(
//                 padding: const EdgeInsets.all(20),
//                 decoration: BoxDecoration(
//                   color: kSecondaryColor.withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Image.asset(""),
//               ),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               title,
//               style: Theme.of(context).textTheme.bodyMedium,
//               maxLines: 2,
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   "\$${price}",
//                   style: const TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.w600,
//                     color: kPrimaryColor,
//                   ),
//                 ),
//                 // InkWell(
//                 //   borderRadius: BorderRadius.circular(50),
//                 //   onTap: () {},
//                 //   child: Container(
//                 //     padding: const EdgeInsets.all(6),
//                 //     height: 24,
//                 //     width: 24,
//                 //     decoration: BoxDecoration(
//                 //       color: product.isFavourite
//                 //           ? kPrimaryColor.withOpacity(0.15)
//                 //           : kSecondaryColor.withOpacity(0.1),
//                 //       shape: BoxShape.circle,
//                 //     ),
//                 //     child: SvgPicture.asset(
//                 //       "assets/icons/Heart Icon_2.svg",
//                 //       colorFilter: ColorFilter.mode(
//                 //           product.isFavourite
//                 //               ? const Color(0xFFFF4848)
//                 //               : const Color(0xFFDBDEE4),
//                 //           BlendMode.srcIn),
//                 //     ),
//                 //   ),
//                 // ),
//               ],
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

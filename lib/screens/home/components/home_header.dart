import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shop_app/screens/notification_screen.dart';

import '../../cart/cart_screen.dart';
import 'icon_btn_with_counter.dart';
import 'search_field.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Image.asset("assets/images/food_logo.png",height: 50,width: 111,,),

              const Expanded(child: SearchField()),
              // const SizedBox(width: 16),
              // IconBtnWithCounter(
              //   svgSrc: "assets/icons/Cart Icon.svg",
              //   press: () => Navigator.pushNamed(context, CartScreen.routeName),
              // ),
              const SizedBox(width: 8),
              IconBtnWithCounter(
                svgSrc: "assets/icons/Bell.svg",
                numOfitem: 3,
                press: () {
                  Get.to(()=>const NotificationScreen());
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

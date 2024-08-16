import 'package:badges/badges.dart';
import 'package:flutter/material.dart'hide Badge;
import 'package:get/get.dart';
import 'package:shop_app/helper/apptheme_color.dart';
import '../../../controllers/cart_controller.dart';
import 'search_field.dart';

class HomeHeader extends StatefulWidget {
  const HomeHeader({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeHeader> createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader> {
  final cartController = Get.put(CartController());
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Image.asset("assets/images/food_logo.png",height: 50,width: 111,,),

              SearchField(),
              Badge(
                badgeStyle: BadgeStyle(badgeColor: AppThemeColor.buttonColor,),
                badgeContent:     Obx((){
                  return Text(cartController.cartCount.value,style: TextStyle(color: Colors.white),);}),
                child: Container(
                    height: 24,
                    width: 24,
                    child:
                    Icon(Icons.shopping_bag_outlined,color: Colors.grey,size: 30,)
                ),
              )
              // IconBtnWithCounter(
              //   svgSrc: "assets/icons/Bell.svg",
              //   numOfitem: 3,
              //   press: () {
              //     Get.to(()=>const NotificationScreen());
              //   },
              // ),
            ],
          ),
        ),
      ],
    );
  }
}

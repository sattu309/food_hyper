import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/helper/common_button.dart';
import 'package:shop_app/screens/cart/thankyou_page.dart';
import 'package:shop_app/screens/login_flow/login_page.dart';

import '../../helper/apptheme_color.dart';
import '../../helper/heigh_width.dart';
import '../address/all_address.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const
        Text("Checkout",
          style:
          TextStyle(fontSize: 15,fontWeight: FontWeight.w600,
              color: Color(0xff222222)),),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Shipping address",
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: Color(0xff222222)),
            ),
            addHeight(15),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                  boxShadow: const [
                    BoxShadow(
                    //  color:  Colors.white,
                      offset: Offset(.1, .1,
                      ),
                      blurRadius: 0,
                     // spreadRadius: 2.0,
                    ),
                  ],

              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                     Padding(
                      padding: EdgeInsets.only(right: 8.0),
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Tyler Joen",
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          GestureDetector(
                            onTap: (){
                            Get.to(()=>const AllAddressPage());
                            },
                            child:  Text(
                              "Change",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13,
                                  color: AppThemeColor.buttonColor),
                            ),
                          ),
                        ],
                      ),
                    ),
                    addHeight(2),
                    Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       Text(
                         "65 NewBridge white town",
                         style: Theme.of(context).textTheme.bodySmall,
                       ),
                       Text(
                         "Chino hilss 455 ca los angles",
                         style: Theme.of(context).textTheme.bodySmall,
                       ),
                     ],
                   )
                  ],
                ),
              ),
            ),
            addHeight(10),
             Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Payment",
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: Color(0xff222222)),
                ),
                Text(
                  "Change",
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                      color: AppThemeColor.buttonColor),
                ),
              ],
            ),
            addHeight(20),
             Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
               Container(
                 height: 40,
                 width: 60,
                 decoration: BoxDecoration(
                   borderRadius: BorderRadius.circular(10),
                   color: Colors.white
                 ),
                 child: Image.asset("assets/images/master.png"),
               ),
                addWidth(20),
                Text(
                  "*** *** 8787",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15,horizontal: 15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Order:",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                 Text(
                  "R76",
                  style:Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
            addHeight(10),
            Row(
              mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Delivery:",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                 Text(
                  "R76",
                  style:Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
            addHeight(10),
            Row(
              mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
              children: [
                Text(
                      "Summary:",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                 Text(
                  "R76",
                  style:Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
            addHeight(30),
            CommonButtonGreen(title: "Placed Order",onPressed: () async {
                    Get.to(()=>ThankYouScreen());
            },)
          ],
        ),
      ),
    );
  }
}

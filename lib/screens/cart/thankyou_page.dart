import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/route_manager.dart';
import 'package:shop_app/helper/apptheme_color.dart';
import 'package:shop_app/screens/new_common_tab.dart';
import '../../helper/dimentions.dart';
  class ThankYouScreen extends StatefulWidget {
  const ThankYouScreen({Key? key,}) : super(key: key);

  @override
  State<ThankYouScreen> createState() => _ThankYouScreenState();
}

class _ThankYouScreenState extends State<ThankYouScreen> {

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: AddSize.padding16, vertical: AddSize.padding16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: height * .08,
                ),
                Image(
                  height: height * .25,
                  width: width,
                  image:  AssetImage("assets/images/thankyou.png"),
                  color: AppThemeColor.buttonColor,
                ),
                SizedBox(
                  height: height * .04,
                ),
                Text(
                  "Thank You!",
                  style: Theme.of(context).textTheme.headline5!.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: AddSize.font24,
                      color: AppThemeColor.buttonColor),
                ),
                SizedBox(
                  height: height * .005,
                ),
                Text(
                  "your order has been successful",
                  style: Theme.of(context).textTheme.headline5!.copyWith(
                      fontWeight: FontWeight.w300,
                      fontSize: AddSize.font16,
                      color: AppThemeColor.buttonColor),
                ),
                SizedBox(
                  height: height * .04,
                ),
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  elevation: 0,
                  color: Colors.grey.shade100,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AddSize.padding20,
                    ),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Order ID:",
                                    style: TextStyle(
                                        color: AppThemeColor.buttonColor,
                                        fontSize: AddSize.font16,
                                        fontWeight: FontWeight.w500)),
                                Text(
                                  "#76",
                                  style: TextStyle(
                                      color: Colors.grey.shade500,
                                      fontSize: AddSize.font14,
                                      fontWeight: FontWeight.w500),
                                ),
                              ]),
                          SizedBox(
                            height: height * .01,
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Date:",
                                    style: TextStyle(
                                        color: AppThemeColor.buttonColor,
                                        fontSize: AddSize.font16,
                                        fontWeight: FontWeight.w500)),
                                Text(
                                    "19/07/2024",
                                    style: TextStyle(
                                        color: Colors.grey.shade500,
                                        fontSize: AddSize.font14,
                                        fontWeight: FontWeight.w500)),
                              ]),
                          SizedBox(
                            height: height * .01,
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Subtotal:",
                                    style: TextStyle(
                                        color: AppThemeColor.buttonColor,
                                        fontSize: AddSize.font16,
                                        fontWeight: FontWeight.w500)),
                                Text(
                                   "R8943",
                                    style: TextStyle(
                                        color: Colors.grey.shade500,
                                        fontSize: AddSize.font14,
                                        fontWeight: FontWeight.w500)),
                              ]),

                          SizedBox(
                            height: height * .01,
                          ),

                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Delivery charges:",
                                    style: TextStyle(
                                        color: AppThemeColor.buttonColor,
                                        fontSize: AddSize.font16,
                                        fontWeight: FontWeight.w500)),
                                Text(
                                    "R974",
                                    style: TextStyle(
                                        color: Colors.grey.shade500,
                                        fontSize: AddSize.font14,
                                        fontWeight: FontWeight.w500)),
                              ]),
                          SizedBox(
                            height: height * .01,
                          ),
                          SizedBox(
                            height: height * .01,
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Total:",
                                    style: TextStyle(
                                        color: AppThemeColor.buttonColor,
                                        fontSize: AddSize.font16,
                                        fontWeight: FontWeight.w500)),
                                Text(
                                    "R9487",
                                    style: TextStyle(
                                        color: Colors.grey.shade500,
                                        fontSize: AddSize.font14,
                                        fontWeight: FontWeight.w500)),
                              ]),
                        ]),
                  ),
                ),
              ],
            ),
          )),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            ElevatedButton(
                onPressed: () {
                  Get.offAll(MinimalExample());
                },
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.maxFinite, 60),
                    backgroundColor: AppThemeColor.buttonColor,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AddSize.size10)),
                    textStyle: TextStyle(
                        fontSize: AddSize.font20, fontWeight: FontWeight.w600)),
                child: Text(
                  "BACK TO HOME",
                  style: Theme.of(context).textTheme.headline5!.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: AddSize.font16),
                )),
          ],
        ),
      ),
    );
  }
}

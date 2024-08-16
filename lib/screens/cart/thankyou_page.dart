import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:shop_app/helper/apptheme_color.dart';
import 'package:shop_app/screens/new_common_tab.dart';
import '../../helper/dimentions.dart';
  class ThankYouScreen extends StatefulWidget {
    final String orderId;
    final String orderDate;
    final String orderSubtotal;
    final String orderTotal;
    final String orderType;

  const ThankYouScreen({Key? key, required this.orderId, required this.orderDate, required this.orderSubtotal, required this.orderTotal, required this.orderType,}) : super(key: key);

  @override
  State<ThankYouScreen> createState() => _ThankYouScreenState();
}

class _ThankYouScreenState extends State<ThankYouScreen> {

  final fetchMyOrders = """
 query Orders {
    orders{
        edges {
            node {
                id
                status
                paymentMethod
                databaseId
                date
                orderNumber
                total
                subtotal
                lineItems {
                    edges {
                        node {
                            id
                            orderId
                            productId
                            quantity
                            subtotal
                            total
                            product {
                                node {
                                    productId
                                    name
                                    featuredImage {
                                        node {
                                            sourceUrl
                                        }
                                    }
                                    ... on VariableProduct {
                                        databaseId
                                        name
                                        price
                                        type
                                        salePrice
                                        regularPrice
                                    }
                                    ... on SimpleProduct {
                                        databaseId
                                        name
                                        price
                                        type
                                        regularPrice
                                        salePrice
                                    }
                                }
                            }
                            variation {
                                node {
                                    databaseId
                                    name
                                    price
                                    regularPrice
                                    salePrice
                                    attributes {
                                        edges {
                                            node {
                                                value
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                billing {
                    address1
                    address2
                    city
                    company
                    country
                    email
                    firstName
                    lastName
                    phone
                    postcode
                    state
                }
            }
        }
    }
}

""";
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      body:
      SingleChildScrollView(
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
                  image:  const AssetImage("assets/images/thankyou.png"),
                  color: AppThemeColor.buttonColor,
                ),
                SizedBox(
                  height: height * .04,
                ),
                const Text(
                  "Thank You!",
                ),
                SizedBox(
                  height: height * .005,
                ),
                const Text(
                  "Your order has been successfully placed",
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
                      vertical: 20
                    ),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("PaymentType:",
                                    style: TextStyle(
                                        color: AppThemeColor.buttonColor,
                                        fontSize: AddSize.font16,
                                        fontWeight: FontWeight.w500)),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 5,vertical:3),
                                  decoration: BoxDecoration(
                                    color: AppThemeColor.buttonColor,
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                  child: Text(
                                    widget.orderType.toUpperCase(),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: AddSize.font14,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ]),
                          SizedBox(
                            height: height * .01,
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Order ID:",
                                    style: TextStyle(
                                        color: AppThemeColor.buttonColor,
                                        fontSize: AddSize.font16,
                                        fontWeight: FontWeight.w500)),
                                Text(
                                  widget.orderId,
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
                                    widget.orderDate,
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
                                   widget.orderSubtotal,
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
                                    widget.orderTotal,
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
                  Get.offAll(()=>MinimalExample());
                },
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.maxFinite, 60),
                    backgroundColor: AppThemeColor.buttonColor,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AddSize.size10)),
                    textStyle: TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w600)),
                child: Text(
                  "BACK TO HOME",
                )),
          ],
        ),
      ),
    );
  }
}

import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart';
import 'package:shop_app/helper/heigh_width.dart';
import '../../helper/apptheme_color.dart';
import '../../helper/dimentions.dart';
import 'order_details.dart';

class MyOrdersOfMart extends StatefulWidget {
  const MyOrdersOfMart({Key? key}) : super(key: key);
  static var referAndEarnScreen = "/referAndEarnScreen";

  @override
  State<MyOrdersOfMart> createState() => _MyOrdersOfMartState();
}

class _MyOrdersOfMartState extends State<MyOrdersOfMart> {
  final key = GlobalKey<ScaffoldState>();
  var currentDrawer = 0;
  String? selectedTime;
  String dropdownvalue = 'Today';
  var items = [
    'Today',
    'This Week',
    'This Month',
    'Last Year',
  ];

  @override
  void initState() {
    super.initState();
  }

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
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          backgroundColor: Colors.white,
            appBar:AppBar(
              backgroundColor: Colors.white,
              leadingWidth: 20,
              title: Text(
                "My Orders",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: const Color(0xFFEEEEEE))),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                        isDense: true,
                        hint: Icon(Icons.filter_alt_off),
                        isExpanded: false,
                        style: const TextStyle(
                          color: Color(0xFF697164),
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                        value: selectedTime,
                        icon: const Icon(
                          Icons.keyboard_arrow_down,
                          color: Color(0xFF000000),
                        ),
                        items: items.map((value) {
                          return DropdownMenuItem(
                            value: value.toString(),
                            child: Text(
                              value.toString(),
                              style: TextStyle(
                                fontSize: AddSize.font14,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            selectedTime = newValue as String?;
                            log(selectedTime.toString());
                          });
                        },
                      ),
                    ),
                  ),
                )
              ],
              bottom: TabBar(
                padding: EdgeInsets.all(5),
                dividerColor: Colors.white,
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorColor: AppThemeColor.buttonColor,
                indicatorPadding: const EdgeInsets.symmetric(horizontal: 15),
                labelColor: AppThemeColor.buttonColor,
                unselectedLabelColor: Color(0xff1A2E33),
                onTap: (value) {
                  setState(() {
                    currentDrawer = value;  // Update the currentDrawer based on the selected tab
                  });
                },
                tabs: [
                  Tab(
                    child: Text(
                      "Active",
                      style: currentDrawer == 0
                          ? TextStyle(
                          color: AppThemeColor.buttonColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w600)
                          : const TextStyle(
                          color: Color(0xff1A2E33),
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  Tab(
                    child: Text(
                      "Completed",
                      style: currentDrawer == 1
                          ? TextStyle(
                          color: AppThemeColor.buttonColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w600)
                          : const TextStyle(
                          color: Color(0xff1A2E33),
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  Tab(
                    child: Text(
                      "Cancelled",
                      style: currentDrawer == 2
                          ? TextStyle(
                          color: AppThemeColor.buttonColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w600)
                          : const TextStyle(
                          color: Color(0xff1A2E33),
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
            body: Query(
            options: QueryOptions(document: gql(fetchMyOrders)),
              builder: (QueryResult result,
              {Refetch? refetch, FetchMore? fetchMore}) {
                if (result.hasException) {
                  return Text(result.exception.toString());
                }
                if (result.isLoading) {
                  return Center(
                      child: CircularProgressIndicator(
                        color: AppThemeColor.buttonColor,
                      ));
                }
                final myOrderData = result.data?['orders']['edges'];
                // log("MY ORDERS ${myOrderData}");
              return
                  TabBarView(
                    children: [
                      ListView.builder(
                          padding: const EdgeInsets.only(bottom: 50),
                          shrinkWrap: true,
                          itemCount: myOrderData.length,
                          itemBuilder: (BuildContext, index) {
                            final Map<String,dynamic>paymentData = myOrderData[index]['node'];
                            final Map<String,dynamic>orderData = myOrderData[index]['node']['lineItems'];
                            final List<dynamic> lineItems = orderData['edges'];
                            log("SUBTOTAL ${lineItems[0]['node']['subtotal']}}");

                            final productData = lineItems[0]['node']['product']['node'];
                            final img = productData['featuredImage']['node']['sourceUrl'];
                            String formattedDate =
                            DateFormat('MM/dd/yy').format(
                                DateTime.parse(paymentData['date']));
                            log(productData.toString());
                            return
                              GestureDetector(
                                onTap: () {
                                  log(lineItems[0]['subTotal'].toString());
                                  Get.to(() =>  OrderDetailsOfMart(
                                      orderId: paymentData['databaseId'].toString(),
                                      date: formattedDate.toString(),
                                    status: paymentData['status'],
                                    payMentType: paymentData['paymentMethod'],
                                    subTotal: paymentData['subtotal'],
                                    total:paymentData['total'] ,
                                  ));
                                },
                                child: Container(
                                    margin: EdgeInsets.symmetric(vertical: 3,
                                        horizontal: 10),
                                    padding: EdgeInsets.symmetric(vertical: 10,
                                        horizontal: 8),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.white,
                                      border: Border.all(color: Colors.grey.shade100)
                                      // boxShadow: [
                                      //   BoxShadow(
                                      //       color: Colors.white,
                                      //       offset: Offset(2, 2,),
                                      //       blurRadius: 5,
                                      //       spreadRadius: 3
                                      //
                                      //     // spreadRadius: 2.0,
                                      //   ),
                                      // ],

                                    ),
                                    child:
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15, vertical: 10),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(right: 8.0),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment
                                                        .start,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Expanded(
                                                            child: Text(
                                                              "ORDER ID",
                                                              style: TextStyle(fontSize:10,fontWeight: FontWeight.w400,color: Color(0xff9B9B9B)),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: Text(
                                                              "DATE",
                                                              style: TextStyle(fontSize:10,fontWeight: FontWeight.w400,color:Color(0xff9B9B9B)),
                                                            ),
                                                          ),
                                                          Text(
                                                            "",
                                                            style: TextStyle(fontSize:10,fontWeight: FontWeight.w400,color:Color(0xff9B9B9B)),
                                                          ),

                                                        ],
                                                      ),
                                                      // addHeight(4),
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Expanded(
                                                            child: Text(
                                                              "#${paymentData['orderNumber']}",
                                                                style: TextStyle(fontSize:13,fontWeight:FontWeight.w500,color: Color(0xff1A2E33),)
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: Text(
                                                              formattedDate.toString(),
                                                              style: TextStyle(fontSize:13,fontWeight:FontWeight.w500,color: Color(0xff1A2E33),)
                                                            ),
                                                          ),
                                                          Container(
                                                            padding: EdgeInsets.symmetric(horizontal: 4,vertical: 2),
                                                            // margin: EdgeInsets.symmetric(horizontal: 4,vertical: 2),
                                                            decoration: BoxDecoration(
                                                              color: AppThemeColor.buttonColor,
                                                                borderRadius: BorderRadius.circular(2),
                                                                border: Border.all(color: AppThemeColor.buttonColor)
                                                            ),
                                                            child: Text(
                                                                "${paymentData['status']}",
                                                                style: TextStyle(fontSize:10,fontWeight:FontWeight.w500,color: Colors.white)
                                                            ),
                                                          ),

                                                        ],
                                                      ),

                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Divider(),
                                          Row(
                                            children: [
                                              Icon(Icons.remove_red_eye_rounded,color: AppThemeColor.buttonColor,),
                                              addWidth(20),
                                              Icon(Icons.track_changes,color: AppThemeColor.buttonColor),
                                              addWidth(20),
                                              Icon(Icons.download,color: AppThemeColor.buttonColor),
                                              addWidth(20),
                                              Icon(Icons.email_outlined,color: AppThemeColor.buttonColor),
                                            ],
                                          )


                                        ],
                                      ),
                                    )),
                              );
                          }),
                      ListView.builder(
                          shrinkWrap: true,
                          itemCount: 2,
                          itemBuilder: (BuildContext, index) {
                            return
                              Container(
                                  margin: EdgeInsets.symmetric(
                                      vertical: 0, horizontal: 10),
                                  // padding: EdgeInsets.symmetric(
                                  //     vertical: 15, horizontal: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white,
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.white,
                                        offset: Offset(.1, .0,
                                        ),
                                        blurRadius: 0,

                                        // spreadRadius: 2.0,
                                      ),
                                    ],

                                  ),
                                  child:
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 15,
                                        vertical: 10),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(right: 8.0),
                                          child: Row(
                                            //crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Image.asset(
                                                "assets/images/ps4_console_white_1.png",
                                                height: 50, width: 75,),
                                              addWidth(15),

                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment
                                                    .start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment
                                                        .spaceBetween,
                                                    children: [
                                                      Text(
                                                        "OrderID #5948",
                                                        style: Theme
                                                            .of(context)
                                                            .textTheme
                                                            .bodyMedium,
                                                      ),

                                                    ],
                                                  ),
                                                  Text(
                                                    "Quantity: 3",
                                                    style: Theme
                                                        .of(context)
                                                        .textTheme
                                                        .bodySmall,
                                                  ),
                                                  addHeight(2),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment
                                                        .spaceBetween,
                                                    children: [
                                                      Text(
                                                        "Amount \$758",
                                                        style: Theme
                                                            .of(context)
                                                            .textTheme
                                                            .bodySmall,
                                                      ),
                                                      addWidth(30),
                                                      Container(
                                                        padding: const EdgeInsets
                                                            .symmetric(
                                                            vertical: 3, horizontal: 8),
                                                        decoration: BoxDecoration(
                                                            borderRadius: BorderRadius
                                                                .circular(6),
                                                            color: AppThemeColor
                                                                .buttonColor

                                                        ),
                                                        child: const Text("COMPLETED",
                                                            style: TextStyle(
                                                                fontSize: 13,
                                                                fontWeight: FontWeight
                                                                    .w400,
                                                                color: Colors.white)),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        addHeight(3),


                                      ],
                                    ),
                                  ));
                          }),
                      ListView.builder(
                          shrinkWrap: true,
                          itemCount: 2,
                          itemBuilder: (BuildContext, index) {
                            return
                              Container(
                                  margin: EdgeInsets.symmetric(
                                      vertical: 7, horizontal: 10),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 15, horizontal: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white,
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.white,
                                        offset: Offset(.1, .0,
                                        ),
                                        blurRadius: 0,

                                        // spreadRadius: 2.0,
                                      ),
                                    ],

                                  ),
                                  child:
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 15,
                                        vertical: 10),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(right: 8.0),
                                          child: Row(
                                            //crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Image.asset(
                                                "assets/images/ps4_console_white_1.png",
                                                height: 50, width: 75,),
                                              addWidth(15),

                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment
                                                    .start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment
                                                        .spaceBetween,
                                                    children: [
                                                      Text(
                                                        "OrderID #5948",
                                                        style: Theme
                                                            .of(context)
                                                            .textTheme
                                                            .bodyMedium,
                                                      ),

                                                    ],
                                                  ),
                                                  Text(
                                                    "Quantity: 3",
                                                    style: Theme
                                                        .of(context)
                                                        .textTheme
                                                        .bodySmall,
                                                  ),
                                                  addHeight(2),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment
                                                        .spaceBetween,
                                                    children: [
                                                      Text(
                                                        "Amount \$758",
                                                        style: Theme
                                                            .of(context)
                                                            .textTheme
                                                            .bodySmall,
                                                      ),
                                                      addWidth(30),
                                                      Container(
                                                        padding: const EdgeInsets
                                                            .symmetric(
                                                            vertical: 3, horizontal: 8),
                                                        decoration: BoxDecoration(
                                                            borderRadius: BorderRadius
                                                                .circular(6),
                                                            color: AppThemeColor
                                                                .buttonColor

                                                        ),
                                                        child: const Text("CANCELLED",
                                                            style: TextStyle(
                                                                fontSize: 13,
                                                                fontWeight: FontWeight
                                                                    .w400,
                                                                color: Colors.white)),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        addHeight(3),


                                      ],
                                    ),
                                  ));
                          }),
                    ]);
    }
            )));
  }
}

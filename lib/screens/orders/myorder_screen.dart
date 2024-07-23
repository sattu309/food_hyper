import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
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

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var width = MediaQuery.of(context).size.width;
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          backgroundColor: Colors.grey.shade50,
            appBar: AppBar(
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.white,
              leadingWidth: 20,
              elevation: 1,
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
                    // height: 15,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: const Color(0xFFEEEEEE))),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                        isDense: true,
                        hint: Text(
                          'Choose option'
                          '',
                          style: TextStyle(
                              color: AppThemeColor.userText,
                              fontSize: AddSize.font14,
                              fontWeight: FontWeight.w500),
                          textAlign: TextAlign.start,
                        ),
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
                dividerColor: Colors.white,
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorColor: AppThemeColor.buttonColor,
                indicatorPadding: const EdgeInsets.symmetric(horizontal: 15),
                // automaticIndicatorColorAdjustment: true,
                onTap: (value) {
                  currentDrawer = 0;
                  setState(() {});
                },
                tabs: [
                  Tab(
                    child: Text(
                      "Active",
                      style: currentDrawer == 0
                          ? const TextStyle(
                              color: Color(0xff1A2E33),
                              fontSize: 14,
                              fontWeight: FontWeight.w500)
                          : TextStyle(
                              color: AppThemeColor.primaryColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w500),
                    ),
                  ),
                  Tab(
                    child: Text(
                      "Completed",
                      style: currentDrawer == 1
                          ? TextStyle(
                              color: Colors.cyan,
                              fontSize: 14,
                              fontWeight: FontWeight.w500)
                          : TextStyle(
                              color: Color(0xff1A2E33),
                              fontSize: 14,
                              fontWeight: FontWeight.w500),
                    ),
                  ),
                  Tab(
                    child: Text(
                      "Cancelled",
                      style: currentDrawer == 1
                          ? TextStyle(
                              color: Colors.cyan,
                              fontSize: 14,
                              fontWeight: FontWeight.w500)
                          : TextStyle(
                              color: Color(0xff1A2E33),
                              fontSize: 14,
                              fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
            body: TabBarView(
                children: [
              ListView.builder(
                  shrinkWrap: true,
                  itemCount: 2,
                  itemBuilder: (BuildContext, index) {
                    return
                      GestureDetector(
                        onTap: (){
                          Get.to(()=>const OrderDetailsOfMart());
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 7,horizontal: 10),
                          padding: EdgeInsets.symmetric(vertical: 15,horizontal: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                            boxShadow: const [
                              BoxShadow(
                                 color:  Colors.white,
                                offset: Offset(.1, .0,
                                ),
                               blurRadius: 0,

                                // spreadRadius: 2.0,
                              ),
                            ],

                          ),
                          child:
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(right: 8.0),
                                  child: Row(
                                    //crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Image.asset("assets/images/ps4_console_white_1.png",
                                        height: 50,width: 75,),
                                      addWidth(15),

                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "OrderID #5948",
                                                style: Theme.of(context).textTheme.bodyMedium,
                                              ),

                                            ],
                                          ),
                                          Text(
                                            "Quantity: 3",
                                            style: Theme.of(context).textTheme.bodySmall,
                                          ),
                                          addHeight(2),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Amount \$758",
                                                style: Theme.of(context).textTheme.bodySmall,
                                              ),
                                              addWidth(30),
                                              Container(
                                                padding: const EdgeInsets.symmetric(vertical: 3,horizontal: 8),
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(6),
                                                    color: AppThemeColor.buttonColor

                                                ),
                                                child: const Text("PENDING",style :TextStyle(fontSize: 13,fontWeight: FontWeight.w400,color: Colors.white)),
                                              ),
                                            ],
                                          ),
                                          addHeight(10),

                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                addHeight(3),


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
                        margin: EdgeInsets.symmetric(vertical: 7,horizontal: 10),
                        padding: EdgeInsets.symmetric(vertical: 15,horizontal: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          boxShadow: const [
                            BoxShadow(
                               color:  Colors.white,
                              offset: Offset(.1, .0,
                              ),
                             blurRadius: 0,

                              // spreadRadius: 2.0,
                            ),
                          ],

                        ),
                        child:
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(right: 8.0),
                                child: Row(
                                  //crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Image.asset("assets/images/ps4_console_white_1.png",
                                      height: 50,width: 75,),
                                    addWidth(15),

                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "OrderID #5948",
                                              style: Theme.of(context).textTheme.bodyMedium,
                                            ),

                                          ],
                                        ),
                                        Text(
                                          "Quantity: 3",
                                          style: Theme.of(context).textTheme.bodySmall,
                                        ),
                                        addHeight(2),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Amount \$758",
                                              style: Theme.of(context).textTheme.bodySmall,
                                            ),
                                            addWidth(30),
                                            Container(
                                              padding: const EdgeInsets.symmetric(vertical: 3,horizontal: 8),
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(6),
                                                  color: AppThemeColor.buttonColor

                                              ),
                                              child: const Text("COMPLETED",style :TextStyle(fontSize: 13,fontWeight: FontWeight.w400,color: Colors.white)),
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
                        margin: EdgeInsets.symmetric(vertical: 7,horizontal: 10),
                        padding: EdgeInsets.symmetric(vertical: 15,horizontal: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          boxShadow: const [
                            BoxShadow(
                               color:  Colors.white,
                              offset: Offset(.1, .0,
                              ),
                             blurRadius: 0,

                              // spreadRadius: 2.0,
                            ),
                          ],

                        ),
                        child:
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(right: 8.0),
                                child: Row(
                                  //crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Image.asset("assets/images/ps4_console_white_1.png",
                                      height: 50,width: 75,),
                                    addWidth(15),

                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "OrderID #5948",
                                              style: Theme.of(context).textTheme.bodyMedium,
                                            ),

                                          ],
                                        ),
                                        Text(
                                          "Quantity: 3",
                                          style: Theme.of(context).textTheme.bodySmall,
                                        ),
                                        addHeight(2),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Amount \$758",
                                              style: Theme.of(context).textTheme.bodySmall,
                                            ),
                                            addWidth(30),
                                            Container(
                                              padding: const EdgeInsets.symmetric(vertical: 3,horizontal: 8),
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(6),
                                                  color: AppThemeColor.buttonColor

                                              ),
                                              child: const Text("CANCELLED",style :TextStyle(fontSize: 13,fontWeight: FontWeight.w400,color: Colors.white)),
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
            ])));
  }
}

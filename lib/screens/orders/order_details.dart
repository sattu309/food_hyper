import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shop_app/helper/apptheme_color.dart';
import '../../helper/dimentions.dart';
import '../../helper/heigh_width.dart';

class OrderDetailsOfMart extends StatefulWidget {
  final orderId;
  const OrderDetailsOfMart({Key? key, this.orderId}) : super(key: key);
  static var orderDetailsOfMart = "/orderDetailsOfMart";

  @override
  State<OrderDetailsOfMart> createState() => _OrderDetailsOfMartState();
}

class _OrderDetailsOfMartState extends State<OrderDetailsOfMart>
    with TickerProviderStateMixin {
  late TabController tabController;


  @override
  void initState() {
    super.initState();
    // print("ID is ${orderDetailsModel!.data!.orderId!.toString()}");
    tabController = TabController(length: 2, vsync: this, );
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return
      Scaffold(
        appBar:
        AppBar(
          title: Text("Order Details"),
        ),
        body:
        SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AddSize.padding16,
            ),
            child:
            Column(
                children: [
                  addHeight(10),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF37C666).withOpacity(0.10),
                          offset: const Offset(.1, .1,
                          ),
                          blurRadius: 20.0,
                          spreadRadius: 1.0,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                         // Image.asset('assets/images/order_details.png',height: 22,),
                          addWidth(15),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Order ID: 32',style:  TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15,
                                  color: AppThemeColor.buttonColor
                              ),),
                              addHeight(5),
                              const Text(
                                "20/07/2024",style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 11,
                                  color: Color(0xFF303C5E)
                              ),),

                            ],
                          ),
                          Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 7),
                            decoration:  BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                color: AppThemeColor.buttonColor
                            ),
                            child: const Center(
                              child: Text("Delivered",
                                style: TextStyle(
                                  color: Color(0xFFFFFFFF),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  addHeight(10),
                  ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: 2,
                      itemBuilder: (context, index) {
                        return Column(

                            children: [

                              GestureDetector(
                                onTap:(){
                                  // Get.toNamed(OrderDetailsOfMart.orderDetailsOfMart);
                                },
                                child: Container(
                                    margin: EdgeInsets.symmetric(vertical: 7),
                                    width: width,
                                    padding: const EdgeInsets.all(14),
                                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFF37C666).withOpacity(0.10),
                                        offset: const Offset(
                                          1,
                                          1,
                                        ),
                                        blurRadius: 20.0,
                                        spreadRadius: 1.0,
                                      ),
                                    ]),
                                    child:
                                    Column(crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [

                                        Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                padding: EdgeInsets.all(12),
                                                width: width * .25,
                                                // height:  height * .15,
                                                decoration: BoxDecoration(
                                                    color: Color(0xffF6F6F6),
                                                    borderRadius: BorderRadius.circular(15)

                                                ),
                                                child: CachedNetworkImage(
                                                  imageUrl: "https://images.rawpixel.com/image_800/cHJpdmF0ZS9sci9pbWFnZXMvd2Vic2l0ZS8yMDIyLTExL3JtMzYyLTAxYS1tb2NrdXAuanBn.jpg",
                                                  fit: BoxFit.cover,
                                                  width: 65,
                                                  height: 75,
                                                  errorWidget: (_, __, ___) => Image.asset(
                                                    'assets/images/Ellipse 67.png',
                                                    width: 74,
                                                    height: 82,
                                                  ),
                                                  placeholder: (_, __) => const Center(child: CircularProgressIndicator()),
                                                ),
                                              ),
                                              Expanded(
                                                child: Padding(
                                                  padding: const EdgeInsets.only(left: 15),
                                                  child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                         "Spray",
                                                          style: TextStyle(
                                                              fontSize: 17, fontWeight: FontWeight.w600, color: const Color(0xFF191723)),
                                                        ),
                                                        SizedBox(
                                                          height: 7,
                                                        ),

                                                        Text(
                                                          "Quantity: 1",
                                                          style: TextStyle(
                                                              fontSize: 13, fontWeight: FontWeight.w500, color: const Color(0xFF486769).withOpacity(.50)),
                                                        ),
                                                        SizedBox(
                                                          height: 7,
                                                        ),
                                                        Row(mainAxisAlignment: MainAxisAlignment.start,

                                                          children: [
                                                            Text(
                                                              "\$76",
                                                              style: TextStyle(
                                                                  fontSize: 17, fontWeight: FontWeight.w700, color: AppThemeColor.buttonColor),
                                                            ),
                                                            SizedBox(width: 20,),
                                                            Text(
                                                              "Tax : \$2.00",
                                                              style: TextStyle(
                                                                  fontSize: 16, fontWeight: FontWeight.w600, color: const Color(0xFF959595)),
                                                            ),
                                                          ],
                                                        ),
                                                        addHeight(7),
                                                      ]),
                                                ),
                                              ) ]),
                                      ],
                                    )


                                ),
                              )
                            ]);
                      }),
                  addHeight(5),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF37C666).withOpacity(0.10),
                          offset: const Offset(.1, .1,
                          ),
                          blurRadius: 20.0,
                          spreadRadius: 1.0,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 17,vertical: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text('Payment:',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xff1A2E33)
                                ),),
                              Spacer(),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 6,vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppThemeColor.buttonColor,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Center(
                                  child: Text(
                                    "COD",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                              )
                            ],
                          ),
                          addHeight(10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text('Subtotal:',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xff1A2E33)
                                ),),
                              Spacer(),
                              Text( '\$12.99',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xff486769)
                                ),),
                            ],
                          ),
                          addHeight(10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text('Service charge:',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xff1A2E33)
                                ),),
                              Spacer(),
                              Text( '\$5.00',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xff486769)
                                ),),
                            ],
                          ),
                          addHeight(10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text('Delivery:',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xff1A2E33)
                                ),),
                              Spacer(),
                              Text(
                                "\$76",
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xff486769)
                                ),),
                            ],
                          ),
                          addHeight(10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text('Total:',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color:  AppThemeColor.buttonColor
                                ),),
                              Spacer(),

                              Text(
                                "\$200",
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: AppThemeColor.buttonColor
                                ),),
                            ],
                          ),
                          addHeight(20)
                        ],

                      ),
                    ),
                  ),
                  // addHeight(15),
                  // Padding(
                  //   padding: const EdgeInsets.only(left: 12,right: 12),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.start,
                  //     children: [
                  //       Text('Delivery Date',
                  //         style: TextStyle(
                  //             fontSize: 16,
                  //             fontWeight: FontWeight.w700,
                  //             color: const Color(0xff1A2E33)
                  //         ),),
                  //       Spacer(),
                  //       Text( '10/12/2023',
                  //         style: TextStyle(
                  //             fontSize: 14,
                  //             fontWeight: FontWeight.w500,
                  //             color: const Color(0xff486769)
                  //         ),),
                  //     ],
                  //   ),
                  // ),
                  addHeight(40),
                  // Padding(
                  //   padding: const EdgeInsets.only(left: 12,right: 12),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.start,
                  //     children: [
                  //       Text('Status',
                  //         style: TextStyle(
                  //             fontSize: 16,
                  //             fontWeight: FontWeight.w700,
                  //             color: const Color(0xff1A2E33)
                  //         ),),
                  //       Spacer(),
                  //       Text( 'Running',
                  //         style: TextStyle(
                  //             fontSize: 14,
                  //             fontWeight: FontWeight.w500,
                  //             color: const Color(0xff486769)
                  //         ),),
                  //     ],
                  //   ),
                  // ),
                  // SizedBox(height: AddSize.size40),

                ]
            ),
          ),
        ),
        // ),
        // bottomNavigationBar: Padding(
        //   padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 15),
        //   child: InkWell(
        //     onTap: () {
        //       Get.to(()=> SendFeedbackScreen(
        //         productId: orderDetailsModel!.data!.orderItems!.map((e) => e.productId.toString()).toList().toString(),
        //       ));
        //     },
        //     child: Container(
        //       height: 56,
        //       width: AddSize.screenWidth / 1.1,
        //       decoration: BoxDecoration(
        //           borderRadius: BorderRadius.circular(10),
        //           color: const Color(0xFF0074D9)
        //       ),
        //       child: Center(
        //         child: Text(
        //           'Send Feedback For Order',
        //           style: TextStyle(
        //             color:  Colors.white,
        //             fontSize: 16,
        //             fontWeight: FontWeight.w700,
        //           ),
        //           textAlign: TextAlign.center,
        //         ),
        //       ),
        //     ),
        //   ),
        // ),
      );
  }

}

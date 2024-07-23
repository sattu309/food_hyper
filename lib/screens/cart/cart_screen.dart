import 'dart:convert';
import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../components/rounded_icon_btn.dart';
import '../../constants.dart';
import '../../controllers/cart_controller.dart';
import '../../controllers/session_controller.dart';
import '../../helper/apptheme_color.dart';
import '../../helper/custom_snackbar.dart';
import '../../helper/heigh_width.dart';
import '../../models/CartDataLocalModel.dart';
import '../login_flow/login_page.dart';
import 'checkout_page.dart';

class CartScreen extends StatefulWidget {
  static String routeName = "/cart";

  const CartScreen({
    super.key,
  });

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  CartItem? cartItem;
  final sessionIdController = Get.put(SessionController());
  final cartController = Get.put(CartController());
  String allQty = "";
  String allQtyPrice = "";
  int sumOfQty = 0;
  int  totalAmt = 0;

  String imagePath = "https://shopdemo.bitlogiq.co.za/products/";

  Future<void> deleteCartMutation(String cartId) async {
    final MutationOptions options = MutationOptions(
      document: gql('''
    mutation DeleteCart(\$cartId: ID!) {
      deleteCart(id: \$cartId) {
        message
           cart {
            id
            users_id
            sessionid
            product_id
            productvariant_id
            order_id
            price
            saleprice
            qty
            amount
            discount
            productname
            varname
            slug
            cartmsg
            is_promo
            is_storestock
            image
        }
      }
    }
  '''),
      variables: {
        'cartId': cartId,
      },
    );

    final GraphQLClient client = GraphQLProvider.of(context).value;

    final QueryResult result = await client.mutate(options);

    if (result.hasException) {
      final error = result.exception!.graphqlErrors.first.message;
      print("DELETE CART ERROR::::: $error");
      final snackBar = CustomSnackbar.build(
        message: error,
        backgroundColor: AppThemeColor.buttonColor,
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      final Map<String, dynamic>? deleteCartData = result.data?['deleteCart'];
      if (deleteCartData != null) {
        final List<dynamic> cartResponse = deleteCartData['cart'];
        final List<Map<String, dynamic>> modifiedAaa =
            cartResponse.cast<Map<String, dynamic>>().map((item) {
          return Map<String, dynamic>.from(item)..remove('__typename');
        }).toList();
        log("TESTING CART DELETION ${modifiedAaa}");

        SharedPreferences cartLocalData =
        await SharedPreferences.getInstance();
        if (modifiedAaa.isNotEmpty) {
          cartLocalData.setString('cart_data', jsonEncode(modifiedAaa));
          print(
              "AFTER DELETING CART DATA SAVED LOCALLY: ${cartLocalData.getString('cart_data')}");
        } else {
          bool isRemoved = await cartLocalData.remove('cart_data');
          cartController.getCartDataLocally();
          log("DATA IS REMOVED FROM THE LOCAL STORAGE $isRemoved");
          print("CART IS NOW EMPTY");
        }

        final snackBar = CustomSnackbar.build(
          message: deleteCartData['message'].toString(),
          backgroundColor: AppThemeColor.buttonColor,
          onPressed: () {},
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        print('Delete cart error: Invalid response data');
      }
    }
  }


  Future<void> updateCartMutation(String cartId, String qty) async {
    SharedPreferences cartLocalData = await SharedPreferences.getInstance();
    log("BEFORE${cartLocalData.getString('cart_data')}");
    await cartLocalData.remove('cart_data');
    log("AFTER ${cartLocalData.getString('cart_data')}");
    final MutationOptions options = MutationOptions(
      document: gql('''
  mutation UpdateCartProduct(\$cartId: ID!,\$qty: Int!) {
    updateCartProduct(id: \$cartId, qty: \$qty) {
            message
           cart {
            id
            users_id
            sessionid
            product_id
            productvariant_id
            order_id
            price
            saleprice
            qty
            amount
            discount
            productname
            varname
            slug
            cartmsg
            is_promo
            is_storestock
            image
        }
      }
    }
  '''),
      variables: {
        'cartId': cartId,
        'qty': int.parse(qty),
      },
    );

    final GraphQLClient client = GraphQLProvider.of(context).value;

    final QueryResult result = await client.mutate(options);

    if (result.hasException) {
      final error = result.exception!.graphqlErrors.first.message;
      print("UPDATE CART ERROR::::: $error");
      final snackBar = CustomSnackbar.build(
        message: error,
        backgroundColor: AppThemeColor.buttonColor,
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      final Map<String, dynamic>? updateCartData =
          result.data?['updateCartProduct'];
      if (updateCartData != null) {
        final List<dynamic> cartResponse = updateCartData['cart'];
        final List<Map<String, dynamic>> modifiedAaa =
            cartResponse.cast<Map<String, dynamic>>().map((item) {
          return Map<String, dynamic>.from(item)..remove('__typename');
        }).toList();

        if (modifiedAaa.isNotEmpty) {
          SharedPreferences cartLocalData =
              await SharedPreferences.getInstance();
          cartLocalData.setString('cart_data', jsonEncode(modifiedAaa));
          print(
              "AFTER UPDATING CART DATA SAVED LOCALLY: ${cartLocalData.getString('cart_data')}");
        }
        final snackBar = CustomSnackbar.build(
          message: updateCartData['message'].toString(),
          backgroundColor: AppThemeColor.buttonColor,
          onPressed: () {},
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        print('UPDATE cart error: Invalid response data');
      }
    }
  }

  late final String fetchCartData;


  CartItem? cartData;

  @override
  void initState() {
    super.initState();
    cartController.getCartDataLocally();
    log("Access Token ${sessionIdController.sessionId.value.toString()}");
    fetchCartData = """
  query GetCart {
   
    getCart(sessionid:"${sessionIdController.sessionId.value}") {
        id
        product_id
        price
        qty
        amount
        discount
        productname
        varname
        image
    }
}
  """;
  }

  @override
  Widget build(BuildContext context) {
    return

      Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade50,
        title: const Column(
          children: [
            Text(
              "My Bag ",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 17,
                  fontFamily: "muli",
                  fontWeight: FontWeight.w600),
            ),
            // Text(
            //   "${demoCarts.length} items",
            //   style: Theme.of(context).textTheme.bodySmall,
            // ),
          ],
        ),
      ),
      body: Query(
          options: QueryOptions(document: gql(fetchCartData)),
          builder: (QueryResult result,
              {Refetch? refetch, FetchMore? fetchMore}) {
            if (result.hasException) {
              return Text(result.exception.toString());
            }
            if (result.isLoading) {
              return  Center(
                  child: CircularProgressIndicator(
                color: AppThemeColor.buttonColor,
              ));
            }
            final cartData = result.data?['getCart'];
            print("CART DATA $cartData");

            return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                child: cartController.cartItems.isEmpty
                    ? // Show empty cart message
                     Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: 250),
                          child: Text(
                            "Your cart is empty.",
                            style: TextStyle(
                                fontSize: 18,
                                color: AppThemeColor.buttonColor),
                          ),
                        ),
                      )
                    : Obx((){
                      return Column(
                        children: [
                          Expanded(
                            child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: cartController.cartItems.length,
                                itemBuilder: (context, index) {
                                  final data = cartController.cartItems[index];

                                  return
                                    Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 15),
                                    margin: const EdgeInsets.symmetric(
                                      vertical: 5,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          offset: const Offset(0, -15),
                                          blurRadius: 20,
                                          color: const Color(0xFFDADADA).withOpacity(0.15),
                                        )
                                      ],
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: 88,
                                          child: AspectRatio(
                                            aspectRatio: 0.80,
                                            child: Container(
                                              padding: const EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                BorderRadius.circular(15),
                                              ),
                                              child: CachedNetworkImage(
                                                imageUrl:
                                                imagePath + data.image,
                                                height: 60,
                                                width: 60,
                                                errorWidget: (_, __, ___) =>
                                                    Image.asset(
                                                      "assets/images/Image Banner 3.png",
                                                    ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 20),
                                        Expanded(
                                          child: Column(
                                            children: [
                                              Row(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      data.productName
                                                          .toString(),
                                                      style: const TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 14),
                                                    ),
                                                  ),
                                                  addWidth(20),

                                                  GestureDetector(
                                                      onTap: () async {
                                                          deleteCartMutation(
                                                              data.id)
                                                              .then((value) {
                                                            cartController.getCartDataLocally();
                                                            });
                                                        // }
                                                      },
                                                      child:  Icon(
                                                        Icons.clear,
                                                        color: AppThemeColor
                                                            .buttonColor,
                                                      ))
                                                ],
                                              ),
                                              const SizedBox(height: 10),
                                              Row(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 2,
                                                        horizontal: 5),
                                                    decoration:
                                                    const BoxDecoration(
                                                        color:
                                                        Colors.black12),
                                                    child: Text(
                                                      "Size ${data.varName.toString()}",
                                                      style: const TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 14),
                                                    ),
                                                  ),
                                                  addWidth(10),
                                                  Container(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 2,
                                                        horizontal: 5),
                                                    decoration:
                                                    const BoxDecoration(
                                                        color:
                                                        Colors.black12),
                                                    child: Text(
                                                      "Qty ${data.qty.toString()}",
                                                      style: const TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 14),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 15),
                                              Row(
                                                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text.rich(
                                                    TextSpan(
                                                      text:
                                                      "R${data.amount.toString()}",
                                                      style:  TextStyle(
                                                        fontSize: 15,
                                                          fontWeight:
                                                          FontWeight.w600,
                                                          color: Colors.black.withOpacity(.70)),
                                                      // children: [
                                                      //   TextSpan(
                                                      //       text: " x${widget.cart.numOfItem}",
                                                      //       style: Theme.of(context).textTheme.bodyLarge),
                                                      // ],
                                                    ),
                                                  ),
                                                  const Spacer(),
                                                  // addWidth(20),
                                                  RoundedIconBtn(
                                                    icon: Icons.remove,
                                                    press: () {
                                                      log("CART IDDDDD ${data.id}");
                                                      if (data.qty == 1) {
                                                        deleteCartMutation(
                                                            data.id)
                                                            .then((value) {
                                                          setState(() {});
                                                        });
                                                      } else {
                                                        updateCartMutation(
                                                            data.id, ((int.parse(data.qty.toString()) ?? 0) - 1).toString(),).then((value){
                                                          cartController.getCartDataLocally();
                                                        });
                                                      }
                                                    },
                                                  ),
                                                  const SizedBox(width: 15),
                                                  Text(data.qty.toString(),
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyMedium),
                                                  const SizedBox(width: 15),
                                                  RoundedIconBtn(
                                                    icon: Icons.add,
                                                    showShadow: true,
                                                    press: () async {


                                                      log("Before ${data.qty.toString()}");
                                                      log("cart id  ${data.id.toString()}");
                                                      // SharedPreferences cartLocalData = await SharedPreferences.getInstance();
                                                      // int.parse((myCartController.model.value.data!.cartItems![index].cartItemQty ?? "").toString()) + 1,

                                                      updateCartMutation(
                                                          data.id, ((int.parse(data.qty.toString()) ?? 0) + 1).toString(),).then((value){
                                                        cartController.getCartDataLocally();
                                                      });

                                                    },
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                        addHeight(7)
                                      ],
                                    ),
                                  );
                                }),
                          ),
                          // const Padding(
                          //   padding: EdgeInsets.symmetric(horizontal: 20),
                          //   child: CommonTextFieldWidget1(
                          //     // controller: emailController,
                          //     hint: "Enter your promo code",
                          //   ),
                          // ),
                        ],
                      );
                })
            );
          }),
      bottomNavigationBar:
          Obx((){
            return  Padding(
              padding: const EdgeInsets.only(bottom: 60,left: 15,right: 15),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 20,
                ),
                // height: 174,
                decoration: BoxDecoration(
                  border: const Border(
                      top: BorderSide(
                        color: Colors.black12,
                      )),
                  color: Colors.white,
                  // borderRadius: const BorderRadius.only(
                  //   topLeft: Radius.circular(30),
                  //   topRight: Radius.circular(30),
                  // ),
                  boxShadow: [
                    BoxShadow(
                      offset: const Offset(0, -15),
                      blurRadius: 20,
                      color: const Color(0xFFDADADA).withOpacity(0.15),
                    )
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Row(
                    //   children: [
                    //     Container(
                    //       padding: const EdgeInsets.all(10),
                    //       height: 40,
                    //       width: 40,
                    //       decoration: BoxDecoration(
                    //         color: const Color(0xFFF5F6F9),
                    //         borderRadius: BorderRadius.circular(10),
                    //       ),
                    //       child: SvgPicture.asset("assets/icons/receipt.svg"),
                    //     ),
                    //     const Spacer(),
                    //     const Text("Add voucher code"),
                    //     const SizedBox(width: 8),
                    //     const Icon(
                    //       Icons.arrow_forward_ios,
                    //       size: 12,
                    //       color: kTextColor,
                    //     )
                    //   ],
                    // ),
                    // const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Text.rich(
                            TextSpan(
                              text: "Total:\n",
                              children: [
                                TextSpan(
                                  text: "\$${cartController.totalAmt.value}",
                                  style: const TextStyle(
                                      fontSize: 16, color: Colors.black),
                                ),
                                TextSpan(
                                  text: allQty.toString(),
                                  style: const TextStyle(
                                      fontSize: 16, color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppThemeColor.buttonColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)
                              )
                            ),
                            onPressed: () async {
                              SharedPreferences pref = await SharedPreferences.getInstance();
                              if( pref.getString("auth_token") != null){
                                // Get.offAll(()=>const InitScreen());
                                Get.to(() => const CheckoutPage());
                              }else{
                                Get.offAll(()=>const LoginPage());
                              }

                            },
                            child: const Text("Check Out"),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          })

    );
  }

  showListOfCoupons() {
    var height = MediaQuery.of(context).size.height;
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        enableDrag: false,
        isDismissible: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        builder: (context) {
          return WillPopScope(
            onWillPop: () async {
              return false;
            },
            child: Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Container(
                  width: double.maxFinite,
                  // height: double.maxFinite,
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(20),
                          topLeft: Radius.circular(20))),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        addHeight(40),
                        GestureDetector(
                          onTap: () {
                            Get.back();
                          },
                          child: const Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Text(
                              "Your promo code",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                  color: Color(0xff222222)),
                            ),
                          ),
                        ),
                        addHeight(20),
                        SizedBox(
                          height: 200,
                          child: ListView(
                            shrinkWrap: true,
                            scrollDirection: Axis
                                .vertical, // This enables horizontal scrolling
                            children: List.generate(2, (index) {
                              return Column(
                                children: [
                                  //   Container(
                                  //   width: double.infinity,
                                  //   //margin: const EdgeInsets.all(20),
                                  //   // padding: const EdgeInsets.symmetric(
                                  //   //   horizontal: 12,
                                  //   //   vertical: 14,
                                  //   // ),
                                  //   decoration: BoxDecoration(
                                  //     color: const Color(0xFF4A3298),
                                  //     borderRadius: BorderRadius.circular(20),
                                  //   ),
                                  //   child:  Row(
                                  //     children: [
                                  //       Container(
                                  //         height: 70,
                                  //         width: 70,
                                  //         color: Colors.red,
                                  //         child: Image.asset( "assets/images/ps4_console_white_1.png",fit: BoxFit.contain,),
                                  //       ),
                                  //       // Image.asset("assets/images/Image Banner 2.png",fit: BoxFit.fitHeight,width: 50,),
                                  //       Column(
                                  //         children: [
                                  //           const Expanded(
                                  //             child: Text.rich(
                                  //               TextSpan(
                                  //                 style: TextStyle(color: Colors.white),
                                  //                 children: [
                                  //                   TextSpan(text: "A Summer Surpise\n"),
                                  //                   TextSpan(
                                  //                     text: "Cashback 20%",
                                  //                     style: TextStyle(
                                  //                       fontSize: 20,
                                  //                       fontWeight: FontWeight.bold,
                                  //                     ),
                                  //                   ),
                                  //                 ],
                                  //               ),
                                  //             ),
                                  //           ),
                                  //         ],
                                  //       ),
                                  //     ],
                                  //   ),
                                  // ),
                                  Container(
                                    height: 80,
                                    decoration: BoxDecoration(
                                        color: Color(0xFFFFFFFF),
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                              offset: Offset(0, 0),
                                              blurRadius: 50,
                                              color: Color(0xFF000000)
                                                  .withOpacity(0.10),
                                              spreadRadius: 0)
                                        ]),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          height: 80,
                                          width: 85,
                                          decoration: const BoxDecoration(
                                              color: Colors.red,
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(10),
                                                  bottomLeft:
                                                      Radius.circular(10))),
                                          child: Center(
                                              child: Text(
                                            "OFF\n15%",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600),
                                          )),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Summer Sale',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 18),
                                            ),
                                            addHeight(3),
                                            Text(
                                              'mypromocode2024 ',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 15),
                                            ),
                                          ],
                                        ),
                                        Spacer(),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              '6 days remaining',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 10),
                                            ),
                                            addHeight(5),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 7,
                                                      horizontal: 12),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(7),
                                                  color: Colors.red),
                                              child: const Center(
                                                  child: Text(
                                                "Apply",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.white),
                                              )),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        )
                                      ],
                                    ),
                                  ),
                                  addHeight(15)
                                ],
                              );
                            }),
                          ),
                        ),
                        addHeight(30),
                      ],
                    ),
                  ),
                )),
          );
        });
  }
}

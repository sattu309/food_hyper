import 'dart:developer';
import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide Badge;
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import '../../controllers/cart_controller.dart';
import '../../controllers/search_controller.dart';
import '../../controllers/wishlist_controller.dart';
import '../../helper/apptheme_color.dart';
import '../../helper/heigh_width.dart';
import '../cart/cart_screen.dart';
import '../details/details_screen.dart';
import '../home/components/search_field.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final wishListController = Get.put(WishListController());
  final cartController = Get.put(CartController());
  final searchController = Get.put(ProductSearchController());

  String calDis(String regPrice, String salePrice) {
    bool isVar = regPrice.contains(' - ');
    double disCount = 0;

    if (isVar) {
      List<String> regPrices = regPrice.split(' - ');
      List<String> salePrices = salePrice.split(' - ');

      // Parsing the string prices to double
      double regPriceMin = double.parse(regPrices[0].replaceAll(RegExp(r'[^\d.]'), ''));
      double salePriceMin = double.parse(salePrices[0].replaceAll(RegExp(r'[^\d.]'), ''));
      disCount = ((regPriceMin - salePriceMin) / regPriceMin) * 100;
    } else {
      // Parsing the string prices to double
      double regPriceValue = double.parse(regPrice.replaceAll(RegExp(r'[^\d.]'), ''));
      double salePriceValue = double.parse(salePrice.replaceAll(RegExp(r'[^\d.]'), ''));

      disCount = ((regPriceValue - salePriceValue) / regPriceValue) * 100;
    }

    return (disCount.toInt()).toString();
  }


  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 1,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SearchField(),
            GestureDetector(
              onTap: (){
                pushScreen(context, screen:CartScreen(),withNavBar: true );

              },
              child: Badge(
                badgeStyle: BadgeStyle(badgeColor: AppThemeColor.buttonColor,),
                badgeContent:     Obx((){
                  return Text(cartController.cartCount.value,style: TextStyle(color: Colors.white),);}),
                child: Icon(Icons.shopping_bag_outlined,color: Colors.grey,size: 25,),
              ),
            )
          ],
        ),

      ),
      body:
      searchController.getSearchData.isNotEmpty ?
          Obx((){
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: GridView.builder(
                      padding: const EdgeInsets.only(bottom: 8),
                      itemCount: searchController.getSearchData.length,
                      gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.6,
                        mainAxisSpacing: 0,
                        crossAxisSpacing: 0,
                        mainAxisExtent: 290,
                      ),
                      itemBuilder: (context, index) {
                        String disPercentage = '';
                        final productsData = searchController.getSearchData[index]['node'];

                        final image = productsData['image'];
                        String imageUrl = '';
                        if (image != null && image['sourceUrl'] != null) {
                          imageUrl = image['sourceUrl'];
                        }
                        String regularPriceStr =
                            productsData['regularPrice'] ?? '0';
                        String salePriceStr = productsData['salePrice'] ?? '0';
                        if (salePriceStr != "0") {
                          disPercentage = calDis(regularPriceStr, salePriceStr);
                        }
                        return GestureDetector(
                          onTap: () {
                            log("PRODUCT ID of category product ${productsData['databaseId'].toString()}");
                            // Get.to(()=> DetailsScreen(productId: productsData['id'],));
                            pushScreen(context,
                                screen: DetailsScreen(
                                  productId:
                                  productsData['databaseId'].toString(), productStatus: productsData['stockStatus'],
                                ),
                                withNavBar: true);
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              addHeight(10),
                              Stack(
                                children: [
                                  Container(
                                      height: 275,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                      ),
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(7),
                                        border:
                                        Border.all(color: Colors.black12),
                                        boxShadow: [
                                          BoxShadow(
                                              offset: const Offset(4, 4),
                                              spreadRadius: 2,
                                              blurRadius: 5,
                                              color: Colors.black
                                                  .withOpacity(0.10))
                                        ],
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                            BorderRadius.circular(7),
                                            child: CachedNetworkImage(
                                              imageUrl: imageUrl,
                                              height: height * .20,
                                              width: width * .45,
                                              fit: BoxFit.contain,
                                              errorWidget: (_, __, ___) =>
                                                  Image.asset(
                                                    "assets/images/Image Popular Product 2.png",
                                                    fit: BoxFit.cover,
                                                    height: 50,
                                                    width: 50,
                                                  ),
                                              placeholder: (_, __) => Container(
                                                color: Colors.grey.shade200,
                                              ),
                                            ),
                                          ),
                                          // const SizedBox(height: 3),
                                          Text(productsData['name'],
                                              maxLines: 1,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  color: CupertinoColors.black,
                                                  fontSize: 14)),
                                          addHeight(3),
                                          Text(
                                              productsData['stockStatus'] ==
                                                  "IN_STOCK"
                                                  ? "INSTOCK"
                                                  : "OUT OF STOCK",
                                              maxLines: 1,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  color: productsData[
                                                  'stockStatus'] ==
                                                      "IN_STOCK"
                                                      ? Colors.green
                                                      : Colors.red,
                                                  fontSize: 10)),
                                          addHeight(3),
                                          productsData['averageRating'] != null
                                              ? Row(children: [
                                            ...List.generate(
                                                productsData[
                                                'averageRating'],
                                                    (index) {
                                                  return SingleChildScrollView(
                                                    scrollDirection:
                                                    Axis.vertical,
                                                    child: Row(
                                                      children: [

                                                        Icon(
                                                          Icons.star,
                                                          color: Colors.yellow
                                                              .shade600,
                                                          size: 17,
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                }),
                                            addWidth(3),
                                            Text(
                                              "${productsData['reviewCount']}",
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontFamily:
                                                "IBM Plex Sans",
                                                fontWeight:
                                                FontWeight.w700,
                                                color: Colors.black38,
                                              ),
                                            ),
                                          ])
                                              : addHeight(16),
                                          addHeight(2),
                                          (salePriceStr != "0")
                                              ? Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              // addWidth(8),
                                              Row(
                                                children: [
                                                  Flexible(
                                                    child: Text(
                                                      regularPriceStr,
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        fontFamily:
                                                        "IBM Plex Sans",
                                                        fontWeight:
                                                        FontWeight
                                                            .w700,
                                                        decoration:
                                                        TextDecoration
                                                            .lineThrough,
                                                        decorationStyle:
                                                        TextDecorationStyle
                                                            .solid,
                                                        color: Colors.grey
                                                            .shade400,
                                                      ),
                                                    ),
                                                  ),
                                                  addWidth(5),
                                                  Flexible(
                                                    child: Text(
                                                      salePriceStr,
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        fontFamily:
                                                        "IBM Plex Sans",
                                                        fontWeight:
                                                        FontWeight
                                                            .w700,
                                                        color: AppThemeColor
                                                            .buttonColor,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          )
                                              : Text(
                                            productsData['price'] != null ? productsData['price'] : "",
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontFamily: "IBM Plex Sans",
                                              fontWeight: FontWeight.w700,
                                              color: AppThemeColor
                                                  .buttonColor,
                                            ),
                                          ),
                                          addHeight(5),
                                          productsData['type'] == "SIMPLE"
                                              ? Container(
                                            height: 25,
                                            alignment:
                                            Alignment.centerRight,
                                            width: width * .5,
                                            child: ElevatedButton(
                                              style: ElevatedButton
                                                  .styleFrom(
                                                shape:
                                                RoundedRectangleBorder(),
                                                backgroundColor:
                                                AppThemeColor
                                                    .buttonColor,
                                              ),
                                              onPressed: () async {
                                                wishListController
                                                    .addToCart(
                                                    productsData[
                                                    'databaseId'],
                                                    0,
                                                    1,
                                                    context);
                                                cartController
                                                    .getCartDataLocally();
                                              },
                                              child: const Text(
                                                "ADD TO CART",
                                                style: TextStyle(
                                                    fontWeight:
                                                    FontWeight.w400,
                                                    fontSize: 10),
                                              ),
                                            ),
                                          )
                                              : Container(
                                            height: 25,
                                            alignment:
                                            Alignment.centerRight,
                                            width: width * .5,
                                            child: ElevatedButton(
                                              style: ElevatedButton
                                                  .styleFrom(
                                                shape:
                                                RoundedRectangleBorder(),
                                                backgroundColor:
                                                AppThemeColor
                                                    .buttonColor,
                                              ),
                                              onPressed: () async {
                                                pushScreen(context,
                                                    screen: DetailsScreen(
                                                      productId: productsData[
                                                      'databaseId']
                                                          .toString(), productStatus: productsData['stockStatus'],
                                                    ),
                                                    withNavBar: true);
                                              },
                                              child: const Text(
                                                "VIEW OPTION",
                                                style: TextStyle(
                                                    fontWeight:
                                                    FontWeight.w400,
                                                    fontSize: 10),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    //
                                    // Image.asset("assets/images/glap.png",),
                                  ),
                                  (disPercentage != '')
                                      ? Positioned(
                                      top: height * 0.015,
                                      left: 10,
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 5, vertical: 3),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.circular(4),
                                            color:
                                            AppThemeColor.buttonColor),
                                        child: Text(disPercentage + '%',
                                            maxLines: 1,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w500,
                                                color:
                                                CupertinoColors.white,
                                                fontSize: 12)),
                                      ))
                                      : SizedBox()
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          }):Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Align(
                    alignment: Alignment.topCenter,
              child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 30),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(3),
                  boxShadow: [
                    BoxShadow(
                        offset: const Offset(4, 4),
                        spreadRadius: 2,
                        blurRadius: 5,
                        color: Colors.black
                            .withOpacity(0.10))
                  ],
                ),
                child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                Text("Sorry, no result found",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600),),
                Text("Please check the product or try to search something else",textAlign:TextAlign.center,style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500),)
                        ],
                      ),
              ),
            ),
          )

    );
  }
}

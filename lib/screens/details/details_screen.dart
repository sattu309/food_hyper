import 'dart:convert';
import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/helper/heigh_width.dart';
import 'package:shop_app/screens/cart/cart_screen.dart';
import 'package:widget_zoom/widget_zoom.dart';
import '../../components/rounded_icon_btn.dart';
import '../../constants.dart';
import '../../controllers/cart_controller.dart';
import '../../controllers/session_controller.dart';
import '../../helper/apptheme_color.dart';
import '../../helper/custom_snackbar.dart';
import '../../models/login_token_model.dart';
import 'components/top_rounded_container.dart';

class DetailsScreen extends StatefulWidget {
  final String productId;

  const DetailsScreen({
    super.key,
    required this.productId,
  });

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  final sessionController = Get.put(SessionController());
  final cartController = Get.put(CartController());
  String inventoryCheck = "";
  int counter = 1;
  increseCounter() {
    counter++;
    setState(() {});
  }

  decreaseCounter() {
    if (counter > 1) {
      counter--;
    }

    setState(() {});
  }

  bool showFullDescription = false;
  bool isFavourite = true;
  int currentIndex = 0;
  int sizeIndex = -1;
  late String productDetails;
  String variantPrice = "";
  String variationSalePrice = "";
  String productVariantId = "";
  RxDouble sliderIndex = (0.0).obs;
  @override
  void initState() {
    super.initState();
    productDetails = """
      query Product {
        product(id: "${widget.productId}") {
          id
          productname
          price
          saleprice
          shortdesc
          description
          inventory
          is_new
          on_sale
           productimages {
            id
            imagepath
            product_id
             }
             productattributes{
                id
                is_variation
                attribute{
                  attributename
                }
                 attributeterm {
                   termname
                 }
          }        
       productvariations {
        id
            varsku
            price
            saleprice
            inventory
            variationtitle
            attribute {
                attributename
            }
            attributeterm {
                termname
          }
        }
       }
      }
    """;
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
    // });
  }

  String imagePath = "https://shopdemo.bitlogiq.co.za/products/";
  int galleryIndex = 0;
  RxString responseData = "".obs;
  RxString cartResponse = "".obs;
  bool checkAddtoCartDat = false;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      // extendBody: true,
      // extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: AppThemeColor.buttonColor,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading:
        GestureDetector(
            onTap: (){
             Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back_ios_sharp,color: Colors.white,size: 18,)),
        // leading: Padding(
        //   padding: const EdgeInsets.all(8.0),
        //   child: ElevatedButton(
        //     onPressed: () {
        //       Navigator.pop(context);
        //     },
        //     style: ElevatedButton.styleFrom(
        //       shape: const CircleBorder(),
        //       padding: EdgeInsets.zero,
        //       elevation: 0,
        //       backgroundColor: Colors.white,
        //     ),
        //     child: const Icon(
        //       Icons.arrow_back_rounded,
        //       color: Colors.black,
        //       size: 18,
        //     ),
        //   ),
        // ),
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            "assets/images/food_logo.png",
            width: width * .4,
          ),
        ),
        actions: [
          // Row(
          //   children: [
          //     Container(
          //       margin: const EdgeInsets.only(right: 20),
          //       padding:
          //           const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          //       decoration: BoxDecoration(
          //         color: Colors.white,
          //         borderRadius: BorderRadius.circular(14),
          //       ),
          //       child: Row(
          //         children: [
          //           const Text(
          //             "4.7",
          //             style: TextStyle(
          //               fontSize: 14,
          //               color: Colors.black,
          //               fontWeight: FontWeight.w600,
          //             ),
          //           ),
          //           const SizedBox(width: 4),
          //           SvgPicture.asset("assets/icons/Star Icon.svg"),
          //         ],
          //       ),
          //     ),
          //   ],
          // ),
          Align(
            alignment: Alignment.topRight,
            child: Container(
              padding: const EdgeInsets.all(16),
              width: 48,
              decoration: BoxDecoration(
                color: isFavourite
                    ? const Color(0xFFFFE6E6)
                    : const Color(0xFFF5F6F9),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
              ),
              child: SvgPicture.asset(
                "assets/icons/Heart Icon_2.svg",
                colorFilter: ColorFilter.mode(
                   AppThemeColor.buttonColor,
                    BlendMode.srcIn),
                height: 16,
              ),
            ),
          ),
        ],
      ),
      body: Query(
          options: QueryOptions(document: gql(productDetails)),
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
            final productData = result.data?['product'];
            final image = productData['productimages'];
            final variation = productData['productvariations'];
            final productAttribute = productData['productattributes'];
            log("Product data $productData");
            log("Product Variation $variation");
            log("ALL IMAGES ARE $image");

            // String imageUrl = '';
            // if (image.isNotEmpty) {
            //   imageUrl = image[0]['imagepath'];
            // }

            List<dynamic> productAttributes = [];
            List<dynamic> productAttributesTermValue = [];
            if (productAttribute != null) {
              productAttributes = productAttribute
                  .map((productAttribute) => productAttribute['attribute'])
                  .toList();
              productAttributesTermValue = productAttribute
                  .map((productAttribute) => productAttribute['attributeterm'])
                  .toList();
              log("PRODUCT ATTRIBUTES ARE   ${productAttribute.toString()}");
              log("PRODUCT ATTRIBUTES TERM VALUE ARE   ${productAttributesTermValue.toString()}");
            }
            List<dynamic> productSize = [];
            if(variation.isNotEmpty){
              inventoryCheck = variation[0]['inventory'].toString();
            }

            if (variation != null) {
              productSize = variation
                  .map((variation) => variation['attributeterm'])
                  .toList();
              log("PRODUCT SIZES ARE   ${productSize.toString()}");
              if (variation.isNotEmpty && variation[0]['inventory'] != 0) {
                productVariantId = variation[currentIndex]['id'];
              }
              else{
                productVariantId = '0';
              }
            }
            List<dynamic> allImages = [];
            if (image != null) {
              allImages = image.map((image) => image['imagepath']).toList();
            }

            return SingleChildScrollView(
              child: Column(

                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ...List.generate(
                          allImages.length,
                              (index) {
                            return SizedBox(
                              width: width*.85,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Stack(
                                    children: [
                                      WidgetZoom(
                                        heroAnimationTag: "tag",
                                        maxScaleFullscreen:4,
                                        zoomWidget: Container(
                                          margin: const EdgeInsets.symmetric(horizontal: 2),
                                          // padding: const EdgeInsets.all(20),
                                          decoration: BoxDecoration(
                                            color: kSecondaryColor.withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(12),

                                            boxShadow: [
                                              BoxShadow(
                                                offset: const Offset(0, -15),
                                                blurRadius: 20,
                                                color: const Color(0xFFDADADA).withOpacity(0.15),
                                              )
                                            ],
                                          ),
                                          child:  CachedNetworkImage(
                                            imageUrl: imagePath +
                                                allImages[index].toString(),
                                            fit: BoxFit.cover,
                                            width: width,
                                            height: height*.45,
                                            errorWidget: (_, __, ___) =>const SizedBox(),
                                            // Image.asset(
                                            // "assets/images/Image Banner 3.png",
                                            // ),
                                            placeholder: (_, __) => const Center(
                                                child: CircularProgressIndicator()),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                          top: 10,
                                          left: 15,
                                          child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 2, horizontal: 5),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                  BorderRadius.circular(3),
                                                  color: AppThemeColor.buttonColor),
                                              child: productData['is_new'] == "0"
                                                  ? const Text(
                                                "NEW",
                                                style: TextStyle(
                                                    fontFamily: "IBM Plex Sans",
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 13,
                                                    color: Colors.white),
                                              )
                                                  : productData['on_sale'] == "0"
                                                  ? const Text(
                                                "SALE",
                                                style: TextStyle(
                                                    fontFamily:
                                                    "IBM Plex Sans",
                                                    fontWeight:
                                                    FontWeight.w500,
                                                    fontSize: 13,
                                                    color: Colors.white),
                                              )
                                                  : null)),
                                      // Positioned(
                                      //   top: height * .45,
                                      //   child: Obx(() {
                                      //   return Center(
                                      //     child: DotsIndicator(
                                      //       dotsCount: image.length,
                                      //       position: sliderIndex.value.toInt(),
                                      //       decorator: DotsDecorator(
                                      //         color: Colors.grey.shade100, // Inactive color
                                      //         activeColor: Colors.black,
                                      //         size: const Size(00.0,
                                      //             0.0),
                                      //         activeSize: const Size(90.0,
                                      //             5.0),
                                      //         shape: const LinearBorder(),
                                      //         activeShape: const ContinuousRectangleBorder(),
                                      //
                                      //         // color: Colors.grey.shade300, // Inactive color
                                      //         // activeColor: AppThemeColor.buttonColor,
                                      //         // size: const Size.square(8),
                                      //         // activeSize: const Size.square(8),
                                      //
                                      //         // activeSize: const Size.fromHeight(12),
                                      //       ),
                                      //     ),
                                      //   );
                                      // }),)
                                    ],
                                  ),
                                ],
                              ),
                            ); // here by default width and height is 0
                          },
                        ),

                      ],
                    ),
                  ),

                  // CarouselSlider(
                  //   options: CarouselOptions(
                  //       viewportFraction: 1,
                  //       autoPlay: false,
                  //       onPageChanged: (value, _) {
                  //         sliderIndex.value = value.toDouble();
                  //       },
                  //       autoPlayCurve: Curves.bounceIn,
                  //       height: height * .45),
                  //   items: List.generate(
                  //       allImages.length,
                  //       (index) => Stack(
                  //             children: [
                  //               WidgetZoom(
                  //                 heroAnimationTag: "tag",
                  //                 maxScaleFullscreen: 4,
                  //                 zoomWidget: Container(
                  //                   width: width,
                  //                   // margin:
                  //                   //     EdgeInsets.symmetric(horizontal: width * .01),
                  //                   decoration: const BoxDecoration(
                  //                       color: AppThemeColor.backgroundcolor),
                  //                   child: CachedNetworkImage(
                  //                     imageUrl: imagePath +
                  //                         allImages[index].toString(),
                  //                      fit: BoxFit.fitWidth,
                  //                     errorWidget: (_, __, ___) => Image.asset(
                  //                       "assets/images/Image Banner 3.png",
                  //                     ),
                  //                     placeholder: (_, __) => const Center(
                  //                         child: CircularProgressIndicator()),
                  //                   ),
                  //                 ),
                  //               ),
                  //               Positioned(
                  //                   top: 10,
                  //                   left: 10,
                  //                   child: Container(
                  //                       padding: EdgeInsets.symmetric(
                  //                           vertical: 2, horizontal: 5),
                  //                       decoration: BoxDecoration(
                  //                           borderRadius:
                  //                               BorderRadius.circular(3),
                  //                           color: AppThemeColor.buttonColor),
                  //                       child: productData['is_new'] == "0"
                  //                           ? const Text(
                  //                               "NEW",
                  //                               style: TextStyle(
                  //                                   fontFamily: "IBM Plex Sans",
                  //                                   fontWeight: FontWeight.w500,
                  //                                   fontSize: 13,
                  //                                   color: Colors.white),
                  //                             )
                  //                           : productData['on_sale'] == "0"
                  //                               ? Text(
                  //                                   "SALE",
                  //                                   style: TextStyle(
                  //                                       fontFamily:
                  //                                           "IBM Plex Sans",
                  //                                       fontWeight:
                  //                                           FontWeight.w500,
                  //                                       fontSize: 13,
                  //                                       color: Colors.white),
                  //                                 )
                  //                               : null))
                  //             ],
                  //           )),
                  // ),
                  // SizedBox(
                  //   height: height *.4,
                  //   width: 238,
                  //   child: AspectRatio(
                  //     aspectRatio: 1,
                  //     child:
                  //     CachedNetworkImage(
                  //       imageUrl: imagePath+imageUrl,
                  //       height: 50,
                  //       width: 70,
                  //       errorWidget: (_, __, ___) => Image.asset(
                  //         "assets/images/Image Popular Product 2.png",
                  //         fit: BoxFit.contain,
                  //         height: 50,
                  //         width: 50,
                  //       ),
                  //       placeholder: (_, __) => const SizedBox(),
                  //       fit: BoxFit.contain,
                  //     )
                  //     // Image.asset("assets/images/glap.png",),
                  //   ),
                  // ),
                  // addHeight(20),
                  // Center(
                  //   child: SizedBox(
                  //     height: 60,
                  //     child: ListView.builder(
                  //         scrollDirection: Axis.horizontal,
                  //         shrinkWrap: true,
                  //         itemCount: image.length,
                  //         itemBuilder: (context, index) {
                  //           final galleryImage = allImages[index];
                  //
                  //           return GestureDetector(
                  //             onTap: () {
                  //               imageUrl = galleryImage;
                  //               galleryIndex = index;
                  //               log(galleryIndex.toString());
                  //               setState(() {});
                  //             },
                  //             child: Container(
                  //               // padding: EdgeInsets.all(5),
                  //               margin: const EdgeInsets.all(5),
                  //               decoration: BoxDecoration(
                  //                   color: Colors.transparent,
                  //                   borderRadius: BorderRadius.circular(10),
                  //                   border: Border.all(
                  //                       color: galleryIndex == index
                  //                           ? AppThemeColor.buttonColor
                  //                           : Colors.transparent)),
                  //               child: CachedNetworkImage(
                  //                 imageUrl: imagePath + galleryImage,
                  //                 height: 50,
                  //                 width: 50,
                  //                 errorWidget: (_, __, ___) => Image.asset(
                  //                   "assets/images/Image Popular Product 2.png",
                  //                   fit: BoxFit.fitWidth,
                  //                   height: 50,
                  //                   width: 50,
                  //                 ),
                  //                 placeholder: (_, __) => const SizedBox(),
                  //                 fit: BoxFit.contain,
                  //               ),
                  //             ),
                  //           );
                  //         }),
                  //   ),
                  // ),

                  TopRoundedContainer(
                    color: Colors.white,
                    child: Column(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                productData != null
                                    ? productData['productname'] ?? ''
                                    : '',
                                style: const TextStyle(
                                    fontFamily: "IBM Plex Sans",
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16),
                              ),
                            ),
                            // addHeight(10),
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  variation.isNotEmpty?
                                  Row(
                                    children: [
                                      variation.isNotEmpty && variantPrice == ""
                                          ? Text(
                                              "R${variation[0]['price'].toString()}",

                                              style:  TextStyle(
                                                  fontSize: 20,
                                                  decoration: inventoryCheck == "0" || variationSalePrice != "" && variation[0]['saleprice'] != null ? TextDecoration.lineThrough:TextDecoration.none, // Strikethrough
                                                  decorationThickness: 3.0, // Thickness of the strikethrough line
                                                  decorationStyle: TextDecorationStyle.solid,
                                                  decorationColor: Colors.grey.shade500,
                                                  color: Colors.black,
                                                  fontFamily: "IBM Plex Sans",
                                                  fontWeight: FontWeight.w500),
                                            )
                                          : Text(
                                              "R${variantPrice}",
                                              style:  TextStyle(
                                                  decoration: inventoryCheck == "0" || variationSalePrice != "" && variation[0]['saleprice'] != null ?TextDecoration.lineThrough:TextDecoration.none, // Strikethrough
                                                  decorationThickness: 3.0, // Thickness of the strikethrough line
                                                  decorationStyle: TextDecorationStyle.solid,
                                                  decorationColor: Colors.grey.shade500,
                                                  fontSize: 20,
                                                  color: inventoryCheck == "0" || variationSalePrice != "" && variation[0]['saleprice'] != null ? Colors.grey: Colors.black,
                                                  fontFamily: "IBM Plex Sans",
                                                  fontWeight: FontWeight.w500),
                                            ),
                                      addWidth(10),
                                      if( variation.isNotEmpty)
                                      variationSalePrice == "" && variation[0]['saleprice'] != null?
                                      // if (variantPrice == "" || int.parse(variantPrice) < int.parse(variationSalePrice))
                                        Text(
                                          variationSalePrice == ""
                                              ? "R${variation[0]['saleprice'].toString()}"
                                              : "R${variationSalePrice}",
                                          style: const TextStyle(
                                              fontSize: 20,
                                              color: Colors.black,
                                              fontFamily: "IBM Plex Sans",
                                              fontWeight: FontWeight.w500),
                                        ):Text(
                                        variation[0]['saleprice'] != null ? "R${variationSalePrice}":"",
                                        style: const TextStyle(
                                            fontSize: 20,
                                            color: Colors.black,
                                            fontFamily: "IBM Plex Sans",
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ):Text(
                                    "R${productData['price'].toString()}",
                                    style: const TextStyle(
                                        fontSize: 20,
                                        color: Colors.black,
                                        fontFamily: "IBM Plex Sans",
                                        fontWeight: FontWeight.w500),
                                  ),

                                  // variantPrice == ""
                                  //     ? Text(
                                  //   "\$${variation[0]['price'].toString()}" ,
                                  //         // "\$${productData['minprice']} - \$${productData['maxprice']}",
                                  //         style: const TextStyle(
                                  //             fontSize: 20,
                                  //             color: Colors.black,
                                  //             fontFamily: "IBM Plex Sans",
                                  //             fontWeight: FontWeight.w500),
                                  //       )
                                  //     : Text(
                                  //         "\$${variantPrice}",
                                  //         style:  const TextStyle(
                                  //             fontSize: 20,
                                  //             color: Colors.black,
                                  //             fontFamily: "IBM Plex Sans",
                                  //             fontWeight: FontWeight.w500),
                                  //       ),
                                  // addWidth(10),
                                  // // if(int.parse(variantPrice)<int.parse(variationSalePrice))
                                  // // int.parse(variantPrice)<int.parse(variationSalePrice)?
                                  // Text(
                                  //   variationSalePrice == "" ? "\$${variation[0]['saleprice'].toString()}" :"\$${variationSalePrice}",
                                  //   style:  const TextStyle(
                                  //       fontSize: 20,
                                  //       color: Colors.black,
                                  //       fontFamily: "IBM Plex Sans",
                                  //       fontWeight: FontWeight.w500),
                                  // ),
                                  const Spacer(),
                                  RoundedIconBtn(
                                    icon: Icons.remove,
                                    press: () {
                                      decreaseCounter();
                                    },
                                  ),
                                  const SizedBox(width: 15),
                                  Text(counter.toString(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge),
                                  const SizedBox(width: 15),
                                  variation.isNotEmpty ?
                                  Container(
                                    height: 40,
                                    width: 40,
                                    decoration: const BoxDecoration(
                                      color: Colors.grey,
                                      shape: BoxShape.circle,
                                    ),
                                    child: TextButton(
                                      style: TextButton.styleFrom(
                                        foregroundColor: kPrimaryColor,
                                        padding: EdgeInsets.zero,
                                        backgroundColor:
                                            counter < variation[currentIndex]['inventory']
                                                ? AppThemeColor.buttonColor
                                                : Colors.grey,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(50)),
                                      ),
                                      onPressed: () {

                                        final List<dynamic> inventoryList =
                                            variation
                                                .map((variation) =>
                                                    variation['inventory']
                                                        .toString())
                                                .toList();
                                        print("INVENTORY LIST $inventoryList");
                                        if (counter <
                                            variation[currentIndex]['inventory']) {
                                          increseCounter();
                                        } else {
                                          print("Reached max inventory");
                                        }
                                      },
                                      child: const Icon(
                                        Icons.add,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ):Container(
                                    height: 40,
                                    width: 40,
                                    decoration: const BoxDecoration(
                                      color: Colors.grey,
                                      shape: BoxShape.circle,
                                    ),
                                    child: TextButton(
                                      style: TextButton.styleFrom(
                                        foregroundColor: kPrimaryColor,
                                        padding: EdgeInsets.zero,
                                        backgroundColor:
                                       AppThemeColor.buttonColor,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(50)),
                                      ),
                                      onPressed: () {
                                          increseCounter();
                                      },
                                      child: const Icon(
                                        Icons.add,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            addHeight(10),
                            productSize.isNotEmpty ?
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 5,
                              ),
                              //color: Colors.white,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: Text(
                                      "size",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium,
                                    ),
                                  ),
                                  addHeight(7),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: Row(
                                      children: [
                                        ...List.generate(productSize.length,
                                            (index) {
                                          final sizeData = productSize[index];
                                          final inventoryData =
                                              variation[index]['inventory'];
                                          final variationPrice =
                                              variation[index]['price'];
                                          final variantSalePrice =
                                              variation[index]['saleprice'];
                                          log("VARIATION SALE PRICE ${variationSalePrice.toString()}");
                                          bool isSelected = sizeIndex == index;

                                          return Row(
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  currentIndex = index;
                                                  counter = 1;
                                                  productVariantId =
                                                      variation[index]['id'];
                                                  log("PRODUCT VARIATION ID $productVariantId");
                                                  sizeIndex = index;
                                                  if (variation[index]
                                                          ['inventory'] !=
                                                      0) {
                                                    variantPrice =
                                                        variationPrice
                                                            .toString();
                                                    variationSalePrice =
                                                        variantSalePrice
                                                            .toString();
                                                  } else {
                                                    variantPrice = "";
                                                    productVariantId = "";
                                                  }

                                                  setState(() {});
                                                  log(variantPrice);
                                                },
                                                child: Stack(
                                                  children: [
                                                    Container(
                                                      height: 35,
                                                      width: 45,
                                                      margin: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 5,
                                                          vertical: 7),
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 5,
                                                          vertical: 8),
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  5),
                                                          color: inventoryData == 0
                                                              ? Colors.grey.shade100
                                                              : currentIndex == index
                                                                  ? AppThemeColor
                                                                      .buttonColor
                                                                  : Colors.white,
                                                          border: Border.all(
                                                              color: inventoryData ==
                                                                      0
                                                                  ? Colors
                                                                      .grey.shade300
                                                                  : currentIndex == index
                                                                      ? Colors
                                                                          .transparent
                                                                      : Colors
                                                                          .black12),
                                                          boxShadow: [
                                                            BoxShadow(
                                                              offset: const Offset(5, -15),
                                                              blurRadius: 20,
                                                              color: const Color(0xFFDADADA).withOpacity(0.15),
                                                            )
                                                          ],
                                                          shape:
                                                              BoxShape.rectangle),
                                                      child: Text(
                                                        sizeData['termname']
                                                            .toString(),
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(
                                                          decorationThickness: 2.0,
                                                            decorationStyle: TextDecorationStyle.solid,
                                                            fontFamily:
                                                                "IBM Plex Sans",
                                                            color: inventoryData ==
                                                                    0
                                                                ? Colors.black
                                                                : currentIndex == index
                                                                    ? Colors.white
                                                                    : Colors.black,
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w600),
                                                      ),
                                                    ),
                                                     Positioned(
                                                        top: 3,
                                                        left: 0,
                                                        child:
                                                        inventoryData == 0 ?
                                                        OutOfStockText(isOutOfStock: inventoryData == 0,):SizedBox())
                                                  ],
                                                ),
                                              ),
                                            ],
                                          );
                                        })
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ):SizedBox(),
                            addHeight(10),
                            productAttributes.isNotEmpty ?
                            Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: Text(
                                "Specification",
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ):SizedBox(),
                            addHeight(5),
                            productAttributes.isNotEmpty ?
                            SizedBox(
                              height: 300,
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: productAttributes.length,
                                  itemBuilder: (context, index) {
                                    final allAttributesList =
                                        productAttributes[index];
                                    final isVariationValue =
                                        productAttribute[index]['is_variation'];
                                    log("is variatoinnnnnnn $isVariationValue");
                                    final allAttributesTermList =
                                        productAttributesTermValue[index];

                                    return isVariationValue == 0
                                        ? Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 5, vertical: 5),
                                            decoration: const BoxDecoration(
                                              color: Colors.white,
                                              // boxShadow: [
                                              //
                                              //     BoxShadow(
                                              //       offset: Offset(1, 1),
                                              //       // blurRadius: 12,
                                              //       // color: Color.fromRGBO(0, 0, 0, 0.16),
                                              //     )
                                              // ]
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                // if (isVariationValue == 0)
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 15,
                                                      vertical: 5),
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        allAttributesList[
                                                                'attributename']
                                                            .toString(),
                                                        style: const TextStyle(
                                                            color: Color(
                                                                0xff697164),
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                      Spacer(),
                                                      Text(
                                                        allAttributesTermList[
                                                                'termname']
                                                            .toString(),
                                                        style: const TextStyle(
                                                            color:
                                                                Colors.black38,
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Divider()
                                              ],
                                            ),
                                          )
                                        : SizedBox();
                                  }),
                            ):SizedBox(),

                            addHeight(10),
                            showFullDescription == true
                                ? Padding(
                                    padding: const EdgeInsets.only(
                                      left: 20,
                                      right: 20,
                                    ),
                                    child: Html(
                                      data: productData != null
                                          ? productData['description'] ?? ''
                                          : '',
                                    ),
                                  )
                                : Padding(
                                    padding: const EdgeInsets.only(
                                      left: 20,
                                      right: 20,
                                    ),
                                    child: Text(
                                      productData != null
                                          ? productData['description']
                                                  .toString()
                                                  .replaceAll(
                                                      RegExp(r"<[^>]*>"), "") ??
                                              ''
                                          : '',
                                      maxLines: 4,
                                    ),
                                  ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 25,
                                vertical: 15,
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    showFullDescription = !showFullDescription;
                                  });
                                },
                                child: Row(
                                  children: [
                                    Text(
                                      showFullDescription == true
                                          ? "See less detail"
                                          : "See more details",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: AppThemeColor.buttonColor),
                                    ),
                                    const SizedBox(width: 5),
                                    const Icon(
                                      Icons.arrow_forward_ios,
                                      size: 12,
                                      color: kPrimaryColor,
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),

                        // TopRoundedContainer(
                        //   color: const Color(0xFFF6F7F9),
                        //   child: Column(
                        //     children: [
                        //       ColorDots(product: product),
                        //     ],
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
      bottomNavigationBar: TopRoundedContainer(
          color: Colors.white,
          child: Obx(() {
            return responseData.value == "Product added to cart successfully"
                ? SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: AppThemeColor.buttonColor),
                        onPressed: () async {
                          // Get.to(() => const CartScreen());
                        pushScreen(context, screen: CartScreen(),withNavBar: true);
                        },

                        child: const Text("View Cart"),
                      ),
                    ),
                  )
                : SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: AppThemeColor.buttonColor),
                        onPressed: () {
                          log("Hello${productVariantId}");
                          log("hhhhhh${inventoryCheck}");

                          if (productVariantId == "") {
                            final snackBar = CustomSnackbar.build(
                              message: "Please select the size",
                              backgroundColor: AppThemeColor.buttonColor,
                              // iconData: Icons.info_outline,
                              onPressed: () {
                                // Perform action on button press
                              },
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          } else {
                            addToCart();
                          }
                          // Navigator.pushNamed(context, CartScreen.routeName);
                        },
                        child: const Text("Add To Cart"),
                      ),
                    ),
                  );
          })),
    );
  }

  addToCart() async {
    final sessionIdController = Get.put(SessionController());
    SharedPreferences pref = await SharedPreferences.getInstance();
    LoginTokenModel? user =
        LoginTokenModel.fromJson(jsonDecode((pref.getString('auth_token')!)));
    // SessionModel? user =
    //     SessionModel.fromJson(jsonDecode(pref.getString('saved_data')!));
    int pId = int.parse(widget.productId);
    int pVId = int.parse(productVariantId);
    int cValue = counter;
    String sessionId = user.rememberToken.toString();
    // String sessionId = user.sessionId.toString();
    log("PRODUCT ID $pId");
    log("PRODUCT VARIANT ID $pVId");
    log("PRODUCT QTY $cValue");
    log("PRODUCT SESSION ID $sessionId");
    final MutationOptions options = MutationOptions(
      document: gql('''
      mutation AddCart(\$pId: Int!, \$cValue: Int!, \$pVId: Int! ,\$sessionId: String!) {
        addCart(
          product_id: \$pId, 
          qty: \$cValue, 
          productvariant_id: \$pVId
          sessionid: \$sessionId
        ) {
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
        'pId': pId,
        'cValue': cValue,
        'pVId': pVId,
        'sessionId': sessionId,
      },
    );

    final GraphQLClient client = GraphQLProvider.of(context).value;

    final QueryResult result = await client.mutate(options);

    if (result.hasException) {
      List<String> errorMessages = [];

      if (result.exception!.graphqlErrors.isNotEmpty) {
        errorMessages =
            result.exception!.graphqlErrors.map((e) => e.message).toList();
      }

      if (result.exception!.linkException != null) {
        errorMessages.add(result.exception!.linkException.toString());
      }
      print("ADD TO CART ERROR::::: $errorMessages");
      final snackBar = CustomSnackbar.build(
        message: errorMessages.toString(),
        backgroundColor: AppThemeColor.buttonColor,
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      final Map<String, dynamic>? addToCartData = result.data?['addCart'];
      if (addToCartData != null) {
        responseData.value = addToCartData['message'].toString();
        final List<dynamic> cartResponse = addToCartData['cart'];
        final List<Map<String, dynamic>> modifiedAaa =
            cartResponse.cast<Map<String, dynamic>>().map((item) {
          return Map<String, dynamic>.from(item)..remove('__typename');
        }).toList();

        if (modifiedAaa.isNotEmpty) {
          SharedPreferences cartLocalData =
              await SharedPreferences.getInstance();
          cartLocalData.setString('cart_data', jsonEncode(modifiedAaa));
          print(
              "CART DATA SAVED LOCALLY: ${cartLocalData.getString('cart_data')}");
        }
        // print("CART RESPONSE DATA $modifiedAaa");
        final snackBar = CustomSnackbar.build(
          message: addToCartData['message'].toString(),
          backgroundColor: AppThemeColor.buttonColor,
          onPressed: () {},
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        print('Add to cart error: Invalid response data');
      }
    }
  }
}

class OutOfStockText extends StatelessWidget {
  final bool isOutOfStock;

  const OutOfStockText({
    Key? key,
    required this.isOutOfStock,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        if (isOutOfStock)
          CustomPaint(
            size: Size(40,90), // Adjust the size as needed
            painter: DiagonalLinePainter(),
          ),
      ],
    );
  }
}

class DiagonalLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.shade300 // Color of the diagonal line
      ..strokeWidth = 2.0 // Thickness of the diagonal line
      ..strokeCap = StrokeCap.square;
    double lineHeightReductionFactor = 0.4;
    // Draw a diagonal line from top-left to bottom-right
    canvas.drawLine(Offset(12, 6), Offset(size.width, size.height * lineHeightReductionFactor), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

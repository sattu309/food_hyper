import 'dart:convert';
import 'dart:developer';
import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart'hide Badge;
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/helper/heigh_width.dart';
import '../../components/rounded_icon_btn.dart';
import '../../controllers/cart_controller.dart';
import '../../controllers/session_controller.dart';
import '../../controllers/wishlist_controller.dart';
import '../../helper/apptheme_color.dart';
import '../../helper/common_button.dart';
import '../../models/login_token_model.dart';
import '../cart/cart_screen.dart';
import '../home/components/search_field.dart';
import 'components/top_rounded_container.dart';

class DetailsScreen extends StatefulWidget {
  final String productId;
  final String productStatus;

  const DetailsScreen({
    super.key,
    required this.productId, required this.productStatus,
  });

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  final wishListController = Get.put(WishListController());
  final sessionController = Get.put(SessionController());
  final cartController = Get.put(CartController());
  String inventoryCheck = "";
  bool canVibrate = true;
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
  String variantRegularPrice = "";
  String variantSalePriceNew = "";
  String variantPrice = "";
  String variationSalePrice = "";
  String productVariantId = "";
  RxDouble sliderIndex = (0.0).obs;
  @override
  void initState() {
    super.initState();
   // soundVibrate();
    productDetails = """
query Product {
    product(id: "${widget.productId}", idType: DATABASE_ID) {
        productId
        averageRating
        databaseId
        description
        featured
        name
        onSale
        reviewCount
        reviewsAllowed
        shortDescription
        sku
        slug
        status
        type
        ... on VariableProduct {
            id
            name
            price
            regularPrice
            salePrice
            sku
            stockQuantity
            stockStatus
          averageRating
            variations {
                edges {
                    node {
                        id
                        name
                        databaseId
                        price
                        regularPrice
                        salePrice
                        attributes {
                            edges{
                                node{
                                    id
                                    attributeId
                                    name
                                    value
                                }
                            }
                        }
                    }
                }
            }
        }
        ... on SimpleProduct {
            id
            name
            price
            regularPrice
            salePrice
            stockStatus
        }
        ... on GroupProduct {
            id
            name
            price
            regularPrice
            salePrice
            products {
                edges {
                    node {
                        image {
                            sourceUrl
                        }
                        id
                        name
                        description
                        shortDescription
                        sku
                        ... on VariableProduct {
                            id
                            name
                            price
                            regularPrice
                            salePrice
                            sku
                        }
                        ... on SimpleProduct {
                            id
                            name
                            price
                            regularPrice
                            salePrice
                        }
                        ... on GroupProduct {
                            id
                            name
                            price
                            regularPrice
                            salePrice
                        }
                        ... on ExternalProduct {
                            id
                            name
                            price
                            regularPrice
                            salePrice
                        }
                    }
                }
            }
        }
        ... on ExternalProduct {
            id
            name
            price
            regularPrice
            salePrice
        }
        galleryImages {
            edges {
                node {
                    sourceUrl
                }
            }
        }
        featuredImage {
            node {
                sourceUrl
            }
        }
        related {
            edges {
                node {
                    id
                    databaseId
                    name
                    image {
                        sourceUrl
                    }
                    reviewCount
                    onSale
                    ... on VariableProduct {
                        id
                        name
                        price
                        regularPrice
                        salePrice
                        sku
                        stockStatus
                        averageRating
                    }
                    ... on SimpleProduct {
                        id
                        name
                        price
                        regularPrice
                        salePrice
                        stockStatus
                        averageRating
                    }
                    ... on GroupProduct {
                        id
                        name
                        price
                        regularPrice
                        salePrice
                    }
                    ... on ExternalProduct {
                        id
                        name
                        price
                        regularPrice
                        salePrice
                    }
                }
            }
        }
    }
}
    """;
  }
  int galleryIndex = 0;
  RxString responseData = "".obs;
  var rPrice = "";
  var sPrice = "";
  var pPrice = "";
  RxString image = "".obs;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 1,
        leadingWidth: 20,
        title: SearchField(),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(Icons.share,color: Colors.grey,size: 25,),
                addWidth(8),
                GestureDetector(
                  onTap: (){
                    pushScreen(context, screen:CartScreen(),withNavBar: true );
                  },
                  child: Badge(
                    badgeStyle: BadgeStyle(badgeColor: AppThemeColor.buttonColor,),
                    badgeContent:     Obx((){
                      return Text(cartController.cartCount.value,style: TextStyle(color: Colors.white),);}),
                    child: const Icon(Icons.shopping_bag_outlined,color: Colors.grey,size: 25,),
                  ),
                )
              ],
            ),
          )
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
            final galleryImages = productData?['galleryImages']['edges'] ?? [];
              image.value = productData['featuredImage']['node']['sourceUrl'];
            log("seprate iamges ${image}");
            // String imageUrl = '';
            // if (image != null && image['sourceUrl'] != null) {
            //   imageUrl = image['sourceUrl'];
            // }
            String disPercentage = '';
            String regularPriceStr = productData['regularPrice'] ?? '0';
            String salePriceStr = productData['salePrice'] ?? '0';

            if (salePriceStr != "0") {
              disPercentage = calDis(regularPriceStr, salePriceStr);
            }

            final variation = productData['variations']?['edges'] ?? "";
            if (variation != null && variation != "") {
              final defaultPrice = variation[0]['node'] ?? "";
              rPrice = defaultPrice['regularPrice'].toString();
              sPrice = defaultPrice['salePrice'].toString();
              pPrice = defaultPrice['price'].toString();
            }
            final relatedprduct = productData['related']?['edges'] ?? "";

            final productAttribute = productData['productattributes'];
            log("Product data $productData");
            log("Product Variation IS $variation");

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
            return
              SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      color: Colors.white,
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  productData != null
                                      ? productData['name'] ?? ''
                                      : '',
                                  textAlign: TextAlign.start,
                                  style: const TextStyle(
                                      fontFamily: "IBM Plex Sans",
                                      fontWeight: FontWeight.w600,
                                      fontSize: 17),
                                ),
                                addHeight(5),
                                if (productData['averageRating'] != null)
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 4,vertical: 2),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(7),
                                          color: productData['stockStatus'] == "OUT_OF_STOCK" ? Colors.red.withOpacity(.10):Colors.green.withOpacity(.10)
                                        ),
                                        child: Text(
                                          productData['stockStatus'] == "OUT_OF_STOCK" ?
                                         "OUT OF STOCK" :"IN STOCK",
                                          textAlign: TextAlign.start,
                                          style:  TextStyle(
                                              fontFamily: "IBM Plex Sans",
                                              fontWeight: FontWeight.w400,
                                              color: productData['stockStatus'] == "OUT_OF_STOCK" ? Colors.red: Colors.green,
                                              fontSize: 10),
                                        ),
                                      ),
                                      addWidth(10),
                                      Row(children: [
                                        ...List.generate(productData['averageRating'],
                                                (index) {
                                              return SingleChildScrollView(
                                                scrollDirection: Axis.vertical,
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.star,
                                                      color: Colors.yellow.shade600,
                                                      size: 17,
                                                    ),
                                                  ],
                                                ),
                                              );
                                            }),
                                        addWidth(3),
                                        Text(
                                          "${productData['reviewCount']}",
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontFamily: "IBM Plex Sans",
                                            fontWeight: FontWeight.w700,
                                            color: Colors.black38,
                                          ),
                                        ),
                                      ]),
                                    ],
                                  ),
                                Obx((){
                                  return Center(
                                    child: SizedBox(
                                      height: height * .3,
                                      width: 238,
                                      child: AspectRatio(
                                          aspectRatio: 1,
                                          child: CachedNetworkImage(
                                            imageUrl: image.value,
                                            height: 50,
                                            width: 70,
                                            errorWidget: (_, __, ___) => const SizedBox(),
                                            placeholder: (_, __) => const SizedBox(),
                                            fit: BoxFit.contain,
                                          )
                                        // Image.asset("assets/images/glap.png",),
                                      ),
                                    ),
                                  );
                                }),

                                // addHeight(20),
                                Center(
                                  child: SizedBox(
                                    height: 60,
                                    child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        shrinkWrap: true,
                                        itemCount: galleryImages.length,
                                        itemBuilder: (context, index) {
                                          final galleryImage = galleryImages[index]
                                                  ['node']['sourceUrl'] ?? '';
                                          log("GALLERY LIST ${galleryImage}");
                                          return GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                image.value = galleryImage;
                                                galleryIndex = index;
                                              });
                                              log("IMAGE URL $image");

                                            },
                                            child: Container(
                                              // padding: EdgeInsets.all(5),
                                              margin: const EdgeInsets.all(5),
                                              decoration: BoxDecoration(
                                                  color: Colors.transparent,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  border: Border.all(
                                                      color: galleryIndex == index
                                                          ? AppThemeColor
                                                              .buttonColor
                                                          : Colors.transparent)),
                                              child: CachedNetworkImage(
                                                imageUrl: galleryImage,
                                                height: 50,
                                                width: 50,
                                                errorWidget: (_, __, ___) =>
                                                    SizedBox(),
                                                placeholder: (_, __) =>
                                                    const SizedBox(),
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                          );
                                        }),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          (disPercentage != '')
                              ? Positioned(
                                  top: height*.09,
                                  left: 13,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 5, vertical: 3),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: AppThemeColor.buttonColor),
                                    child: Text(disPercentage + '%',
                                        maxLines: 1,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: CupertinoColors.white,
                                            fontSize: 13)),
                                  ))
                              : SizedBox()
                        ],
                      ),
                    ),

                    TopRoundedContainer(
                      color: Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Text(
                                //   productData != null
                                //       ? productData['name'] ?? ''
                                //       : '',
                                //   style: const TextStyle(
                                //       fontFamily: "IBM Plex Sans",
                                //       fontWeight: FontWeight.w600,
                                //       fontSize: 17),
                                // ),
                                // addHeight(5),
                                // if (productData['averageRating'] != null)
                                //   Row(children: [
                                //     ...List.generate(productData['averageRating'],
                                //         (index) {
                                //       return SingleChildScrollView(
                                //         scrollDirection: Axis.vertical,
                                //         child: Row(
                                //           children: [
                                //             Icon(
                                //               Icons.star,
                                //               color: Colors.yellow.shade600,
                                //               size: 17,
                                //             ),
                                //           ],
                                //         ),
                                //       );
                                //     }),
                                //     addWidth(3),
                                //     Text(
                                //       "${productData['reviewCount']}",
                                //       style: const TextStyle(
                                //         fontSize: 16,
                                //         fontFamily: "IBM Plex Sans",
                                //         fontWeight: FontWeight.w700,
                                //         color: Colors.black38,
                                //       ),
                                //     ),
                                //   ]),
                                // addHeight(10),
                                productData['type'] == "VARIABLE"
                                    ? Row(
                                        children: [
                                          (variantSalePriceNew != "0")
                                              ? Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    // addWidth(8),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          productVariantId == ""
                                                              ? rPrice
                                                              : variantRegularPrice,
                                                          style: TextStyle(
                                                            fontSize: 15,
                                                            fontFamily:
                                                                "IBM Plex Sans",
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            decoration:
                                                                TextDecoration
                                                                    .lineThrough,
                                                            decorationStyle:
                                                                TextDecorationStyle
                                                                    .solid,
                                                            color: Colors
                                                                .grey.shade400,
                                                          ),
                                                        ),
                                                        addWidth(5),
                                                        Text(
                                                          productVariantId == ""
                                                              ? sPrice
                                                              : variantSalePriceNew,
                                                          style: TextStyle(
                                                            fontSize: 18,
                                                            fontFamily:
                                                                "IBM Plex Sans",
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            color: AppThemeColor
                                                                .buttonColor,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                )
                                              : Text(
                                                  productVariantId == ""
                                                      ? rPrice
                                                      : variantPrice,
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    fontFamily: "IBM Plex Sans",
                                                    fontWeight: FontWeight.w700,
                                                    color:
                                                        AppThemeColor.buttonColor,
                                                  ),
                                                ),
                                        ],
                                      )
                                    :
                                Row(
                                        children: [
                                          (salePriceStr != "0")
                                              ? Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    // addWidth(8),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          regularPriceStr,
                                                          style: TextStyle(
                                                            fontSize: 15,
                                                            fontFamily:
                                                                "IBM Plex Sans",
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            decoration:
                                                                TextDecoration
                                                                    .lineThrough,
                                                            decorationStyle:
                                                                TextDecorationStyle
                                                                    .solid,
                                                            color: Colors
                                                                .grey.shade400,
                                                          ),
                                                        ),
                                                        addWidth(5),
                                                        Text(
                                                          salePriceStr,
                                                          style: TextStyle(
                                                            fontSize: 18,
                                                            fontFamily:
                                                                "IBM Plex Sans",
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            color: AppThemeColor
                                                                .buttonColor,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                )
                                              : Text(
                                                  productData['price'],
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    fontFamily: "IBM Plex Sans",
                                                    fontWeight: FontWeight.w700,
                                                    color:
                                                        AppThemeColor.buttonColor,
                                                  ),
                                                ),
                                        ],
                                      ),
                                addHeight(10),
                                productData['type'] == "VARIABLE"
                                    ? Container(
                                        //color: Colors.white,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "size",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium,
                                            ),
                                            addHeight(7),
                                            Row(
                                              children: [
                                                ...List.generate(variation.length,
                                                    (index) {
                                                  var varItem =
                                                      variation[index]['node'];
                                                  log("Attribute Values: ${varItem['databaseId']}");
                                                  var attributes =
                                                      varItem['attributes']
                                                          ['edges'];
                                                  var sizeData = attributes
                                                      .map((e) =>
                                                          e['node']['value'])
                                                      .toList();
                                                  log("Attribute Values: $sizeData");
                                                  final inventoryData =
                                                      variation[index]
                                                          ['inventory'];
                                                  final variationPrice =
                                                      variation[index]['price'];
                                                  final variantSalePrice =
                                                      variation[index]
                                                          ['saleprice'];
                                                  log("VARIATION SALE PRICE ${variationSalePrice.toString()}");

                                                  return Row(
                                                    children: [
                                                      GestureDetector(
                                                        onTap: () {
                                                          currentIndex = index;
                                                          counter = 1;
                                                          productVariantId =
                                                              varItem['databaseId']
                                                                  .toString();
                                                          log("PRODUCT VARIATION ID $productVariantId");
                                                          variantRegularPrice =
                                                              varItem['regularPrice']
                                                                  .toString();
                                                          variantSalePriceNew =
                                                              varItem['salePrice']
                                                                  .toString();
                                                          variantPrice =
                                                              varItem['price']
                                                                  .toString();
                                                          log("PRODUCT VARIATION REGULAR  $variantRegularPrice");
                                                          log("PRODUCT VARIATION SALE  $variantSalePriceNew");
                                                          log("PRODUCT VARIATION PRICE  $variantPrice");

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
                                                              width: 65,
                                                              margin:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          5,
                                                                      vertical:
                                                                          7),
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          5,
                                                                      vertical:
                                                                          8),
                                                              decoration:
                                                                  BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius
                                                                              .circular(
                                                                                  5),
                                                                      color: currentIndex ==
                                                                              index
                                                                          ? AppThemeColor
                                                                              .buttonColor
                                                                          : Colors
                                                                              .white,
                                                                      border: Border.all(
                                                                          color: inventoryData == 0
                                                                              ? Colors.grey.shade300
                                                                              : currentIndex == index
                                                                                  ? Colors.transparent
                                                                                  : Colors.black12),
                                                                      boxShadow: [
                                                                        BoxShadow(
                                                                          offset: const Offset(
                                                                              5,
                                                                              -15),
                                                                          blurRadius:
                                                                              20,
                                                                          color: const Color(0xFFDADADA)
                                                                              .withOpacity(0.15),
                                                                        )
                                                                      ],
                                                                      shape: BoxShape.rectangle),
                                                              child: Text(
                                                                sizeData
                                                                    .join(', '),
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: TextStyle(
                                                                    decorationThickness:
                                                                        2.0,
                                                                    decorationStyle:
                                                                        TextDecorationStyle
                                                                            .solid,
                                                                    fontFamily:
                                                                        "IBM Plex Sans",
                                                                    color: inventoryData ==
                                                                            0
                                                                        ? Colors
                                                                            .black
                                                                        : currentIndex ==
                                                                                index
                                                                            ? Colors
                                                                                .white
                                                                            : Colors
                                                                                .black,
                                                                    fontSize: 14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600),
                                                              ),
                                                            ),
                                                            Positioned(
                                                                top: 3,
                                                                left: 0,
                                                                child: inventoryData ==
                                                                        0
                                                                    ? OutOfStockText(
                                                                        isOutOfStock:
                                                                            inventoryData ==
                                                                                0,
                                                                      )
                                                                    : SizedBox())
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                })
                                              ],
                                            ),
                                          ],
                                        ),
                                      )
                                    : SizedBox(),
                                productData['type'] == "VARIABLE"
                                    ? addHeight(10)
                                    : SizedBox(),
                                productAttributes.isNotEmpty
                                    ? Padding(
                                        padding: const EdgeInsets.only(left: 20),
                                        child: Text(
                                          "Specification",
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge,
                                        ),
                                      )
                                    : SizedBox(),
                                addHeight(5),
                                addHeight(10),
                                showFullDescription == true
                                    ? Html(
                                        data: productData != null
                                            ? productData['description'] ?? ''
                                            : '',
                                      )
                                    : Text(
                                        productData != null
                                            ? productData['description']
                                                    .toString()
                                                    .replaceAll(
                                                        RegExp(r"<[^>]*>"), "") ??
                                                ''
                                            : '',
                                        maxLines: 4,
                                      ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    // horizontal: 25,
                                    vertical: 10,
                                  ),
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        showFullDescription =
                                            !showFullDescription;
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
                                        Icon(
                                          Icons.arrow_forward_ios,
                                          size: 12,
                                          color: AppThemeColor.buttonColor,
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    addHeight(20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "RELATED PRODUCTS",
                          style: TextStyle(
                              fontFamily: "IBM Plex Sans",
                              fontWeight: FontWeight.w600,
                              fontSize: 16),
                        ),
                        SizedBox(
                          height: 300,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemCount: relatedprduct.length,
                              itemBuilder: (BuildContext, index) {
                                String disPercentage = '';
                                final relatedProductData =
                                    relatedprduct[index]['node'];
                                // log("TYPEOF ${relatedProductData[
                                // 'stockStatus']}");
                                final image = relatedProductData['image'];
                                String imageUrl = '';
                                if (image != null && image['sourceUrl'] != null) {
                                  imageUrl = image['sourceUrl'];
                                }
                                String regularPriceStr =
                                    relatedProductData['regularPrice'] ?? '0';
                                String salePriceStr =
                                    relatedProductData['salePrice'] ?? '0';

                                if (salePriceStr != "0") {
                                  disPercentage =
                                      calDis(regularPriceStr, salePriceStr);
                                }
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => DetailsScreen(
                                                productId: relatedProductData[
                                                        'databaseId']
                                                    .toString(), productStatus: relatedProductData[
                                          'stockStatus'],
                                              )),
                                    );
                                    log("PRODUCT ID of category product ${relatedProductData['databaseId'].toString()}");
                                    // Get.to(()=> DetailsScreen(productId: productsData['id'],));
                                    // pushScreen(context,
                                    //     screen:  DetailsScreen(productId: relatedProductData['databaseId'].toString(),), withNavBar: true);
                                    //
                                  },
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      addHeight(10),
                                      Stack(
                                        children: [
                                          Container(
                                              height: 290,
                                              width: width * .5,
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 10,
                                              ),
                                              margin: const EdgeInsets.symmetric(
                                                horizontal: 6,
                                              ),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(7),
                                                boxShadow: [
                                                  BoxShadow(
                                                    offset: const Offset(0, -16),
                                                    blurRadius: 20,
                                                    color: const Color(0xFFDADADA)
                                                        .withOpacity(0.15),
                                                  )
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
                                                      placeholder: (_, __) =>
                                                          Container(
                                                        color:
                                                            Colors.grey.shade200,
                                                      ),
                                                    ),
                                                  ),
                                                  // const SizedBox(height: 3),
                                                  Text(relatedProductData['name'],
                                                      maxLines: 1,
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: CupertinoColors
                                                              .black,
                                                          fontSize: 14)),
                                                  addHeight(3),
                                                  Text(
                                                      relatedProductData[
                                                                  'stockStatus'] ==
                                                              "IN_STOCK"
                                                          ? "INSTOCK"
                                                          : "OUT OF STOCK",
                                                      maxLines: 1,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: relatedProductData[
                                                                      'stockStatus'] ==
                                                                  "IN_STOCK"
                                                              ? Colors.green
                                                              : Colors.red,
                                                          fontSize: 10)),
                                                  addHeight(3),
                                                  if (relatedProductData[
                                                          'averageRating'] !=
                                                      null)
                                                    Row(children: [
                                                      ...List.generate(
                                                          relatedProductData[
                                                              'averageRating'],
                                                          (index) {
                                                        return SingleChildScrollView(
                                                          scrollDirection:
                                                              Axis.vertical,
                                                          child: Row(
                                                            children: [
                                                              Icon(
                                                                Icons.star,
                                                                color: Colors
                                                                    .yellow
                                                                    .shade600,
                                                                size: 17,
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                      }),
                                                      addWidth(3),
                                                      Text(
                                                        "${relatedProductData['reviewCount']}",
                                                        style: const TextStyle(
                                                          fontSize: 16,
                                                          fontFamily:
                                                              "IBM Plex Sans",
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          color: Colors.black38,
                                                        ),
                                                      ),
                                                    ]),
                                                  addHeight(2),
                                                  (salePriceStr != "0")
                                                      ? Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [

                                                            // addWidth(8),
                                                            Row(
                                                              children: [
                                                                Expanded(
                                                                  child: Text(
                                                                    regularPriceStr,
                                                                    style: TextStyle(
                                                                      fontSize: 15,
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
                                                                Expanded(
                                                                  child: Text(
                                                                    salePriceStr,
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize: 15,
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
                                                          relatedProductData[
                                                              'price'],
                                                          style: TextStyle(
                                                            fontSize: 15,
                                                            fontFamily:
                                                                "IBM Plex Sans",
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            color: AppThemeColor
                                                                .buttonColor,
                                                          ),
                                                        ),
                                                  addHeight(5),
                                                  productData['type'] =="SIMPLE" ?
                                                  Container(
                                                    height: 25,
                                                    alignment: Alignment.centerRight,
                                                    width: width * .5,
                                                    child: ElevatedButton(
                                                      style: ElevatedButton.styleFrom(

                                                        shape: RoundedRectangleBorder(),
                                                        backgroundColor: AppThemeColor.buttonColor,
                                                      ),
                                                      onPressed: () async {
                                                        wishListController.addToCart(
                                                            productData['databaseId'],
                                                            0,
                                                            1,
                                                            context);
                                                        cartController.getCartDataLocally();
                                                      },
                                                      child: const Text("ADD TO CART",style: TextStyle(fontWeight: FontWeight.w400,fontSize: 10),),
                                                    ),
                                                  ):
                                                  Container(
                                                    height: 25,
                                                    alignment: Alignment.centerRight,
                                                    width: width * .5,
                                                    child: ElevatedButton(
                                                      style: ElevatedButton.styleFrom(

                                                        shape: RoundedRectangleBorder(),
                                                        backgroundColor: AppThemeColor.buttonColor,
                                                      ),
                                                      onPressed: () async {
                                                        pushScreen(context,
                                                            screen:  DetailsScreen(productId: productData['databaseId'].toString(), productStatus: productData['stockStatus'],), withNavBar: true);
                                                      },
                                                      child: const Text("VIEW OPTION",style: TextStyle(fontWeight: FontWeight.w400,fontSize: 10),),
                                                    ),
                                                  ),
                                                ],
                                              )
                                              //
                                              // Image.asset("assets/images/glap.png",),
                                              ),
                                          (disPercentage != '')
                                              ? Positioned(
                                                  top: 12,
                                                  left: 10,
                                                  child: Container(
                                                    padding: EdgeInsets.symmetric(
                                                        horizontal: 5,
                                                        vertical: 3),
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                5),
                                                        color: AppThemeColor
                                                            .buttonColor),
                                                    child: Text(
                                                        disPercentage + '%',
                                                        maxLines: 1,
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: CupertinoColors
                                                                .white,
                                                            fontSize: 13)),
                                                  ))
                                              : SizedBox()
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              }),
                        )
                      ],
                    )
                  ],
                ),
              ),
            );
          }),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(
          bottom: 50,
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 15,
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
              Row(
                children: [
                  RoundedIconBtn(
                    icon: Icons.remove,
                    press: () {
                      decreaseCounter();
                    },
                  ),
                  const SizedBox(width: 15),
                  Text(counter.toString(),
                      style: Theme.of(context).textTheme.bodyLarge),
                  const SizedBox(width: 15),
                  RoundedIconBtn(
                    icon: Icons.add,
                    press: () {
                      widget.productStatus == "OUT_OF_STOCK" ? null:
                      increseCounter();
                    },
                  ),
                  Spacer(),
                  Container(
                    height: 40,
                    alignment: Alignment.centerRight,
                    width: width * .5,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                          widget.productStatus == "OUT_OF_STOCK" ? Colors.grey :AppThemeColor.buttonColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30))),
                      onPressed: () async {
                        widget.productStatus == "OUT_OF_STOCK" ? "" :addToCart();




                      },
                      child:  Text("Add to cart",),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String calDis(String regPrice, String salePrice) {
    bool isVar = regPrice.contains(' - ');
    double disCount = 0;

    if (isVar) {
      List<String> regPrices = regPrice.split(' - ');
      List<String> salePrices = salePrice.split(' - ');

      // Parsing the string prices to double
      double regPriceMin =
          double.parse(regPrices[0].replaceAll(RegExp(r'[^\d.]'), ''));
      double salePriceMin =
          double.parse(salePrices[0].replaceAll(RegExp(r'[^\d.]'), ''));

      disCount = ((regPriceMin - salePriceMin) / regPriceMin) * 100;
    } else {
      // Parsing the string prices to double
      double regPriceValue =
          double.parse(regPrice.replaceAll(RegExp(r'[^\d.]'), ''));
      double salePriceValue =
          double.parse(salePrice.replaceAll(RegExp(r'[^\d.]'), ''));

      disCount = ((regPriceValue - salePriceValue) / regPriceValue) * 100;
    }

    return (disCount.toInt()).toString();
  }

  late GraphQLClient client;
  void initializeClient() {
    final HttpLink httpLink = HttpLink(
      'https://wpdemo.bitlogiq.co.za/graphql',
      defaultHeaders: {
        'Authorization': 'Bearer ${sessionController.sessionId.value}',
      },
    );

    client = GraphQLClient(
      cache: GraphQLCache(store: InMemoryStore()),
      link: httpLink,
    );
  }

  addToCart() async {
    initializeClient();
    SharedPreferences pref = await SharedPreferences.getInstance();
    LoginTokenModel? user =
        LoginTokenModel.fromJson(jsonDecode((pref.getString('auth_token')!)));
    int pId = int.parse(widget.productId);
    int? pVId = int.tryParse(productVariantId);
    int cValue = counter;
    String sessionId = user.authToken.toString();
    log("PRODUCT ID $pId");
    log("PRODUCT VARIANT ID $pVId");
    log("PRODUCT QTY $cValue");
    log("PRODUCT SESSION ID $sessionId");
    final MutationOptions options = MutationOptions(
      document: gql('''
      mutation AddToCart(\$input: AddToCartInput!) {
        addToCart(
        input:\$input ) {
            cart {
                subtotal
                total
                shippingTotal
                contents {
                    itemCount
                    nodes {
                        product {
                            node {
                                name
                                sku
                                databaseId
                                productId
                                image{
                                    sourceUrl
                                }
                                ... on VariableProduct {
                                    databaseId
                                    name
                                    price
                                    type
                                    regularPrice
                                    salePrice
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
                                key
                                quantity
                                subtotal
                                subtotalTax
                                total
                                tax
                                variation {
                                node {
                                databaseId
                                name
                                price
                                regularPrice
                                salePrice
                                attributes{
                                    edges{
                                        node{
                                            value
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    '''),
      variables: {
        'input': {
          'productId': pId,
          'quantity': cValue,
          'variationId': pVId,

          // 'pVId': pVId,
        },
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
      // final snackBar = CustomSnackbar.build(
      //   message: errorMessages.toString(),
      //   backgroundColor: AppThemeColor.buttonColor,
      // );
      //
      // ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      final Map<String, dynamic>? addToCartData = result.data?['addToCart'];
      log("RESULT ADD TO CART${result}");
      if (addToCartData != null) {
        SharedPreferences cartLocalData =
              await SharedPreferences.getInstance();
          cartLocalData.setString('cart_data', jsonEncode(addToCartData['cart']));
          cartController.getCartDataLocally();
        showAddToCartPopup(context, "Item added to cart!");
        // }
      } else {
        print('Add to cart error: Invalid response data');
      }
    }
  }
}

Map<String, dynamic> removeTypename(Map<String, dynamic> json) {
  final Map<String, dynamic> cleanedJson = {};
  json.forEach((key, value) {
    if (key != '__typename') {
      if (value is Map<String, dynamic>) {
        cleanedJson[key] = removeTypename(value);
      } else if (value is List) {
        cleanedJson[key] = value.map((item) {
          if (item is Map<String, dynamic>) {
            return removeTypename(item);
          }
          return item;
        }).toList();
      } else {
        cleanedJson[key] = value;
      }
    }
  });
  return cleanedJson;
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
            size: Size(40, 90), // Adjust the size as needed
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
    canvas.drawLine(Offset(12, 6),
        Offset(size.width, size.height * lineHeightReductionFactor), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

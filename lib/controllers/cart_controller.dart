import 'dart:convert';

import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/controllers/session_controller.dart';
import '../models/cart_model_common.dart';

class CartController extends GetxController{
  final sessionController = Get.put(SessionController());
  RxString totalAmt = "0".obs;
  RxString cartCount = "0".obs;
  var cartItems = <CartOwnModel>[].obs;



  var cartData = [].obs;
  Future<void> getCartDataLocally() async {
    SharedPreferences cartLocalData = await SharedPreferences.getInstance();
  print(cartLocalData.getString('cart_data').toString());
    final Map<String,dynamic> cartDataString = jsonDecode(cartLocalData.getString('cart_data').toString());

    if (cartDataString.isNotEmpty) {
      try {
        // cartItems.value = cartDataString['contents']['itemCount'];
        // log("ITEM COUNT$cartItems");
        var rawCartData = cartDataString['contents']['nodes'];
        totalAmt.value = cartDataString['total'];
        cartCount.value = cartDataString['contents']['itemCount'].toString();
        cartData.value = rawCartData;

      } catch (e) {
        print("Error decoding cart data: $e");
      }
    } else {
      print("Cart data is null or empty");
    }
  }
  late GraphQLClient client;
  void initializeClient() {

    final HttpLink httpLink = HttpLink('https://wpdemo.bitlogiq.co.za/graphql', defaultHeaders: {
      'Authorization': 'Bearer ${sessionController.sessionId.value}',
    },
    );
    client = GraphQLClient(
      cache: GraphQLCache(store: InMemoryStore()),
      link: httpLink,

    );

  }
//   void fetchCartData() async {
//     initializeClient();
//     const fetchCartData = """
//   query Cart {
//     cart {
//         subtotal
//         total
//         shippingTotal
//         contents {
//             itemCount
//             nodes {
//                 product {
//                     node {
//                         name
//                         sku
//                         databaseId
//                         productId
//                         image{
//                             sourceUrl
//                         }
//                             ... on VariableProduct {
//                                 databaseId
//                                 name
//                                 price
//                                 type
//                             }
//                             ... on SimpleProduct {
//                                 databaseId
//                                 name
//                                 price
//                                 type
//                             }
//                     }
//                 }
//                 key
//                 quantity
//                 subtotal
//                 subtotalTax
//                 total
//                 tax
//                 variation {
//                     node {
//                         databaseId
//                         name
//                         price
//                         regularPrice
//                         salePrice
//                                attributes{
//                                 edges{
//                                     node{
//                                          value
//                                     }
//                                 }
//                             }
//                     }
//                 }
//             }
//         }
//     }
// }
//
//    """;
//     QueryOptions options = QueryOptions(
//       document: gql(fetchCartData),
//     );
//     final QueryResult result = await client.query(options);
//
//     if (result.hasException) {
//       print('GraphQL Error: ${result.exception.toString()}');
//     } else {
//       // print('GraphQL Response: ${result.data}');
//       // print('GraphQL Response: ${result.data!['cart']['contents']['nodes']}');
//       if(result.data?['cart']['contents']['nodes'] != null && result.data?['cart']['contents']['nodes'].isNotEmpty){
//         print('GraphQL Response: ${result.data}');
//         var cart = result.data?['cart'];
//          totalAmt.value = cart['total'];
//             print('GraphQL Response: ${result.data!['cart']['contents']['nodes']}');
//         var rawCartData = result.data?['cart']['contents']['nodes'];
//
//         cartData.value = rawCartData;
//
//         log("NEW UPDATED CART DATA ${cartData}");
//       }else{
//         log("NEW UPDATED CART DATA NULL");
//       }
//
//     }
//
//   }


  @override
  void onInit() {
    super.onInit();
    initializeClient();
    // fetchCartData();
     getCartDataLocally();
  }
}
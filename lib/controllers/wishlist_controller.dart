import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../helper/apptheme_color.dart';
import '../helper/custom_snackbar.dart';

class WishListController extends GetxController{
  var wishlist = [].obs;
  List<String> getFavIds = [];
  Future<void> addWishList(String productId, String token, context) async {
    final MutationOptions options = MutationOptions(
      document: gql('''
   mutation AddWishlist(\$productId: ID!,){
    addWishlist(product_id: \$productId,) {
        message
        }
     }
  '''),
          variables: {
             'productId': productId,
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
      print("ADD WISHLIST ERROR::::: $errorMessages");
      final snackBar = CustomSnackbar.build(
        message: errorMessages.toString(),
        backgroundColor: AppThemeColor.buttonColor,
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      final Map<String, dynamic>? wishListData = result.data?['addWishlist'];
      if (wishListData != null) {
        final snackBar = CustomSnackbar.build(
          message: wishListData['message'].toString(),
          backgroundColor: AppThemeColor.buttonColor,
          onPressed: () {},

        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        print('wishlist graphql: Invalid response data');
      }
    }
  }

  Future<void> removeWishListData(String id,context) async {
    final MutationOptions options = MutationOptions(
      document: gql('''
   mutation RemoveList(\$id: ID!){
    removeList(id: \$id) {
        message
        }
     }
  '''),
      variables: {
        'id': id,
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
      print("REMOVE  WISHLIST ERROR::::: $errorMessages");
      final snackBar = CustomSnackbar.build(
        message: errorMessages.toString(),
        backgroundColor: AppThemeColor.buttonColor,
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      final Map<String, dynamic>? wishListData = result.data?['removeList'];
      if (wishListData != null) {
        fetchWishlist();
        log(wishListData.toString());
        final snackBar = CustomSnackbar.build(
          message: wishListData['message'].toString(),
          backgroundColor: AppThemeColor.buttonColor,
          onPressed: () {},
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        print('wishlist graphql: Invalid response data');
      }
    }
  }


  RxBool isLoading = false.obs;

  void initializeClient() {
    final HttpLink httpLink = HttpLink( 'https://ctshop.ssspl.net/graphql/');

    client = GraphQLClient(
      cache: GraphQLCache(store: InMemoryStore()),
      link: httpLink,
    );
  }

  late GraphQLClient client;

   Future<void> fetchWishlist() async {
     initializeClient();
     const String fetchFavProducts = """
    query Wishlist {
      getwishlist {
        id
        users_id
        product_id
        productname
        slug
        image
        minprice
        maxprice
      }
    }
  """;
   QueryOptions options = QueryOptions(
      document: gql(fetchFavProducts),
    );

    final result = await client.query(options);

    if (result.hasException) {
      print(result.exception.toString());
    } else {
      if(result.data?['getwishlist'] != null && result.data?['getwishlist'].isNotEmpty) {
        wishlist.value = result.data?['getwishlist'];
        for (var item in wishlist) {
          getFavIds.add(item['product_id']);
        }
        log("favorite IDs: $getFavIds");
      }

      log("wish list data ${wishlist.toString()}");
    }

  }

  @override
  void onInit() {
    super.onInit();
    initializeClient();
    fetchWishlist();
  }
}


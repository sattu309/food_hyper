import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/CartDataLocalModel.dart';

class CartController extends GetxController{
  RxString totalAmt = "0".obs;
  var cartItems = <CartItem>[].obs;
  Future<void> getCartDataLocally() async {
    SharedPreferences cartLocalData = await SharedPreferences.getInstance();
    String? cartDataString = cartLocalData.getString('cart_data');

    if (cartDataString != null && cartDataString.isNotEmpty) {
      try {
        List<dynamic> cartDataList = jsonDecode(cartDataString);
        cartItems.value =
            cartDataList.map((item) => CartItem.fromJson(item)).toList();
        totalAmt.value = calculateTotalAmount(cartItems).toString();
        print(cartItems.length);
      } catch (e) {
        print("Error decoding cart data: $e");
      }
    } else {
      print("Cart data is null or empty");
    }
  }
  int calculateTotalAmount(List<CartItem> cartItems) {
    int total = 0;
    for (var item in cartItems) {
      total += int.parse(item.amount.toString());
    }
    return total;
  }


  @override
  void onInit() {
    super.onInit();
     getCartDataLocally();
  }
}
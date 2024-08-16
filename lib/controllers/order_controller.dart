import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderController extends GetxController{
  final fNameController = TextEditingController();
  final lNameController = TextEditingController();
  final address1Controller = TextEditingController();
  final address2Controller = TextEditingController();
  final cityController = TextEditingController();
  final zipCodeController = TextEditingController();
  final stateController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final countryController = TextEditingController();
  Future<void> getCheckoutData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? checkOutDataString = pref.getString('checkOutData');

    if (checkOutDataString != null && checkOutDataString.isNotEmpty) {
      log("Raw checkout data from SharedPreferences: $checkOutDataString");

      try {
        final Map<String, dynamic> checkOutData = jsonDecode(checkOutDataString);

        if (checkOutData.isNotEmpty) {
          var rawCartData = checkOutData;
          log("CHECKOUT LOCAL DATA: $rawCartData");
          // for (var order in rawCartData) {
            var shipping = rawCartData['shipping'];

            fNameController.text = shipping['firstName'];
            lNameController.text = shipping['lastName'];
            address1Controller.text = shipping['address1'];
            address2Controller.text = shipping['address2'];
            cityController.text = shipping['city'];
            zipCodeController.text = shipping['postcode'];
            stateController.text = shipping['state'];
            emailController.text = shipping['email'];
            phoneController.text = shipping['phone'];
            countryController.text = shipping['country'];

          // }
        } else {
          print("Checkout data is empty after decoding.");
        }
      } catch (e) {
        print("Error decoding checkout data: $e");
      }
    } else {
      print("No checkout data found in SharedPreferences.");
    }
  }

  @override
  void onInit() {
    super.onInit();
    getCheckoutData();
  }
}
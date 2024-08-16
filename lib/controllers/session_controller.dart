import 'dart:convert';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:random_string/random_string.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/login_token_model.dart';

class SessionController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController lastController = TextEditingController();
  RxString sessionId = ''.obs;
  RxString userId = ''.obs;

  // Future<void> getSessionId() async {
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   SessionModel? user = SessionModel.fromJson(
  //       jsonDecode(preferences.getString('saved_data')!));
  //   sessionId.value = user.sessionId.toString();
  //   print("GET SESSION ID: $sessionId");
  // }

  Future<void> getAccessToken() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    LoginTokenModel? user = LoginTokenModel.fromJson(
        jsonDecode(pref.getString('auth_token')!));
    log("USER INFOOO ${pref.getString('auth_token')!}");
    sessionId.value = user.authToken.toString();
    userId.value = user.id.toString();
    emailController.text = user.email.toString();
    nameController.text = user.firstName.toString();
    lastController.text = user.lastName.toString();
    print("GET SESSION ID: $sessionId");
    print("GET USER ID: $userId");
    print("GET USER ID: ${emailController.text}");
    print("GET USER ID: ${nameController.text}");
    print("GET USER ID: ${lastController.text}");
  }


  // Future<void> getUserSession() async {
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   String randomToken = preferences.getString('saved_data') != null ? sessionId
  //       .value : randomAlphaNumeric(10);
  //   log(randomToken);
  //   var data = {'sessionId': randomToken};
  //   preferences.setString('saved_data', jsonEncode(data));
  //   log("SAVED SESSION ID: ${preferences.getString('saved_data')}");
  // }
@override
  void onInit() {
    super.onInit();
    // getUserSession();
    getAccessToken();
    // getSessionId();
  }
}


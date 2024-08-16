import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/helper/common_button.dart';
import 'package:shop_app/helper/heigh_width.dart';

import '../../controllers/session_controller.dart';
import '../../helper/apptheme_color.dart';
import '../../helper/common_textfiled.dart';
import 'components/profile_pic.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final userDataController = Get.put(SessionController());
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: (){
        FocusManager.instance.primaryFocus!.unfocus();
      },
      child: SafeArea(
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  addHeight(height*.04),
                  ProfilePic(),
                  addHeight(50),
                  Form(
                    key: formKey,
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "User Profile",
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                            color: AppThemeColor.buttonColor),
                      ),
                      addHeight(20),
                      const Text(
                        "First Name",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 13,
                            color: Colors.grey),
                      ),
                      addHeight(3),
                      CommonTextFieldWidget1(
                        controller: userDataController.nameController,
                        keyboardType: TextInputType.emailAddress,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        hint: "First Name",
                        validator: MultiValidator([
                          RequiredValidator(errorText: 'Enter Your First Name'),
                        ]),
                      ),
                      addHeight(6),
                      const Text(
                        "Last Name",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 13,
                            color: Colors.grey),
                      ),
                      addHeight(3),
                      CommonTextFieldWidget1(
                        controller: userDataController.lastController,
                        keyboardType: TextInputType.emailAddress,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        hint: "Last Name",
                        validator: MultiValidator([
                          RequiredValidator(errorText: 'Enter Your last Name'),
                        ]),
                      ),
                      addHeight(6),
                      const Text(
                        "Email ",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 13,
                            color: Colors.grey),
                      ),
                      addHeight(3),
                      CommonTextFieldWidget1(
                        controller: userDataController.emailController,
                        keyboardType: TextInputType.emailAddress,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        hint: "Email",
                        validator: MultiValidator([
                          RequiredValidator(errorText: 'Enter Your Email'),
                        ]),
                      ),
                      addHeight(30),
                      CommonButtonGreen(
                        title: "UPDATE",
                        onPressed: () {
                          userDetailsUpdateMutation(
                              id: userDataController.userId.value,
                              firstName: userDataController.nameController.text,
                              lastName: userDataController.lastController.text,
                              email: userDataController.emailController.text);
                        },
                      )
                    ],
                  ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  userDetailsUpdateMutation(
      {
        required String id,
        required String firstName,
        required String lastName,
        required String email,}) async {


    final MutationOptions options = MutationOptions(
      document: gql('''
      mutation UpdateUser(\$input: UpdateUserInput!) {
        updateUser(
       input:\$input
       ) {
          user {
            databaseId
            id
            name
            username
            firstName
            lastName
            email
            jwtAuthToken
            jwtUserSecret
            wooSessionToken
        }
        }
      }
    '''),
      variables: {
        'input':{
          'id': id,
          'firstName': firstName,
          'lastName': lastName,
          'email': email,

        }
      },
    );

    final GraphQLClient client = GraphQLProvider.of(context).value;

    final QueryResult result = await client.mutate(options);

    if (result.hasException) {
      String error = 'An unknown error occurred';
      if (result.exception!.graphqlErrors.isNotEmpty) {
        error = result.exception!.graphqlErrors.first.message;
      }
      print("UPDATE PROFILE ERROR::::: $error");
    } else {
      final Map<String, dynamic>? updateUserInfo = result.data?['updateUser'];
      if (updateUserInfo != null) {
        showAddToCartPopup(context,"Updated Successfully");
        SharedPreferences pref = await SharedPreferences.getInstance();
        var map = {
          "authToken": updateUserInfo['user']['authToken'].toString(),
          "id": updateUserInfo['user']['id'].toString(),
          "username": updateUserInfo['user']['username'].toString(),
          "email": updateUserInfo['user']['email'].toString(),
          "firstName": updateUserInfo['user']['firstName'].toString(),
          "lastName": updateUserInfo['user']['lastName'].toString(),
        };
        pref.setString("auth_token", jsonEncode(map));
        log("SAVED USER INFORMATION ${pref.getString("auth_token").toString()}");
        // final snackBar = CustomSnackbar.build(
        //   message: "Login successfully!",
        //   backgroundColor: AppThemeColor.buttonColor,
        //   onPressed: () {
        //   },
        // );
        // ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        print('UPDATE PROFILE ERROR: Invalid response data');
      }
    }
  }

}

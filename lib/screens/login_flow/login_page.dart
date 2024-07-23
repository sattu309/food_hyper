import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/helper/apptheme_color.dart';
import '../../helper/common_button.dart';
import '../../helper/common_textfiled.dart';
import '../../helper/custom_snackbar.dart';
import '../../helper/heigh_width.dart';
import '../custom_bottombar.dart';
import '../init_screen.dart';
import '../new_common_tab.dart';
import 'forgot_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passWordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool obscureText = true;
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus!.unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.grey.shade50,
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  addHeight(60),
                  // GestureDetector(
                  //     onTap: (){
                  //       Get.back();
                  //     },
                  //     child: Row(
                  //       mainAxisAlignment: MainAxisAlignment.start,
                  //       children: [
                  //         Icon(Icons.arrow_back_ios,color: Colors.black,size: 20,),
                  //       ],
                  //     )),
                  // addHeight(20),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset("assets/images/food_logo.png",width: width*.5,),
                  ),

                  const Text(
                    "Login",
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 25,
                        color: Color(0xff222222)),
                  ),
                  addHeight(40),
                  CommonTextFieldWidget(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    hint: "Email",
                    validator: MultiValidator([
                      RequiredValidator(errorText: 'Please enter your email '),
                      // EmailValidator(errorText: "please enter valid mail")
                    ]),
                  ),
                  addHeight(10),
                  CommonTextFieldWidget(
                    obscureText: obscureText,
                    controller: passWordController,
                    hint: "Password",
                    suffix: GestureDetector(
                        onTap: () {
                          setState(() {
                            obscureText = !obscureText;
                          });
                        },
                        child: obscureText
                            ? const Icon(
                                Icons.visibility_off,
                                color: Color(0xFF6A5454),
                              )
                            : const Icon(Icons.visibility,
                                color: Color(0xFF6A5454))),
                    validator: MultiValidator([
                      RequiredValidator(
                          errorText: 'Please Enter Your Password'),
                    ]),
                  ),
                  addHeight(20),
                  GestureDetector(
                    onTap: () {
                      Get.to(() => const Forgotpage());
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Text(
                          "Forgot your password?",
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 15,
                              color: Color(0xff222222)),
                        ),
                        Image.asset(
                          "assets/images/red_arrow.png",
                        ),
                      ],
                    ),
                  ),
                  addHeight(50),
                  CommonButtonGreen(
                    title: 'LOGIN',
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        login(context);
                      }
                    },
                  ),
                  addHeight(70),
                  const Center(
                    child: Text(
                      "Or sign up with social account",
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          color: Color(0xff222222)),
                    ),
                  ),
                  addHeight(20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 25, vertical: 7),
                        decoration: BoxDecoration(
                          color: Color(0xffFFFFFF),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset(
                            "assets/images/google.png",
                            height: 40,
                            width: 40,
                          ),
                        ),
                      ),
                      addWidth(40),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 25, vertical: 7),
                        decoration: BoxDecoration(
                          color: const Color(0xffFFFFFF),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset(
                            "assets/images/fb.jpeg",
                            height: 40,
                            width: 40,
                          ),
                        ),
                      ),
                    ],
                  ),
                  addHeight(10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  login(BuildContext context) async {
    final String email = emailController.text;
    final String password = passWordController.text;
    final String sessionId = "";

    final MutationOptions options = MutationOptions(
      document: gql('''
        mutation Login(\$email: String!, \$password: String!) {
          login(email: \$email, password: \$password, sessionid: "") {
             id
            remember_token
            name
            email
          }
        }
      '''),
      variables: {'email': email, 'password': password, "sessionid": sessionId},
    );

    final GraphQLClient client = GraphQLProvider.of(context).value;

    final QueryResult result = await client.mutate(options);

    if (result.hasException) {
      List<String> errorMessages = [];

      if (result.exception!.graphqlErrors.isNotEmpty) {
        errorMessages = result.exception!.graphqlErrors.map((e) => e.message).toList();
      }

      if (result.exception!.linkException != null) {
        errorMessages.add(result.exception!.linkException.toString());
      }
      log("LOGIN ERROR::::: $errorMessages");
      final snackBar = CustomSnackbar.build(
        message: errorMessages.toString(),
        backgroundColor: AppThemeColor.buttonColor,
        // iconData: Icons.info_outline,
        onPressed: () {
          // Perform action on button press
        },
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      final Map<String, dynamic>? loginData = result.data?['login'];
      log("Login data: $loginData");
      if (loginData != null) {
        SharedPreferences pref = await SharedPreferences.getInstance();
        var map = {
          "id": loginData['id'],
          "remember_token": loginData['remember_token'],
          "name": loginData['name'],
          "email": loginData['email'],
        };
        pref.setString("auth_token", jsonEncode(map));
        log("SAVED USER INFORMATION ${pref.getString("auth_token").toString()}");
        final String token = loginData['remember_token'];
        print('Login successful! Token: $token');
        print('Map: $map');
        Get.offAll(()=>const MinimalExample());
        // Get.offAll(() => const CustomNavigationBar());
      } else {
        print('Login error: Invalid response data');
      }
    }
  }
}

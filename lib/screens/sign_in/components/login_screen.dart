import 'package:flutter/material.dart';
import 'package:shop_app/screens/sign_in/components/logo_page.dart';

import '../../../components/app_colors.dart';
import '../../../components/app_mian_button.dart';
import '../../../components/app_textstyle.dart';
import '../../../components/customer_textfiled.dart';


class LoginScreen extends StatefulWidget {
  // static const id = "/signIn";

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 30,),
            const Logo(),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 30),
                    child: Text(
                      "Hello",
                      style: AppTextStyles.merriWeatherRegular30.copyWith(
                        color: AppColors.c909090,
                      ),
                    ),
                  ),
                ),

                /// Text: Welcome Back
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(top:10, left: 30),
                    child: Text(
                      "welcomeBack",
                      style: AppTextStyles.merriWeatherBold24.copyWith(
                        color: AppColors.c303030,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 25),

                Container(
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    color: AppColors.cFFFFFF,
                    boxShadow: [
                      BoxShadow(
                        offset: const Offset(0, 0),
                        blurRadius: 10,
                        color: Colors.grey.shade300,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Column(
                      children: [
                        /// Input: Email
                        const SizedBox(height: 35),
                        const Padding(
                          padding: EdgeInsets.only(left: 30),
                          child: CustomTextField(
                            // controller: controller.emailController,
                            labelText: "email",
                            isObscure: false,
                          ),
                        ),

                        /// Input: Email
                        const SizedBox(height: 35),
                        const Padding(
                          padding: EdgeInsets.only(left: 30),
                          child: CustomTextField(
                            // controller: controller.passwordController,
                            labelText: "password",
                            isObscure: true,
                          ),
                        ),

                        /// Text: Forgot Password
                        const SizedBox(height: 35),
                        const Text(
                          "forgotPassword",
                          style: AppTextStyles.nunitoSansSemiBold18,
                        ),

                        /// Button: Sign in
                        const SizedBox(height: 40),
                        Builder(
                            builder: (context) {
                              return AppMainButton(
                                title: 'SignIn',
                                onPressed: (){
                                  // Get.to(()=>const InitScreen());
                                },

                              );
                            }
                        ),

                        /// Text: Sign up
                        const SizedBox(height: 30),
                        // GestureDetector(
                        //   onTap: () => AppRoutes.pushReplaceSignUp(context),
                        //   child: Text(
                        //     l10n.signUp,
                        //     style: AppTextStyles.nunitoSansSemiBold18,
                        //   ),
                        // ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),

        ],
      ),
    );
  }
}







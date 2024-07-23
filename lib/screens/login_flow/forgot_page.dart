
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../helper/common_button.dart';
import '../../helper/common_textfiled.dart';
import '../../helper/heigh_width.dart';

class Forgotpage extends StatefulWidget {
  const Forgotpage({Key? key}) : super(key: key);

  @override
  State<Forgotpage> createState() => _ForgotpageState();
}

class _ForgotpageState extends State<Forgotpage> {
  final formKey= GlobalKey();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passWordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body:  SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              addHeight(50),
              GestureDetector(
                  onTap: (){
                    Get.back();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.arrow_back_ios,color: Colors.black,size: 20,),
                    ],
                  )),
              addHeight(20),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset("assets/images/food_logo.png"),
              ),

              addHeight(25),
              Text("Forgot Password",
                style: TextStyle(fontWeight: FontWeight.bold,fontSize: 23,color: Color(0xff222222)),),
              addHeight(65),
              Text("Please, enter your email address you will recive a link to create new password",
                style: TextStyle(fontWeight: FontWeight.w500,fontSize: 17,color: Color(0xff222222)),),
              addHeight(10),
              CommonTextFieldWidget(
                controller: emailController,
                hint: "Email",
                validator: MultiValidator([
                  RequiredValidator(
                      errorText:
                      'Please enter your email '),
                  EmailValidator(errorText: "please enter valid mail")

                ]),
              ),
              addHeight(40),

              CommonButtonGreen(
                title: 'SEND',
                onPressed: (){

                },
              ),

            ],
          ),
        ),
      ),
    );
  }
}
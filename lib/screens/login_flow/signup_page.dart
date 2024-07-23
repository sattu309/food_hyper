import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../helper/common_button.dart';
import '../../helper/common_textfiled.dart';
import '../../helper/heigh_width.dart';
import 'login_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
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
          padding: EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              addHeight(30),
              addHeight(25),
              Text("Sign Up",
                style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Color(0xff222222),),),
              addHeight(65),
              CommonTextFieldWidget(
                controller: nameController,
                hint: "Name",
              ),
              addHeight(10),
              CommonTextFieldWidget(
                controller: emailController,
                hint: "Email",
              ),
              addHeight(10),
              CommonTextFieldWidget(
                controller: passWordController,
                hint: "Password",
              ),
              addHeight(20),
              GestureDetector(
                onTap: (){
                 Get.to(()=>const LoginPage());
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Text("Already have an account?",
                      style: TextStyle(fontWeight: FontWeight.w400,fontSize: 15,color: Color(0xff222222)),),
                    Image.asset("assets/images/red_arrow.png",),
                  ],
                ),
              ),
              addHeight(50),
              CommonButtonGreen(
                title: 'SIGN UP',
                onPressed: (){

                },
              ),
              addHeight(70),
              const Center(
                child: Text("Or sign up with social account",
                  style: TextStyle(fontWeight: FontWeight.w600,fontSize: 15,color: Color(0xff222222)),),
              ),
              addHeight(20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 25,vertical: 7),
                    decoration: BoxDecoration(
                      color: Color(0xffFFFFFF),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset("assets/images/google.png",height: 40,width: 40,),
                    ),
                  ),
                  addWidth(40),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 25,vertical: 7),
                    decoration: BoxDecoration(
                      color: Color(0xffFFFFFF),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset("assets/images/fb.jpeg",height: 40,width: 40,),
                    ),
                  ),
                ],
              ),
              addHeight(10),
            ],
          ),
        ),
      ),
    );
  }
}
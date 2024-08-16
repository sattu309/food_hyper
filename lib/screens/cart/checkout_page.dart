import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/helper/common_button.dart';
import 'package:shop_app/screens/cart/thankyou_page.dart';
import 'package:shop_app/screens/login_flow/login_page.dart';

import '../../controllers/cart_controller.dart';
import '../../controllers/order_controller.dart';
import '../../controllers/session_controller.dart';
import '../../helper/apptheme_color.dart';
import '../../helper/common_textfiled.dart';
import '../../helper/dimentions.dart';
import '../../helper/heigh_width.dart';
import '../address/all_address.dart';
import '../home/components/search_field.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final cartController = Get.put(CartController());
  final orderController = Get.put(OrderController());
  final sessionIdController = Get.put(SessionController());
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
  late GraphQLClient client;
  final formKey = GlobalKey<FormState>();
  final formKey1 = GlobalKey<FormState>();
  String? selectedType;
  bool selectedAddress = false;
  List method = ["FS", "SD"];
  Row addRadioButton(String btnValue) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Radio<dynamic>(
          hoverColor: const Color(0xFF0074D9),
          activeColor: const Color(0xFF0074D9),
          value: btnValue,
          groupValue: selectedType,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          onChanged: (value) {
            setState(() {
              selectedType = value;
              log(selectedType!);
            });
          },
        ),
      ],
    );
  }
  Row addRadioButton1(int btnValue) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Radio<dynamic>(
          hoverColor: const Color(0xFF0074D9),
          activeColor: const Color(0xFF0074D9),
          value: method[btnValue],
          groupValue: selectedType,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          onChanged: (value) {
            setState(() {
              selectedType = value;
              log(selectedType!);
            });
          },
        ),
      ],
    );
  }
  final getPaymentList = """
  query PaymentGateways {
    paymentGateways {
        edges {
            node {
                description
                icon
                id
                title
            }
        }
    }
}
""";
  String? selectedCountry;
  var items = [
    'BEL',
    'BRA',
    'SA',
    'IND',
    'AUS',
  ];
  @override
  void initState() {
    super.initState();
    orderController.getCheckoutData();
    initializeClient();
  }
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: (){
        FocusManager.instance.primaryFocus!.unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.grey.shade50,
        appBar: AppBar(
          title: const
          Text("Checkout",
            style:
            TextStyle(fontSize: 15,fontWeight: FontWeight.w600,
                color: Color(0xff222222)),),
        ),
        body: Query(
            options: QueryOptions(document: gql(getPaymentList)),
            builder: (QueryResult result,
                {Refetch? refetch, FetchMore? fetchMore}) {
              if (result.hasException) {
                return Text(result.exception.toString());
              }
              if (result.isLoading) {
                return Center(
                    child: CircularProgressIndicator(
                      color: AppThemeColor.buttonColor,
                    ));
              }
              final payMentLIst = result.data?['paymentGateways']['edges'];
              log("PAYMENT GATEWAYS $payMentLIst");
              return
                SingleChildScrollView(
                  child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child:
                      Obx(() {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Text("Shipping Address", style: Theme
                                .of(context)
                                .textTheme
                                .titleSmall,),

                            Form(
                              key: formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  addHeight(6),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: CommonTextFieldWidget1(
                                          controller: orderController
                                              .fNameController,
                                          keyboardType: TextInputType
                                              .emailAddress,
                                          autovalidateMode: AutovalidateMode
                                              .onUserInteraction,
                                          hint: "First Name",
                                          validator: MultiValidator([
                                            RequiredValidator(
                                                errorText: 'Enter Your FirstName'),
                                          ]),
                                        ),
                                      ),
                                      addWidth(5),
                                      Expanded(
                                        child: CommonTextFieldWidget1(
                                          controller: orderController
                                              .lNameController,
                                          keyboardType: TextInputType
                                              .emailAddress,
                                          autovalidateMode: AutovalidateMode
                                              .onUserInteraction,
                                          hint: "Last Name",
                                          validator: MultiValidator([
                                            RequiredValidator(
                                                errorText: 'Enter Your LstName'),
                                          ]),
                                        ),
                                      ),
                                    ],
                                  ),
                                  addHeight(5),
                                  CommonTextFieldWidget1(
                                    controller: orderController
                                        .address1Controller,
                                    keyboardType: TextInputType
                                        .emailAddress,
                                    autovalidateMode: AutovalidateMode
                                        .onUserInteraction,
                                    hint: "Address1",
                                    validator: MultiValidator([
                                      RequiredValidator(
                                          errorText: 'Enter Your Address 1'),
                                    ]),
                                  ),
                                  addHeight(5),
                                  CommonTextFieldWidget1(
                                    controller: orderController
                                        .address2Controller,
                                    keyboardType: TextInputType
                                        .emailAddress,
                                    autovalidateMode: AutovalidateMode
                                        .onUserInteraction,
                                    hint: "Address2",
                                    validator: MultiValidator([
                                      RequiredValidator(
                                          errorText: 'Enter Your Address 2'),
                                    ]),
                                  ),
                                  addHeight(5),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: CommonTextFieldWidget1(
                                          controller: orderController
                                              .stateController,
                                          keyboardType: TextInputType
                                              .emailAddress,
                                          autovalidateMode: AutovalidateMode
                                              .onUserInteraction,
                                          hint: "State",
                                          validator: MultiValidator([
                                            RequiredValidator(
                                                errorText: 'Please Enter Your Address 1'),
                                          ]),
                                        ),
                                      ),
                                      addWidth(5),
                                      Expanded(
                                        child: CommonTextFieldWidget1(
                                          controller: orderController
                                              .cityController,
                                          keyboardType: TextInputType
                                              .emailAddress,
                                          autovalidateMode: AutovalidateMode
                                              .onUserInteraction,
                                          hint: "City",
                                          validator: MultiValidator([
                                            RequiredValidator(
                                                errorText: 'Please Enter Your City'),
                                          ]),
                                        ),
                                      ),
                                      addWidth(5),
                                      Expanded(
                                        child: CommonTextFieldWidget1(
                                          controller: orderController
                                              .zipCodeController,
                                          keyboardType: TextInputType.number,
                                          autovalidateMode: AutovalidateMode
                                              .onUserInteraction,
                                          hint: "ZipCode",
                                          validator: MultiValidator([
                                            RequiredValidator(
                                                errorText: 'Please Enter Your ZipCode'),
                                          ]),
                                        ),
                                      ),
                                    ],
                                  ),
                                  addHeight(5),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10.0),
                                            color: Colors.white,
                                          ),
                                          child:
                                          Row(
                                            //mainAxisSize: MainAxisSize.min,
                                            children: [

                                              Expanded(
                                                child: DropdownButtonFormField<dynamic>(
                                                    icon: const Icon(Icons.keyboard_arrow_down_rounded),
                                                    focusColor: Colors.grey.shade50,
                                                    isExpanded: true,
                                                    // iconEnabledColor: Colors.green,
                                                    hint: const Text(
                                                      'Country',
                                                      style: TextStyle(
                                                        color: const Color(0xff4F5D62),
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w300,
                                                      ),
                                                    ),
                                                    decoration: InputDecoration(
                                                      fillColor: Colors.white,
                                                      contentPadding: const EdgeInsets.symmetric(
                                                          horizontal: 20, vertical: 10),
                                                      // .copyWith(top: maxLines! > 4 ? AddSize.size18 : 0),
                                                      focusedBorder: OutlineInputBorder(
                                                        borderSide:  BorderSide(color: Colors.grey.shade100),
                                                        borderRadius: BorderRadius.circular(5.0),
                                                      ),
                                                      enabledBorder: OutlineInputBorder(
                                                          borderSide:  BorderSide(color: Colors.grey.shade100),
                                                          borderRadius: BorderRadius.circular(5.0),
                                                      ),
                                                      border: OutlineInputBorder(
                                                          borderSide: BorderSide(
                                                              color: Colors.grey.shade300,
                                                              width: 3.0),
                                                          borderRadius: BorderRadius.circular(15.0)
                                                      ),
                                                    ),
                                                    value: selectedCountry,
                                                    items: items.map((value) {
                                                      return DropdownMenuItem(
                                                        value: value.toString(),
                                                        child: Row(
                                                          //mainAxisAlignment: MainAxisAlignment.end,
                                                          children: [
                                                            Text(
                                                              value.toString(),
                                                              style: TextStyle(
                                                                  color: Colors.black45,
                                                                  fontSize: AddSize.font14),
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    }).toList(),
                                                    onChanged: (newValue) {
                                                      selectedCountry = newValue.toString();
                                                      print(selectedCountry);
                                                      setState(() {});
                                                    },
                                                    validator: (valid) {
                                                      if (selectedCountry == null) {
                                                        return "Country is required";
                                                      } else {
                                                        return null;
                                                      }
                                                    }),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  // CommonTextFieldWidget1(
                                  //   controller: orderController
                                  //       .countryController,
                                  //   keyboardType: TextInputType
                                  //       .emailAddress,
                                  //   autovalidateMode: AutovalidateMode
                                  //       .onUserInteraction,
                                  //   hint: "Country",
                                  //   validator: MultiValidator([
                                  //     RequiredValidator(
                                  //         errorText: 'Enter Your Address 1'),
                                  //   ]),
                                  // ),
                                  addHeight(5),


                                  addHeight(10),

                                ],
                              ),
                            ),
                            addHeight(5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Checkbox(
                                  activeColor: AppThemeColor.buttonColor,
                                  value: selectedAddress,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      selectedAddress = value ?? false;
                                      log(selectedAddress.toString());
                                    });
                                  },
                                ),
                                Text(
                                  "Ship To Different Address",
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                            selectedAddress == true ?
                            Form(
                              key: formKey1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  addHeight(6),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: CommonTextFieldWidget1(
                                          controller: fNameController,
                                          keyboardType: TextInputType
                                              .emailAddress,
                                          autovalidateMode: AutovalidateMode
                                              .onUserInteraction,
                                          hint: "First Name",
                                          validator: MultiValidator([
                                            RequiredValidator(
                                                errorText: 'Enter Your FirstName'),
                                          ]),
                                        ),
                                      ),
                                      addWidth(5),
                                      Expanded(
                                        child: CommonTextFieldWidget1(
                                          controller:lNameController,
                                          keyboardType: TextInputType
                                              .emailAddress,
                                          autovalidateMode: AutovalidateMode
                                              .onUserInteraction,
                                          hint: "Last Name",
                                          validator: MultiValidator([
                                            RequiredValidator(
                                                errorText: 'Enter Your LstName'),
                                          ]),
                                        ),
                                      ),
                                    ],
                                  ),
                                  addHeight(5),
                                  CommonTextFieldWidget1(
                                    controller:address1Controller,
                                    keyboardType: TextInputType
                                        .emailAddress,
                                    autovalidateMode: AutovalidateMode
                                        .onUserInteraction,
                                    hint: "Address1",
                                    validator: MultiValidator([
                                      RequiredValidator(
                                          errorText: 'Enter Your Address 1'),
                                    ]),
                                  ),
                                  addHeight(5),
                                  CommonTextFieldWidget1(
                                    controller: address2Controller,
                                    keyboardType: TextInputType
                                        .emailAddress,
                                    autovalidateMode: AutovalidateMode
                                        .onUserInteraction,
                                    hint: "Address2",
                                    validator: MultiValidator([
                                      RequiredValidator(
                                          errorText: 'Enter Your Address 2'),
                                    ]),
                                  ),
                                  addHeight(5),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: CommonTextFieldWidget1(
                                          controller: stateController,
                                          keyboardType: TextInputType
                                              .emailAddress,
                                          autovalidateMode: AutovalidateMode
                                              .onUserInteraction,
                                          hint: "State",
                                          validator: MultiValidator([
                                            RequiredValidator(
                                                errorText: 'Please Enter Your Address 1'),
                                          ]),
                                        ),
                                      ),
                                      addWidth(5),
                                      Expanded(
                                        child: CommonTextFieldWidget1(
                                          controller: cityController,
                                          keyboardType: TextInputType
                                              .emailAddress,
                                          autovalidateMode: AutovalidateMode
                                              .onUserInteraction,
                                          hint: "City",
                                          validator: MultiValidator([
                                            RequiredValidator(
                                                errorText: 'Please Enter Your City'),
                                          ]),
                                        ),
                                      ),
                                      addWidth(5),
                                      Expanded(
                                        child: CommonTextFieldWidget1(
                                          controller: zipCodeController,
                                          keyboardType: TextInputType.number,
                                          autovalidateMode: AutovalidateMode
                                              .onUserInteraction,
                                          hint: "ZipCode",
                                          validator: MultiValidator([
                                            RequiredValidator(
                                                errorText: 'Please Enter Your ZipCode'),
                                          ]),
                                        ),
                                      ),
                                    ],
                                  ),
                                  addHeight(5),
                                  CommonTextFieldWidget1(
                                    controller: countryController,
                                    keyboardType: TextInputType
                                        .emailAddress,
                                    autovalidateMode: AutovalidateMode
                                        .onUserInteraction,
                                    hint: "Country",
                                    validator: MultiValidator([
                                      RequiredValidator(
                                          errorText: 'Enter Your Address 1'),
                                    ]),
                                  ),
                                  addHeight(5),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: CommonTextFieldWidget1(
                                          length: 10,
                                          controller: phoneController,
                                          keyboardType: TextInputType.number,
                                          autovalidateMode: AutovalidateMode
                                              .onUserInteraction,
                                          hint: "Phone",
                                          validator: MultiValidator([
                                            RequiredValidator(
                                                errorText: 'Enter phone'),
                                          ]),
                                        ),
                                      ),
                                      addWidth(5),
                                      Expanded(
                                        child: CommonTextFieldWidget1(
                                          controller: emailController,
                                          keyboardType: TextInputType
                                              .emailAddress,
                                          autovalidateMode: AutovalidateMode
                                              .onUserInteraction,
                                          hint: "Email",
                                          validator: MultiValidator([
                                            RequiredValidator(
                                                errorText: 'Enter Your Email'),
                                          ]),
                                        ),
                                      ),

                                    ],
                                  ),
                                  addHeight(5),


                                  addHeight(10),

                                ],
                              ),
                            ):SizedBox(),

                            addHeight(5),
                            Container(
                                decoration: BoxDecoration(
                                    color: Color(0xffFFFFFF),
                                    borderRadius: BorderRadius.circular(5)
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: width * .035,
                                    vertical: height * .022,
                                  ),
                                  child: Column(
                                    children: [
                                      InkWell(
                                          onTap: () {
                                            // Get.toNamed(
                                            // CouponsScreen.couponsScreen);
                                          },
                                          child: Row(children: [
                                            Expanded(
                                              child: Row(children: [
                                                Image.asset(
                                                  "assets/images/coupons.png",
                                                  height: 20, width: 20,),
                                                const SizedBox(
                                                  width: 17,
                                                ),
                                                Text("Use Coupons",
                                                    style: TextStyle(
                                                        color: Color(0xff293044),
                                                        fontSize: 16,
                                                        fontWeight:
                                                        FontWeight.w600)),
                                              ]),
                                            ),
                                          ])),
                                      addHeight(12),
                                      Row(
                                        children: [
                                          const SearchField1(),
                                          addWidth(10),
                                          Expanded(
                                            child: SizedBox(
                                              height: 35,
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor: AppThemeColor
                                                        .buttonColor,
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius
                                                            .circular(5))),
                                                onPressed: () async {},
                                                child: const Text("APPLY",style: TextStyle(fontSize: 12),),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                )),
                            addHeight(5),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 15),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("CART TOTALS", style: Theme
                                      .of(context)
                                      .textTheme
                                      .titleSmall,),
                                  Divider(),
                                  addHeight(5),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment
                                        .spaceBetween,
                                    children: [
                                      Text("Subtotal", style: Theme
                                          .of(context)
                                          .textTheme
                                          .titleSmall,),
                                      Text("R56.00", style: Theme
                                          .of(context)
                                          .textTheme
                                          .titleSmall,)
                                    ],
                                  ),
                                  Divider(),
                                  addHeight(3),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text("Free Shipping", style: Theme
                                          .of(context)
                                          .textTheme
                                          .titleSmall,),
                                      addRadioButton1(0)
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text("Same day delivery R50", style: Theme
                                          .of(context)
                                          .textTheme
                                          .titleSmall,),
                                      addRadioButton1(1)
                                    ],
                                  ),
                                  Divider(),
                                  addHeight(7),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text('Total:',
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700,
                                            color: AppThemeColor.buttonColor
                                        ),),
                                      Spacer(),

                                      Text(
                                        cartController.totalAmt.value,
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: AppThemeColor.buttonColor
                                        ),),
                                    ],
                                  ),

                                ],
                              ),
                            ),

                            addHeight(10),
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "Payment Method",
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                    color: Color(0xff222222)),
                              ),
                            ),

                            SizedBox(
                              height: 140,
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                padding: EdgeInsets.only(bottom: 10),
                                  itemCount: payMentLIst.length,
                                  itemBuilder: (BuildContext, index){
                                    final paymentType = payMentLIst[index]['node'];
                                    return Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white
                                  ),
                                  child:
                                  Row(
                                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      addRadioButton(paymentType['id']),
                                      Text(
                                        paymentType['title'],
                                        style: Theme
                                            .of(context)
                                            .textTheme
                                            .titleSmall,
                                      ),
                                    ],
                                  ),
                                );
                              }),
                            ),

                          ],
                        );
                      })

                  ),
                );
            }
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              addHeight(30),
              CommonButtonGreen(title: "Placed Order",onPressed: () async {
                if(selectedAddress == false){
                  if(formKey.currentState!.validate()){
                    checkOutMutation(
                      selectedType!,
                      selectedAddress,
                     selectedAddress == false ? orderController.address1Controller.text : "",
                      selectedAddress == false ?  orderController.address2Controller.text: "",
                      selectedAddress == false ?  orderController.cityController.text:"",
                      selectedAddress == false ?  orderController.emailController.text:"",
                      selectedAddress == false ?  orderController.fNameController.text:"",
                      selectedAddress == false ?  orderController.lNameController.text:"",
                      selectedAddress == false ? orderController.phoneController.text:"",
                      selectedAddress == false ? orderController.zipCodeController.text:"",
                      selectedAddress == false ? orderController.stateController.text:"",
                    );
                  }
                }else{
                  if(formKey1.currentState!.validate()){
                    checkOutMutation(
                      selectedType!,
                      selectedAddress,
                      address1Controller.text,
                      address2Controller.text,
                      cityController.text,
                      emailController.text,
                      fNameController.text,
                      lNameController.text,
                      phoneController.text,
                      zipCodeController.text,
                      stateController.text,
                    );
                  }
                }

              },)
            ],
          ),
        ),
      ),
    );
  }
  void initializeClient() {
    log("JWT TOKEN...${sessionIdController.sessionId.value}");
    final HttpLink httpLink = HttpLink(
      'https://wpdemo.bitlogiq.co.za/graphql',
      defaultHeaders: {
        'Authorization': 'Bearer ${sessionIdController.sessionId.value}',
      },
    );

    client = GraphQLClient(
      cache: GraphQLCache(store: InMemoryStore()),
      link: httpLink,
    );
  }
  checkOutMutation(
      String paymentType,
      bool shipValue,
      String address1,
      String address2,
      String city,
      String email,
      String firstName,
      String lastName,
      String phone,
      String postcode,
      String state,

      ) async {
    initializeClient();
    final MutationOptions options = MutationOptions(
      document: gql('''
      mutation Checkout(\$input: CheckoutInput!) {
        checkout(
        input:\$input ) {
            customer {
            databaseId
            date
            firstName
            id
            jwtAuthToken
            lastName
            role
            sessionToken
            username
            email
        }
        order {
            shipping {
                firstName
                lastName
                address1
                address2
                email
                phone
                state
                city
                postcode
                country
            }
              billing{
                firstName
                lastName
                address1
                address2
                email
                phone
                state
                city
                postcode
                country
            }
            databaseId
            date
            id
            orderNumber
            paymentMethod
            status
            subtotal
            total
            lineItems {
                edges {
                    node {
                        databaseId
                        id
                        orderId
                        productId
                        quantity
                        subtotal
                        total
                        product {
                            node {
                                id
                                databaseId
                                name
                                slug
                                sku
                                featuredImage {
                                    node {
                                        sourceUrl
                                    }
                                }
                            }
                        }
                        variation {
                            node {
                                id
                                databaseId
                                name
                                slug
                                sku
                                price
                                salePrice
                                regularPrice
                                featuredImage {
                                    node {
                                        sourceUrl
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        }
    }

    '''),
      variables: {
        'input': {
          'paymentMethod': paymentType,
          "shipToDifferentAddress": shipValue,
          'shipping':
            {
              "address1":address1,
              "address2":address2,
              "city":city,
              "email":email,
              "firstName":firstName,
              "lastName":lastName,
              "phone":phone,
              "postcode":postcode,
              "state": state,
            },
          'billing':
          {
            "address1":address1,
            "address2":address2,
            "city":city,
            "email":email,
            "firstName":firstName,
            "lastName":lastName,
            "phone":phone,
            "postcode":postcode,
            "state": state,
          }
        },
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
      print("Checkout ERROR::::: $errorMessages");
    } else {
      final Map<String, dynamic>? orderPlaced = result.data?['checkout'];
      log("Order placed data ${result}");
      if (orderPlaced != null) {
        SharedPreferences checkoutData =
        await SharedPreferences.getInstance();
        checkoutData.setString('checkOutData', jsonEncode(orderPlaced['order']));
        checkoutData.remove("cart_data");
        cartController.getCartDataLocally();
        String formattedDate =
        DateFormat('MM/dd/yy').format(
            DateTime.parse(orderPlaced['order']['date'],));

        Get.to(()=> ThankYouScreen(
          orderId: orderPlaced['order']['orderNumber'],
          orderDate: formattedDate,
          orderSubtotal: orderPlaced['order']['subtotal'],
          orderTotal:orderPlaced['order']['total'],
          orderType:orderPlaced['order']['paymentMethod'],
        ));

        log("Order Placed successfully");
        // }
      } else {
        print('Add to cart error: Invalid response data');
      }
    }
  }
}

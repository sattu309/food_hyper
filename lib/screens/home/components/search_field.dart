import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:shop_app/helper/apptheme_color.dart';
import 'package:shop_app/screens/search/search_screen.dart';

import '../../../constants.dart';
import '../../../controllers/search_controller.dart';

class SearchField extends StatefulWidget {
  const SearchField({
    Key? key,
  }) : super(key: key);

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  @override
  Widget build(BuildContext context) {
    final searchController = Get.put(ProductSearchController());

    var width = MediaQuery.of(context).size.width;
    return
      Form(
      child: Container(
        height: 40,
        width: width*.72,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade100),
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          // boxShadow: [
          //   BoxShadow(
          //       offset: const Offset(4, 4),
          //       spreadRadius: 2,
          //       blurRadius: 10,
          //       color: Colors.black.withOpacity(0.10)
          //   )
          // ],

        ),
        child:
        TextFormField(
          onFieldSubmitted: (value) => {
           if(searchController.keyWordText.text.isNotEmpty){
             searchController.onSearchChanged(value,context),
             searchController.searchMutation(searchController.keyWordText.text.toString(),context),
             Get.to(()=>SearchPage())
           }
        },
          controller: searchController.keyWordText,
          onChanged: (value) {
            searchController.searchMutation(searchController.keyWordText.text.toString(),context);

            },
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey.shade50,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            border: searchOutlineInputBorder,
            focusedBorder: searchOutlineInputBorder,
            enabledBorder: searchOutlineInputBorder,
            hintText: "Search by products, brand & more...",
            hintStyle: TextStyle(fontSize: 12),

            prefixIcon: IconButton(
                onPressed: (){
                  FocusManager.instance.primaryFocus!
                      .unfocus();
                  print(searchController.keyWordText);
    if(searchController.keyWordText.text.isNotEmpty){
      pushScreen(context, screen: SearchPage(),withNavBar: true);
      // Get.to(()=>SearchPage());
      searchController.searchMutation(searchController.keyWordText.text.toString(),context);
    }


                },
                icon:  Icon(Icons.search,color: AppThemeColor.buttonColor,),),

          ),
        ),
      ),
    );
  }
}
class SearchField1 extends StatelessWidget {
  const SearchField1({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return
      Form(
      child: Container(
        height: 40,
        width: width*.60,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade100),
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
          // boxShadow: [
          //   BoxShadow(
          //       offset: const Offset(4, 4),
          //       spreadRadius: 2,
          //       blurRadius: 10,
          //       color: Colors.black.withOpacity(0.10)
          //   )
          // ],

        ),
        child:
        TextFormField(
          onChanged: (value) {},
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            border: searchOutlineInputBorder,
            focusedBorder: searchOutlineInputBorder,
            enabledBorder: searchOutlineInputBorder,
            hintText: "Coupon code",
          ),
        ),
      ),
    );
  }
}

 OutlineInputBorder searchOutlineInputBorder = OutlineInputBorder(
  borderRadius: const BorderRadius.all(Radius.circular(8)),
  borderSide: BorderSide(color:Colors.transparent,)
);

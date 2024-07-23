import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:shop_app/helper/apptheme_color.dart';
import 'package:shop_app/helper/heigh_width.dart';
import 'package:shop_app/screens/products/category_products_screen.dart';

class CategoryList extends StatefulWidget {
  const CategoryList({super.key});

  @override
  State<CategoryList> createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  final String fetchCategories = """
    query Categories {
    categories {
        id
        category
        slug
    }
}
  """;


  final List<String> choosedOption =
  ["1","2", "3", "4","6","12"];
  String? chooseUnit;


  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: AppThemeColor.buttonColor,
        centerTitle: false,
         leadingWidth: 60,
        leading: GestureDetector(
            onTap: (){
              Get.back();
            },
            child: Icon(Icons.arrow_back_outlined,color: Colors.white,)),
        title: Text(
          "All Categories",
          style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500,color: Colors.white),
        ),
      ),
      body:
      Query(
        options: QueryOptions(document: gql(fetchCategories)),
        builder:  (QueryResult result, {Refetch? refetch, FetchMore? fetchMore}) {
          if (result.hasException) {
            return Text(result.exception.toString());
          }

          if (result.isLoading) {
            return Center(child:  CircularProgressIndicator(color: AppThemeColor.buttonColor,));
          }

          final allCategories = result.data!['categories'];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                  // Expanded(
                  //   child: ListView.builder(
                  //     scrollDirection: Axis.vertical,
                  //       shrinkWrap: true,
                  //       itemCount: allCategories.length,
                  //       itemBuilder:(BuildContext, index){
                  //         final data = allCategories[index];
                  //     return GestureDetector(
                  //       onTap: (){
                  //         log("CATEGORY ID $data['id']");
                  //         Get.to(()=> CategoryProductsScreen(
                  //           categoryId: data['id'], categoryName: data['category'],));
                  //                   },
                  //       child: Container(
                  //         height: height*.12,
                  //         // padding: const EdgeInsets.symmetric(
                  //         //     horizontal: 10, vertical: 10),
                  //         margin: const EdgeInsets.symmetric(
                  //           vertical: 3,
                  //         ),
                  //         decoration: BoxDecoration(
                  //           borderRadius: BorderRadius.circular(10),
                  //           color: Colors.white,
                  //           boxShadow: [
                  //             BoxShadow(
                  //               offset: const Offset(0, -15),
                  //               blurRadius: 20,
                  //               color: const Color(0xFFDADADA).withOpacity(0.15),
                  //             )
                  //           ],
                  //           image:  const DecorationImage(
                  //             image: NetworkImage("https://static.vecteezy.com/system/resources/thumbnails/027/828/752/small_2x/minimal-pastel-product-podium-background-for-cosmetic-presentation-created-with-generative-ai-technology-free-photo.jpg"),
                  //             fit: BoxFit.fitWidth,
                  //             // colorFilter: ColorFilter.mode(
                  //             //     Colors.black.withOpacity(0.10),
                  //             //     BlendMode.darken
                  //             // ),
                  //             )
                  //         ),
                  //         child: Padding(
                  //           padding: const EdgeInsets.only(right: 50),
                  //           child: Column(
                  //             crossAxisAlignment: CrossAxisAlignment.end,
                  //             children: [
                  //               addHeight(20),
                  //               // SizedBox(
                  //               //   width: 88,
                  //               //   child: AspectRatio(
                  //               //     aspectRatio: 0.80,
                  //               //     child: Container(
                  //               //       padding: const EdgeInsets.all(8),
                  //               //       decoration: BoxDecoration(
                  //               //         borderRadius:
                  //               //         BorderRadius.circular(15),
                  //               //       ),
                  //               //       child: CachedNetworkImage(
                  //               //         imageUrl: "https://images.rawpixel.com/image_800/cHJpdmF0ZS9sci9pbWFnZXMvd2Vic2l0ZS8yMDIyLTExL3BmLXMxMDgtcG0tNDExMy1tb2NrdXAuanBn.jpg",
                  //               //         width: 60,
                  //               //         fit: BoxFit.fitHeight,
                  //               //         errorWidget: (_, __, ___) =>
                  //               //             Image.asset(
                  //               //               "assets/images/Image Banner 3.png",
                  //               //             ),
                  //               //       ),
                  //               //     ),
                  //               //   ),
                  //               // ),
                  //
                  //               Text(
                  //               data['category'], maxLines: 2,
                  //               style: const TextStyle(fontSize: 17,color: Colors.black),),
                  //               addHeight(10),
                  //               Container(
                  //                 padding: const EdgeInsets.symmetric(horizontal: 5),
                  //                 decoration: BoxDecoration(
                  //                     color: const Color(0xff953fa7).withOpacity(.50),
                  //                     borderRadius: BorderRadius.circular(3)
                  //                 ),
                  //                 child: const Padding(
                  //                   padding: EdgeInsets.all(5.0),
                  //                   child: Text(
                  //                     "SHOP NOW",
                  //                     textAlign: TextAlign.center,
                  //                     style: TextStyle(
                  //                       color: Colors.white,
                  //                       fontWeight: FontWeight.w500,
                  //                       fontSize: 10,
                  //                     ),
                  //                   ),
                  //                 ),
                  //               ),
                  //
                  //             ],
                  //           ),
                  //         ),
                  //       ),
                  //     );
                  //   }),
                  // )
                Expanded(
                  child: GridView.builder(
                    itemCount: allCategories.length,
                    gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 100,
                      childAspectRatio: 0.9,
                      crossAxisSpacing: 16,
                    ),

                    itemBuilder: (context, index){
                      final data = allCategories[index];
                      return  GestureDetector(
                        onTap: (){
                          log("CATEGORY ID $data['id']");
                          // Get.to(()=> CategoryProductsScreen(
                          //   categoryId: data['id'], categoryName: data['category'],));
                          pushScreen(context, screen: CategoryProductsScreen(
                                categoryId: data['id'], categoryName: data['category'],),withNavBar: true);
                        },
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(15),
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(
                                color: AppThemeColor.buttonColor.withOpacity(.90),
                                // color: const Color(0xFFFFECDF),
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: SvgPicture.asset("assets/icons/Flash Icon.svg",color: Colors.white,),
                            ),
                            const SizedBox(height: 4),
                            Expanded(child:
                            Text(
                                data['category'], textAlign: TextAlign.center, maxLines: 2, style: const TextStyle(fontSize: 13),))
                          ],
                        ),
                      );
                    }
                  ),
                ),
                // old category ui above
                // Container(
                //   decoration: BoxDecoration(
                //       color: const Color(0xFFF2F2F2),
                //       borderRadius: BorderRadius.circular(10)
                //   ),
                //   child: DropdownButtonFormField<dynamic>(
                //     focusColor: Colors.grey.shade50,
                //     menuMaxHeight: 210,
                //     isExpanded: true,
                //     isDense: true,
                //     iconEnabledColor: const Color(0xff97949A),
                //     icon: const Icon(Icons.keyboard_arrow_down),
                //     hint:  Text(
                //       "choose option",
                //       style:  TextStyle(
                //           color: AppThemeColor.userText,
                //           fontSize: AddSize.font14),
                //       textAlign: TextAlign.justify,
                //     ),
                //     decoration: InputDecoration(
                //         fillColor: const Color(0xFFF2F2F2),
                //         contentPadding:
                //         const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                //         focusedBorder: OutlineInputBorder(
                //           borderSide: BorderSide(color: Colors.grey.shade300),
                //           borderRadius: BorderRadius.circular(10.0),
                //         ),
                //         enabledBorder: const OutlineInputBorder(
                //             borderSide: BorderSide(color: Color(0xffE3E3E3)),
                //             borderRadius:
                //             BorderRadius.all(Radius.circular(10.0)))),
                //     validator: (value) {
                //       if (value!.isEmpty) {
                //         return 'Please select units';
                //       }
                //       return null;
                //     },
                //     value: chooseUnit,
                //     items: choosedOption.map((value) {
                //       return DropdownMenuItem(
                //         value: value.toString(),
                //         child: Text(
                //           value.toString(),
                //           style: TextStyle(
                //               color: AppThemeColor.userText,
                //               fontSize: AddSize.font14),
                //         ),
                //       );
                //     }).toList(),
                //     onChanged: (newValue) {
                //       setState(() {
                //         chooseUnit = newValue!;
                //         print(chooseUnit);
                //       });
                //     },
                //   ),
                // ),
              ],
            ),
          );
        },

      ),
    );
  }

      // : Query(
//         options: QueryOptions(document: gql(fetchBrands)),
//         builder: (QueryResult result, {Refetch? refetch, FetchMore? fetchMore}) {
//           if (result.hasException) {
//             return Text(result.exception.toString());
//           }
//
//           if (result.isLoading) {
//             return CircularProgressIndicator();
//           }
//
//           final brands = result.data!['brands'];
}

// import 'dart:developer';
//
// import 'package:flutter/material.dart';
// import 'package:graphql_flutter/graphql_flutter.dart';
//
// class NestedDropdownExample extends StatefulWidget {
//   @override
//   _NestedDropdownExampleState createState() => _NestedDropdownExampleState();
// }
//
// class _NestedDropdownExampleState extends State<NestedDropdownExample> {
//   String? selectedCategory;
//   String? selectedSubCategory;
//
//   final String fetchBrands = """
//     query {
//       brands {
//         id
//         brand
//         brandlogo
//       }
//     }
//   """;
//
//   Map<String, List<String>> categories = {
//     'Category 1': ['Subcategory 1A', 'Subcategory 1B', 'Subcategory 1C'],
//     'Category 2': ['Subcategory 2A', 'Subcategory 2B', 'Subcategory 2C'],
//     'Category 3': ['Subcategory 3A', 'Subcategory 3B', 'Subcategory 3C'],
//   };
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Nested Dropdown Example'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             DropdownButtonFormField<String>(
//               value: selectedCategory,
//               hint: Text('Select Category'),
//               onChanged: (String? newValue) {
//                 setState(() {
//                   selectedCategory = newValue;
//                   selectedSubCategory = null;
//                 });
//               },
//               items: categories.keys.map((String category) {
//                 return DropdownMenuItem<String>(
//                   value: category,
//                   child: Text(category),
//                 );
//               }).toList(),
//             ),
//             SizedBox(height: 20),
//             if (selectedCategory != null)
//               DropdownButtonFormField<String>(
//                 value: selectedSubCategory,
//                 hint: Text('Select Subcategory'),
//                 onChanged: (String? newValue) {
//                   log(categories.keys.toString());
//                   setState(() {
//                     selectedSubCategory = newValue;
//                   });
//                 },
//                 items: categories[selectedCategory!]!.map((String subCategory){
//                   return DropdownMenuItem<String>(
//                     value: subCategory,
//                     child: Text(subCategory),
//                   );
//                 }).toList(),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//

// class MyHomePage extends StatelessWidget {
//   final String fetchBrands = """
//     query {
//    brands {
//         id
//         brand
//
//     }
//     }
//   """;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('GraphQL Example'),
//       ),
//       body: Query(
//         options: QueryOptions(document: gql(fetchBrands)),
//         builder: (QueryResult result, {Refetch? refetch, FetchMore? fetchMore}) {
//           if (result.hasException) {
//             return Text(result.exception.toString());
//           }
//
//           if (result.isLoading) {
//             return CircularProgressIndicator();
//           }
//
//           final brands = result.data!['brands'];
//
//           return ListView.builder(
//             itemCount: brands.length,
//             itemBuilder: (context, index) {
//               final brand = brands[index];
//               return ListTile(
//                 title: Text(brand['id']),
//                 subtitle: Text(brand['brand']),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }

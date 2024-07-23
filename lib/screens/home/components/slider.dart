import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../helper/apptheme_color.dart';

class SliderPage extends StatefulWidget {
  const SliderPage({super.key});

  @override
  State<SliderPage> createState() => _SliderPageState();
}

class _SliderPageState extends State<SliderPage> {
  RxDouble sliderIndex = (0.0).obs;
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return
      CarouselSlider(
      options: CarouselOptions(
          viewportFraction: 1,
          autoPlay: true,
          onPageChanged: (value, _) {
            sliderIndex.value = value.toDouble();
          },
          autoPlayCurve: Curves.ease,
          height: height * .20),
      items: List.generate( 3,
              (index) => Container(
            width: width,
            margin: EdgeInsets.symmetric(horizontal: width * .01),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15), color: AppThemeColor.backgroundcolor),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child:
              Image.asset("assets/images/Image Banner 3.png",fit: BoxFit.cover,),
              // CachedNetworkImage(
              //   imageUrl: homepageControllerMart
              //       .homePageMartModel.value.data!.sliderData![index].image
              //       .toString(),
              //   fit: BoxFit.cover,
              //   errorWidget: (_, __, ___) => Image.asset(
              //     'assets/images/Ellipse 67.png',
              //   ),
              //   placeholder: (_, __) => const Center(child: CircularProgressIndicator()),
              // ),
            ),
          )),
    );
  }
}

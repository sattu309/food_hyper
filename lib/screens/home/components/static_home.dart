import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/helper/heigh_width.dart';
import 'package:shop_app/screens/home/components/popular_product.dart';
import 'package:shop_app/screens/home/components/special_offers.dart';

import 'categories.dart';
import 'discount_banner.dart';
import 'home_header.dart';

class DemoPage extends StatefulWidget {
  const DemoPage({super.key});

  @override
  State<DemoPage> createState() => _DemoPageState();
}

class _DemoPageState extends State<DemoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              addHeight(20),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: HomeHeader(),
              ),
              DiscountBanner(),
              Categories(),
              SpecialOffers(),
              PopularProducts(),
              addHeight(20),
            ],
          ),
        ),
      ),
    );
  }
}

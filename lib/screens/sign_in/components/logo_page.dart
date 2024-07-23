import 'package:flutter/material.dart';
import '../../../components/app_colors.dart';

class Logo extends StatelessWidget {
  const Logo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding:
      EdgeInsets.only(top: 60, bottom: 30, left: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          LogoLine(),
          // Icon(Icons.)
          // SvgIcon.logo,
          LogoLine(),
        ],
      ),
    );
  }
}

class LogoLine extends StatelessWidget {
  const LogoLine({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      height: 1,
      width: width / 3.5,
      color: AppColors.cBDBDBD,
    );
  }
}
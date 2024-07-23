import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_textstyle.dart';

class AppMainButton extends StatelessWidget {
  final String title;
  final VoidCallback? onPressed;

  const AppMainButton({Key? key, required this.title, this.onPressed})
      : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: MaterialButton(
        onPressed: onPressed,
        elevation: 10,
         color: const Color(0xFF4A3298),
        height: 55,
        minWidth: MediaQuery.of(context).size.width,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8)),
        child: Text(
          title,
          textScaleFactor: 1.075,
          style: AppTextStyles.nunitoSansSemiBold18.copyWith(
            color: AppColors.cFFFFFF,
          ),
        ),
      ),
    );
  }
}



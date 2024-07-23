import 'package:flutter/material.dart';
import 'apptheme_color.dart';
import 'dimentions.dart';

class CommonButtonGreen extends StatelessWidget {
  final String title;
  final VoidCallback? onPressed;

  const CommonButtonGreen({Key? key, required this.title, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50), color: AppThemeColor.buttonColor),
      child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            minimumSize: Size(AddSize.screenWidth, AddSize.size50 * 1.2),
            backgroundColor: AppThemeColor.buttonColor,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6), // <-- Radius
            ),
            // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: Text(title,
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                 // letterSpacing: .5,
                  fontSize: 18))),
    );
  }
}
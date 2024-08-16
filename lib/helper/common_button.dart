import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vibration/vibration.dart';
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

showToast(String message) {
  Fluttertoast.cancel();
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.TOP,
    timeInSecForIosWeb: 1,
    backgroundColor: AppThemeColor.buttonColor,
    textColor: Colors.white,
    fontSize: 15.0, // Increase the font size
  );
}
void showAddToCartPopup(BuildContext context, String message) {
  Vibration.vibrate();
  showDialog(
    context: context,
    builder: (BuildContext context) {
      Future.delayed(Duration(seconds: 2), () {
        Navigator.of(context).pop(true);
      });

      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        backgroundColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle, color: AppThemeColor.buttonColor, size: 30.0),
            SizedBox(height: 16.0),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppThemeColor.buttonColor,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    },
  );
}




import 'package:flutter/material.dart';

SizedBox addHeight(double size) => SizedBox(height: size);
SizedBox addWidth(double size) => SizedBox(width: size);

String? validateMobile(String? value) {
  if (value!.length != 10) {
    return 'Enter Mobile Number & must be of 10 digit';
  } else {
    return null;
  }
}

String? validateName(String? name) {
  if (name!.isEmpty) {
    return 'Please Enter Name';
  } else {
    return null;
  }
}

String? validateAdhar(String? name) {
  if (name!.isEmpty) {
    return 'Please Enter Adhar Number';
  } else {
    return null;
  }
}

String? validatePan(String? name) {
  if (name!.isEmpty) {
    return 'Please Enter Pan Number';
  } else {
    return null;
  }
}

String? validateMoney(String? money) {
  if (money!.isEmpty) {
    return 'Please add money';
  } else {
    return null;
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'apptheme_color.dart';
import 'dimentions.dart';

class CommonTextFieldWidget extends StatelessWidget {
  final IconData? suffixIcon;
  final IconData? prefixIcon;
  final Widget? suffix;
  final Widget? prefix;
  final Color? bgColor;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final AutovalidateMode? autovalidateMode;
  final TextInputAction? textInputAction;
  final String? hint;
  final Iterable<String>? autofillHints;
  final TextEditingController? controller;
  final bool? readOnly;
  final int? value = 0;
  final int? minLines;
  final int? maxLines;
  final bool? obscureText;
  final VoidCallback? onTap;
  final length;

  const CommonTextFieldWidget({
    Key? key,
    this.suffixIcon,
    this.autovalidateMode,
    this.prefixIcon,
    this.hint,
    this.keyboardType,
    this.textInputAction,
    this.controller,
    this.bgColor,
    this.validator,
    this.suffix,
    this.autofillHints,
    this.prefix,
    this.minLines = 1,
    this.maxLines = 1,
    this.obscureText = false,
    this.readOnly = false,
    this.onTap,
    this.length,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(

      onTap: onTap,
      readOnly: readOnly!,
      controller: controller,
      obscureText: hint == hint ? obscureText! : false,
      autofillHints: autofillHints,
      validator: validator,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      minLines: minLines,
      maxLines: maxLines,
      autovalidateMode: autovalidateMode,
      inputFormatters: [
        LengthLimitingTextInputFormatter(length),
      ],
      decoration: InputDecoration(
          hintText: hint,
          focusColor: AppThemeColor.primaryColor,
          hintStyle:
          TextStyle(color: AppThemeColor.userText, fontSize: AddSize.font14),
          filled: true,
          fillColor: Colors.white,
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
          // .copyWith(top: maxLines! > 4 ? AddSize.size18 : 0),
          focusedBorder: OutlineInputBorder(
            borderSide:  BorderSide(color: Colors.black38),
            borderRadius: BorderRadius.circular(5.0),
          ),
          enabledBorder:  OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black38),
              borderRadius: BorderRadius.all(Radius.circular(5.0))),
          border: OutlineInputBorder(
              borderSide:
              BorderSide(color: Colors.black38, width: 3.0),
              borderRadius: BorderRadius.circular(5.0)),
          suffixIcon: suffix,
          prefixIcon: prefix),
    );
  }
}

class CommonTextFieldWidget1 extends StatelessWidget {
  final IconData? suffixIcon;
  final IconData? prefixIcon;
  final Widget? suffix;
  final Widget? prefix;
  final Color? bgColor;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final AutovalidateMode? autovalidateMode;
  final String? hint;
  final Iterable<String>? autofillHints;
  final TextEditingController? controller;
  final bool? readOnly;
  final int? value = 0;
  final int? minLines;
  final int? maxLines;
  final bool? obscureText;
  final VoidCallback? onTap;
  final length;

  const CommonTextFieldWidget1({
    Key? key,
    this.suffixIcon,
    this.prefixIcon,
    this.hint,
    this.keyboardType,
    this.textInputAction,
    this.controller,
    this.bgColor,
    this.validator,
    this.suffix,
    this.autofillHints,
    this.prefix,
    this.minLines = 1,
    this.maxLines = 1,
    this.obscureText = false,
    this.readOnly = false,
    this.onTap,
    this.length, this.autovalidateMode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: onTap,
      readOnly: readOnly!,
      controller: controller,
      obscureText: hint == hint ? obscureText! : false,
      autofillHints: autofillHints,
      validator: validator,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      minLines: minLines,
      maxLines: maxLines,
      autovalidateMode: autovalidateMode,
      inputFormatters: [
        LengthLimitingTextInputFormatter(length),
      ],
      decoration: InputDecoration(
          hintText: hint,
          focusColor: AppThemeColor.primaryColor,
          hintStyle:
          TextStyle(color: AppThemeColor.userText, fontSize: AddSize.font14),
          filled: true,
          fillColor: Colors.white,
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          // .copyWith(top: maxLines! > 4 ? AddSize.size18 : 0),
          focusedBorder: OutlineInputBorder(
            borderSide:  BorderSide(color: Colors.grey.shade100),
            borderRadius: BorderRadius.circular(5.0),
          ),
          enabledBorder:  OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade100),
              borderRadius: BorderRadius.all(Radius.circular(5.0))),
          border: OutlineInputBorder(
              borderSide:
               BorderSide(color: Colors.grey.shade100,width: 3.0),
              borderRadius: BorderRadius.circular(5.0)),
          suffixIcon: suffix,
          prefixIcon: prefix),
    );
  }
}
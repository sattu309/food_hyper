
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfileController extends GetxController {
  Rx<File> image = File("").obs;
  final ImagePicker picker = ImagePicker();

}

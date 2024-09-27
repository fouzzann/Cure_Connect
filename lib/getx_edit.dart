
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_5/db_helper.dart';
import 'package:task_5/getx_list.dart';
import 'package:task_5/model.dart';

class StudentEditController extends GetxController {
  final StudentModel student;
  StudentEditController({required this.student});

  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  // Reactive variables for image path and gender
  RxString imagePath = ''.obs;
  RxString groupValue = ''.obs;
  

  ImageSource imageSource = ImageSource.camera;

  @override
  void onInit() {
    super.onInit();
    nameController.text = student.name;
    ageController.text = student.age;
    phoneController.text = student.phone;
    imagePath.value = student.image;
    groupValue.value = student.gender;
  }

  // Function to update student data
  Future<void> updateStudentData(int id) async {
    await SQLHelper.updateData(id, nameController.text, ageController.text, phoneController.text, imagePath.value, groupValue.value);
    Get.find<StudentController>().refreshData();
  }

  // Function to select image
  Future<void> selectImage() async {
    final pickedImage = await ImagePicker().pickImage(source: imageSource);
    if (pickedImage != null) {
      imagePath.value = pickedImage.path;
    }
  }
}

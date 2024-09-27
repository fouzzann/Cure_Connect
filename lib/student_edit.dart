import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_5/getx_edit.dart';
import 'package:task_5/model.dart';
import 'package:task_5/student_add_page.dart';



class StudentEdit extends StatelessWidget {
  final StudentModel student;

  const StudentEdit({required this.student});

  @override
  Widget build(BuildContext context) {
    final StudentEditController studentEditController = Get.put(StudentEditController(student: student));

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back, color: Colors.white),
        ),
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text("Edit Student", style: TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                _showImageSourceDialog(studentEditController);
              },
              child: Obx(() => Center(
                child: Container(
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                  child: studentEditController.imagePath.value.isNotEmpty
                      ? Image.file(File(studentEditController.imagePath.value), fit: BoxFit.cover)
                      : Container(color: Colors.grey),
                ),
              )),
            ),
            SizedBox(height: 15),
            Form(
              key: GlobalKey<FormState>(),
              child: Container(
                width: double.infinity,
                height: 360,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildTextField("Name", studentEditController.nameController, TextInputType.name),
                    _buildTextField("Age", studentEditController.ageController, TextInputType.number),
                    _buildTextField("Phone Number", studentEditController.phoneController, TextInputType.phone),
                    _buildGenderSelection(studentEditController),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange[700]),
              onPressed: () async {
                await studentEditController.updateStudentData(student.id);
                Get.back(); 
              },
              child: Text("EDIT STUDENT", style: TextStyle(color: Colors.black)),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildTextField(String label, TextEditingController controller, TextInputType keyboardType) {
    return TextFormField(
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.orange, width: 2), borderRadius: BorderRadius.circular(50)),
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.orange, width: 1), borderRadius: BorderRadius.all(Radius.circular(50))),
        labelText: label,
        labelStyle: TextStyle(color: Colors.white),
      ),
      keyboardType: keyboardType,
      controller: controller,
      validator: (value) {
        if (value == "") {
          return "please enter your $label";
        }
        return null;
      },
    );
  }


  Row _buildGenderSelection(StudentEditController studentEditController) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text('Select Gender :', style: myStyle(16, FontWeight.bold, Colors.black)),
        Obx(() => Row(
          children: [
            Radio(
              activeColor: Colors.orange[700],
              value: 'Male',
              groupValue: studentEditController.groupValue.value,
              onChanged: (value) {
                studentEditController.groupValue.value = value.toString();
              },
            ),
            Text('Male', style: myStyle(12, FontWeight.bold, Colors.white)),
            Radio(
              activeColor: Colors.orange[700],
              value: 'Female',
              groupValue: studentEditController.groupValue.value,
              onChanged: (value) {
                studentEditController.groupValue.value = value.toString();
              },
            ),
            Text('Female', style: myStyle(12, FontWeight.bold, Colors.white)),
          ],
        )),
      ],
    );
  }

  
  void _showImageSourceDialog(StudentEditController studentEditController) {
    showDialog(
      context: Get.context!,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10), side: BorderSide(width: 5)),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildImageSourceOption('Camera', ImageSource.camera, studentEditController),
            _buildImageSourceOption('Gallery', ImageSource.gallery, studentEditController),
          ],
        ),
      ),
    );
  }

  Column _buildImageSourceOption(String label, ImageSource source, StudentEditController studentEditController) {
    return Column(
      children: [
        Text(label, style: myStyle(18, FontWeight.bold, Colors.black)),
        IconButton(
          onPressed: () {
            studentEditController.imageSource = source;
            studentEditController.selectImage();
            Get.back(); // Close dialog
          },
          icon: Icon(Icons.camera_alt_outlined, size: 35, color: Colors.black),
        ),
      ],
    );
  }
}

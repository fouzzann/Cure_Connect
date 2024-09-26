import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_5/db_helper.dart';
import 'package:task_5/getx_list.dart';

class StudentEdit extends StatefulWidget {
  final int id;
  final String name;
  final String age;
  final String image;
  final String gender;
  final String phone;

  const StudentEdit({
    required this.id,
    required this.name,
    required this.age,
    required this.image,
    required this.gender,
    required this.phone,
  });

  @override
  State<StudentEdit> createState() => _StudentEditState();
}

class _StudentEditState extends State<StudentEdit> {
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  ImageSource _imageSource = ImageSource.camera;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? imagePath;
  String? groupValue;

  // Get the existing StudentController instance
  final StudentController studentController = Get.find<StudentController>();

  @override
  void initState() {
    super.initState();
    nameController.text = widget.name;
    ageController.text = widget.age;
    phoneController.text = widget.phone;
    imagePath = widget.image;
    groupValue = widget.gender;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back(); // Use Get to navigate back
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
            Stack(
              children: [
                GestureDetector(
                  onTap: () {
                    _showImageSourceDialog();
                  },
                  child: Center(
                    child: Container(
                      width: 160,
                      height: 160,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                      child: imagePath != null
                          ? Image.file(File(imagePath!), fit: BoxFit.cover)
                          : Container(color: Colors.grey), 
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 15),
            Form(
              key: _formKey,
              child: Container(
                width: double.infinity,
                height: 360,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildTextField("Name", nameController, TextInputType.name),
                    _buildTextField("Age", ageController, TextInputType.number),
                    _buildTextField("Phone Number", phoneController, TextInputType.phone),
                    _buildGenderSelection(),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange[700]),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  await _updateData(widget.id);
                  Get.back(); // Return to previous screen
                }
              },
              child: Text("EDIT STUDENT", style: TextStyle(color: Colors.black)),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _updateData(int id) async {
    await SQLHelper.updateData(id, nameController.text, ageController.text, phoneController.text, imagePath.toString(), groupValue.toString());
    studentController.refreshData();
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

  Row _buildGenderSelection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text('Select Gender :', style: myStyle(16, FontWeight.bold, Colors.black)),
        Row(
          children: [
            Radio(
              activeColor: Colors.orange[700],
              value: 'Male',
              groupValue: groupValue,
              onChanged: (value) {
                setState(() {
                  groupValue = value.toString();
                });
              },
            ),
            Text('Male', style: myStyle(12, FontWeight.bold, Colors.white)),
            Radio(
              activeColor: Colors.orange[700],
              value: 'Female',
              groupValue: groupValue,
              onChanged: (value) {
                setState(() {
                  groupValue = value.toString();
                });
              },
            ),
            Text('Female', style: myStyle(12, FontWeight.bold, Colors.white)),
          ],
        ),
      ],
    );
  }

  void _showImageSourceDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10), side: BorderSide(width: 5)),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildImageSourceOption('Camera', ImageSource.camera),
            _buildImageSourceOption('Gallery', ImageSource.gallery),
          ],
        ),
      ),
    );
  }

  Column _buildImageSourceOption(String label, ImageSource source) {
    return Column(
      children: [
        Text(label, style: myStyle(18, FontWeight.bold, Colors.black)),
        IconButton(
          onPressed: () {
            _imageSource = source;
            _getImage();
            Navigator.of(context, rootNavigator: true).pop();
          },
          icon: Icon(Icons.camera_alt_outlined, size: 35, color: Colors.black),
        ),
      ],
    );
  }

  void _getImage() async {
    final selectedImage = await ImagePicker().pickImage(source: _imageSource);
    if (selectedImage != null) {
      setState(() {
        imagePath = selectedImage.path;
      });
    }
  }
}

myStyle(double size, FontWeight weight, Color clr) {
  return TextStyle(fontSize: size, fontWeight: weight, color: clr);
}

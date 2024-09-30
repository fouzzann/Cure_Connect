import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_5/getx_list.dart';
import 'student_list.dart';
import 'package:flutter/services.dart';
import 'db_helper.dart';
import 'package:image_picker/image_picker.dart';

class StudentAdd extends StatefulWidget {
  StudentAdd({Key? key}) : super(key: key);

  @override
  State<StudentAdd> createState() => _StudentAddState();
}

class _StudentAddState extends State<StudentAdd> {
  String? groupValue;
  String? imagePath;
  late ImageSource _imageSource;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<Map<String, dynamic>> allData = [];

  void refreshData() async {
    final data = await SQLHelper.getAllData();
    setState(() {
      allData = data;
    });
  }

  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  
  final StudentController studentController = Get.find();

  Future<void> addData() async {
    await SQLHelper.createData(nameController.text, ageController.text,
        phoneController.text, imagePath.toString(), groupValue.toString());
    studentController.refreshData();
  }

  bool _isPhotoSelected = false;
  bool photoerrorVisible = false;
  bool genderErrorVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
        title: Text(
          "Add Student",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Stack(
            children: [
              GestureDetector(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            backgroundColor: Colors.grey[800],
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: BorderSide(
                                  width: 5,
                                )),
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      'Camera',
                                      style: myStyle(
                                          18, FontWeight.bold, Colors.white),
                                    ),
                                    IconButton(
                                        onPressed: () {
                                          _imageSource = ImageSource.camera;
                                          _getImage();
                                          Navigator.of(context,
                                                  rootNavigator: true)
                                              .pop();
                                        },
                                        icon: Icon(
                                          Icons.camera_alt_outlined,
                                          size: 35,
                                          color: Colors.white,
                                        ))
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text(
                                      'Gallery',
                                      style: myStyle(
                                          18, FontWeight.bold, Colors.white),
                                    ),
                                    IconButton(
                                        onPressed: () {
                                          _imageSource = ImageSource.gallery;
                                          _getImage();
                                          Navigator.of(context,
                                                  rootNavigator: true)
                                              .pop();
                                        },
                                        icon: Icon(
                                          Icons.photo_outlined,
                                          size: 35,
                                          color: Colors.white,
                                        ))
                                  ],
                                ),
                              ],
                            ),
                          ));
                },
                child: Center(
                  child: Container(
                    height: 150,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(
                              'assets/addImage-removebg-preview.png')),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          if (photoerrorVisible && imagePath == null)
            Text(
              'Please add a photo',
              style: TextStyle(color: Colors.red),
            ),
          Form(
            key: _formKey,
            child: Container(
              width: double.infinity,
              height: 360,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextFormField(
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.orange, width: 2),
                          borderRadius: BorderRadius.circular(
                            50,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.orange, width: 1),
                            borderRadius:
                                BorderRadius.all(Radius.circular(30))),
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        labelText: "Name",
                        labelStyle: TextStyle(color: Colors.white)),
                    keyboardType: TextInputType.name,
                    controller: nameController,
                    validator: (value) {
                      if (value == "") {
                        return "please enter your name";
                      } else {
                        return null;
                      }
                    },
                  ),
                  TextFormField(
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.orange, width: 2),
                          borderRadius: BorderRadius.circular(
                            50,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.orange, width: 1),
                            borderRadius:
                                BorderRadius.all(Radius.circular(30))),
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                        labelText: "Age",
                        labelStyle: TextStyle(color: Colors.white)),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(2)
                    ],
                    controller: ageController,
                    validator: (value) {
                      if (value == "") {
                        return "please enter your age";
                      } else {
                        return null;
                      }
                    },
                  ),
                  TextFormField(
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.orange, width: 2),
                          borderRadius: BorderRadius.circular(
                            50,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.orange, width: 1),
                            borderRadius:
                                BorderRadius.all(Radius.circular(30))),
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                        labelText: "Phone Number",
                        labelStyle: TextStyle(color: Colors.white)),
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                    ],
                    controller: phoneController,
                    validator: (value) {
                      if (value == "") {
                        return "please enter your phone Number";
                      } else if (value!.length != 10) {
                        return "phone number not valid";
                      } else {
                        return null;
                      }
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        'Select Gender :',
                        style: myStyle(16, FontWeight.bold, Colors.white),
                      ),
                      Row(
                        children: [
                          Radio(
                              activeColor: Colors.orange[600],
                              value: 'Male',
                              groupValue: groupValue,
                              onChanged: (value) {
                                setState(() {
                                  groupValue = value;
                                });
                              }),
                          Text('Male',
                              style:
                                  myStyle(12, FontWeight.bold, Colors.white)),
                          Radio(
                              activeColor: Colors.orange[600],
                              value: 'Female',
                              groupValue: groupValue,
                              onChanged: (value) {
                                setState(() {
                                  groupValue = value;
                                });
                              }),
                          Text('Female',
                              style: myStyle(12, FontWeight.bold, Colors.white))
                        ],
                      ),
                    ],
                  ),
                  if (genderErrorVisible && groupValue == null)
                    Text(
                      'Please select a gender',
                      style: TextStyle(color: Colors.red),
                    ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          ElevatedButton(
              style:
                  ElevatedButton.styleFrom(backgroundColor: Colors.orange[600]),
              onPressed: () async {
                if (!_isPhotoSelected) {
                  setState(() {
                    refreshData();
                    photoerrorVisible = true;
                  });
                }
                if (groupValue == null) {
                  setState(() {
                    genderErrorVisible = true;
                  });
                }
                if (_formKey.currentState!.validate() &&
                    _isPhotoSelected == true &&
                    groupValue != null) {
                  await addData();

                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => StudentList()),
                      (route) => false);
                } else {
                  return;
                }
              },
              child: Text(
                "Add Student",
                style: TextStyle(color: Colors.black),
              ))
        ]),
      ),
    );
  }

  void _getImage() async {
    final selectedImage = await ImagePicker().pickImage(source: _imageSource);
    if (selectedImage != null) {
      setState(() {
        imagePath = selectedImage.path;
        _isPhotoSelected = true;
      });
    }
  }
}

myStyle(double size, FontWeight weight, Color clr) {
  return TextStyle(fontSize: size, fontWeight: weight, color: clr);
}

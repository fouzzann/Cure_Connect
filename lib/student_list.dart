import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_5/db_helper.dart'; 
import 'package:task_5/getx_list.dart';
import 'package:task_5/model.dart';
import 'package:task_5/student_add_page.dart';
import 'package:task_5/student_edit.dart';
import 'package:task_5/student_profile.dart';
import 'dart:io'; 

class StudentList extends StatefulWidget {
 
  @override
  State<StudentList> createState() => _StudentListState();
  
}

class _StudentListState extends State<StudentList> {
  final StudentController studentController = Get.put(StudentController());

  @override
  
  
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          "Students List",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Obx(() => studentController.isLoading.value
          ? Center(
              child: CircularProgressIndicator(color: Colors.orange[700],),
            )
          : Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.symmetric(horizontal: 15),
                  child: TextField(
                    onChanged: (value) => studentController.runfilter(value),
                    decoration: InputDecoration(focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.orange,width: 2),
                    borderRadius: BorderRadius.circular(50)
                    ),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 1),
                            borderRadius: BorderRadius.all(Radius.circular(30))),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(30))),
                        labelText: "search",
                        labelStyle: TextStyle(),
                        suffixIcon: Icon(Icons.search,
                        
                        )),
                  ),
                ),
                Expanded(
                  child: Obx(() => ListView.builder(
                        itemCount: studentController.founders.length,
                        itemBuilder: (context, index) => GestureDetector(
                          onTap: () => Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => StudentProfile(
                                  id: studentController.founders[index]['id'],
                                  name: studentController.founders[index]['name'],
                                  age: studentController.founders[index]['age'],
                                  phone: studentController.founders[index]['phone'],
                                  gender: studentController.founders[index]['gender'],
                                  images: studentController.founders[index]['images']))),
                          child: Card(
                            color: Colors.grey[800],
                            margin: EdgeInsets.all(15),
                            child: ListTile(
                              title: Padding(
                                padding: EdgeInsets.symmetric(vertical: 20),
                                child: Text(
                                  studentController.founders[index]["name"],
                                  style: TextStyle(fontSize: 20, color: Colors.white),
                                ),
                              ),
                              leading: Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(100)),
                                child: ClipOval(
                                  child: Image.file(
                                    File(studentController.founders[index]['images']),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                     Navigator.of(context).push(MaterialPageRoute(
  builder: (context) => StudentEdit(
    student: StudentModel(
      id: studentController.founders[index]['id'],
      name: studentController.founders[index]['name'],
      age: studentController.founders[index]['age'],
      image: studentController.founders[index]['images'],
      gender: studentController.founders[index]['gender'],
      phone: studentController.founders[index]['phone'],
    ),
  ),
));
                                    },
                                    icon: Icon(
                                      Icons.edit,
                                      color: Colors.white,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      _deleteData(
                                          studentController.founders[index]["id"],
                                          studentController
                                              .founders[index]["name"],
                                          context);
                                    },
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )),
                ),
              ],
            )),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange[600],
        onPressed: () {
          Get.to(StudentAdd());
        },
        child: Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),
    );
  }

  // Delete function
  Future<void> _deleteData(int id, String name, context) async {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content:Text("Are you sure you want to Delete $name?",
            style: TextStyle(color: Colors.white,
            fontSize: 17
            ),) ,
            backgroundColor: Colors.grey[900],
            shape: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
            title: Text(
              "Delete Student",
              style: TextStyle(color: Colors.white),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "NO",
                    style: TextStyle(color: Colors.white),
                  )),
              TextButton(
                  onPressed: () async {
                    await SQLHelper.deleteData(id);
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        backgroundColor: Colors.red,
                        content: Text("DATA DELETED"),
                        duration: Duration(milliseconds: 800)));
                    studentController.refreshData(); 
                  },
                  child: Text(
                    "YES",
                    style: TextStyle(color: Colors.orange[600]),
                  ))
            ],
          );
        });
  }
}

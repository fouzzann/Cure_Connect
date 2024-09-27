import 'dart:io';
import 'package:flutter/material.dart';
import 'package:task_5/model.dart';

class StudentProfile extends StatelessWidget {
  
  final StudentModel student;

  const StudentProfile({ required this.student});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
        ),
        title: Text(
          student.name,
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundImage: FileImage(File('${student.image}')),
                  radius: 70,
                ),
                SizedBox(
                  height: 30,
                ),
                Material(
                  elevation: 8,
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                      padding: EdgeInsetsDirectional.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        color: Colors.grey[700],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      height: MediaQuery.of(context).size.height * 0.3,
                      width: MediaQuery.of(context).size.height * 0.3,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "  NAME                      :  ${student.name.toUpperCase()}",
                            style: TextStyle(color: Colors.white),
                          ),
                          Text(
                            "  GENDER                  :  ${student.gender.toUpperCase()}",
                            style: TextStyle(color: Colors.white),
                          ),
                          Text(
                            "  AGE                         :  $student.age",
                            style: TextStyle(color: Colors.white),
                          ),
                          Text(
                            " PHONE NUMBER     :  $student.phone",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

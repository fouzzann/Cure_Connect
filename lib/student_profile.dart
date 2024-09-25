import 'dart:io';
import 'package:flutter/material.dart';

class StudentProfile extends StatelessWidget {
  final int id;
  final String name;
  final String age;
  final String phone;
  final String gender;
  final String images;

  const StudentProfile(
      {super.key,
      required this.id,
      required this.name,
      required this.age,
      required this.phone,
      required this.gender,
      required this.images});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(backgroundColor:  Colors.black,
      leading: IconButton(onPressed: (){Navigator.of(context).pop();},
       icon: Icon(Icons.arrow_back),color: Colors.white,),
        title: Text(name,style: TextStyle(color: Colors.white),),
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
                  backgroundImage: FileImage(File('$images')),
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
                      decoration: BoxDecoration(color: Colors.grey[700],
                        borderRadius: BorderRadius.circular(8),
                      
                      ),
                      height: MediaQuery.of(context).size.height * 0.3,
                      width: MediaQuery.of(context).size.height * 0.3,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "  NAME                      :  ${name.toUpperCase()}",
                            style: TextStyle(color: Colors.white),
                          ),
                          Text(
                            "  GENDER                  :  ${gender.toUpperCase()}",
                            style:  TextStyle(color: Colors.white),
                          ),
                          Text(
                            "  AGE                         :  $age",
                            style:  TextStyle(color: Colors.white),
                          ),
                          Text(
                            " PHONE NUMBER     :  $phone",
                            style:  TextStyle(color: Colors.white),
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

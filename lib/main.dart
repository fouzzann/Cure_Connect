import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_5/pages/home_page.dart';



void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(primarySwatch: Colors.orange),
      debugShowCheckedModeBanner: false,
     home: HomePage(),
    );
  }
}

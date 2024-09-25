import 'package:flutter/material.dart';
import 'package:task_5/student_add_page.dart';
import 'package:task_5/student_edit.dart';
import 'package:task_5/student_profile.dart';
import 'dart:io';
import 'db_helper.dart';

class StudentList extends StatefulWidget {
  const StudentList({super.key});

  @override
  State<StudentList> createState() => _StudentListState();
}

class _StudentListState extends State<StudentList> {
 
  List<Map<String, dynamic>> allData = [];
  List<Map<String, dynamic>> _foundUsers = [];
  
  void refreshData() async {
    final data = await SQLHelper.getAllData();
    setState(() {
      allData = data;
      _foundUsers = data;
    });
  }

  bool _isLoading = true;
  
  void initState() {
    refreshData();
    _isLoading = false;
    super.initState();
  }

  void _runfilter(String enteredKeyword) {
    List<Map<String, dynamic>> results = [];
    if (enteredKeyword.isEmpty) {
      results = allData;
    } else {
      results = allData
          .where((element) => element['name']
              .toLowerCase()
              .contains(enteredKeyword.toLowerCase()))
          .toList();
    }
    setState(() {
      _foundUsers = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(backgroundColor:  Colors.black,
       

        title: Text("Students List",style: TextStyle(
          color: Colors.white
        ),),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding:
                      const EdgeInsetsDirectional.symmetric(horizontal: 15),
                  child: TextField(
                    onChanged: (value) => _runfilter(value),
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide( width: 1),
                            borderRadius:
                                BorderRadius.all(Radius.circular(30))),
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(30))),
                        labelText: "search",
                        suffixIcon: Icon(Icons.search)),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _foundUsers.length,
                    itemBuilder: (context, index) => GestureDetector(
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => StudentProfile(
                              id: allData[index]['id'],
                              name: allData[index]['name'],
                              age: allData[index]['age'],
                              phone: allData[index]['phone'],
                              gender: allData[index]['gender'],
                              images: allData[index]['images']))),
                      child: Card(
                     color: Colors.grey[800],
                        margin: EdgeInsets.all(15),
                        child: ListTile(
                          title: Padding(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: Text(
                              _foundUsers[index]["name"],
                              style: TextStyle(fontSize: 20,color: Colors.white),
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
                                File(_foundUsers[index]['images']),
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
                                          id: allData[index]['id'],
                                          name: allData[index]['name'],
                                          age: allData[index]['age'],
                                          image: allData[index]['images'],
                                          gender: allData[index]
                                              ['gender'],
                                          phone: allData[index]['phone'])));
                                },
                                icon: Icon(Icons.edit,
                                color: Colors.white,),
                              ),
                              IconButton(
                                onPressed: () {
                                  deleteData(_foundUsers[index]["id"],
                                      _foundUsers[index]["name"], context);
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
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(backgroundColor: Colors.orange[600],
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => StudentAdd()));
        },
        child: Icon(Icons.add,color: Colors.black,),
      ),
    );
  }

  //for deleting

   Future<void> deleteData(int id, String name, context) async {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.grey[900],
            shape: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
            title: Text(
              "Are you sure you want to delete $name ?",
              style: TextStyle(color: Colors.white),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("NO",style: TextStyle(color: Colors.white),)),
              TextButton(
                  onPressed: () async {
                    await SQLHelper.deleteData(id);
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        backgroundColor: Colors.red,
                        content: Text("DATA DELTED"),
                        duration: Duration(milliseconds: 800)));
                    refreshData();
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

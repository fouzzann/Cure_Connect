import 'package:get/get.dart';
import 'package:task_5/db_helper.dart';

class StudentController extends GetxController {
  var allData = <Map<String, dynamic>>[].obs;
  var _foundUsers = <Map<String, dynamic>>[].obs;
  var isLoading = true.obs;

 @override

 void onInit() {
    // TODO: implement onInit
    super.onInit();
    refreshData();
  }

 void refreshData() async{
    isLoading.value = true;
    try{
      final data = await SQLHelper.getAllData();
      allData.assignAll(data);
      _foundUsers.assignAll(data);
    }finally{
      isLoading.value = false;
    }
  }

  void runfilter(String enteredKeyword) {
    if (enteredKeyword.isEmpty) {
      _foundUsers.assignAll(allData); 
   
    }else{
         _foundUsers.assignAll(allData
          .where((element) => element['name']
              .toLowerCase()
              .contains(enteredKeyword.toLowerCase()))
          .toList()
          );
    }
  }

  List<Map<String, dynamic>> get founders => _foundUsers;

}

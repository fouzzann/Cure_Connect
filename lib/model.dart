class StudentModel {
  final int id;
  final String name;
  final String age;
  final String image;
  final String gender;
  final String phone;

  StudentModel({
    required this.id,
    required this.name,
    required this.age,
    required this.image,
    required this.gender,
    required this.phone,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'image': image,
      'gender': gender,
      'phone': phone,
    };
  }

  factory StudentModel.fromMap(Map<String, dynamic> map) {
    return StudentModel(
        id: map['id'],
        name: map['name'],
        age: map['age'],
        image: map['map'],
        gender: map['gender'],
        phone: map['phone']);
  }
}

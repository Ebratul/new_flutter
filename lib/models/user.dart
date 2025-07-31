// User Model
class UserModel {
  final String id;
  final String firstName;
  final String lastName;
  final int age;
  final String email;
  final String phone;
  final String bloodGroup;
  final String division;
  final String district;
  final String subDistrict;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.age,
    required this.email,
    required this.phone,
    required this.bloodGroup,
    required this.division,
    required this.district,
    required this.subDistrict,
    this.createdAt,
    this.updatedAt,
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return UserModel(
      id: doc.id,
      firstName: data['firstName'] ?? '',
      lastName: data['lastName'] ?? '',
      age: data['age'] ?? 0,
      email: data['email'] ?? '',
      phone: data['phone'] ?? '',
      bloodGroup: data['bloodGroup'] ?? '',
      division: data['division'] ?? '',
      district: data['district'] ?? '',
      subDistrict: data['subDistrict'] ?? '',
      createdAt: data['createdAt']?.toDate(),
      updatedAt: data['updatedAt']?.toDate(),
    );
  }

  String get fullName => '$firstName $lastName';
}

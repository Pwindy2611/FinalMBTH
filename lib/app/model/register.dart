import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class Signup {
  String? accountID;
  String? numberID;
  String? password;
  String? confirmPassword;
  String? fullName;
  String? phoneNumber;
  String? gender;
  String? birthDay;
  String? schoolYear;
  String? schoolKey;
  String? imageUrl;

  Signup({
    required this.accountID,
    required this.numberID,
    required this.password,
    required this.confirmPassword,
    required this.fullName,
    required this.phoneNumber,
    required this.gender,
    required this.birthDay,
    required this.schoolKey,
    required this.schoolYear,
    required this.imageUrl,
  });

  Map<String, dynamic> toJson() => {
    'accountID': accountID,
    'numberID': numberID,
    'password': password,
    'confirmPassword': confirmPassword,
    'fullName': fullName,
    'phoneNumber': phoneNumber,
    'gender': gender,
    'birthDay': birthDay,
    'schoolYear': schoolYear,
    'schoolKey': schoolKey,
    'imageUrl': imageUrl,
  };

  static Signup fromJson(Map<String, dynamic> json) => Signup(
    accountID: json['accountID'],
    numberID: json['numberID'],
    password: json['password'],
    confirmPassword: json['confirmPassword'],
    fullName: json['fullName'],
    phoneNumber: json['phoneNumber'],
    gender: json['gender'],
    birthDay: json['birthDay'],
    schoolYear: json['schoolYear'],
    schoolKey: json['schoolKey'],
    imageUrl: json['imageUrl'],
  );
}
Future<void> saveSignupInfo(Signup signup) async {
  final prefs = await SharedPreferences.getInstance();
  final jsonString = jsonEncode(signup.toJson());
  await prefs.setString('signup_info', jsonString);
}
Future<Signup?> getSignupInfo() async {
  final prefs = await SharedPreferences.getInstance();
  final jsonString = prefs.getString('signup_info');
  if (jsonString != null) {
    final jsonMap = jsonDecode(jsonString);
    return Signup.fromJson(jsonMap);
  }
  return null;
}
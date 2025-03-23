import 'dart:io';

import 'package:app_json/app/data/api.dart';
import 'package:app_json/app/model/register.dart';
import 'package:app_json/app/page/auth/login.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  int _gender = 0;
  File? _image;
  final TextEditingController _accountController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _numberIDController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _schoolKeyController = TextEditingController();
  final TextEditingController _schoolYearController = TextEditingController();
  final TextEditingController _birthDayController = TextEditingController();

  Future<void> _pickImage() async {
    try {
      var status = await Permission.photos.request();
      if (status.isGranted) {
        final picker = ImagePicker();
        final pickedFile = await picker.pickImage(source: ImageSource.gallery);
        if (pickedFile != null) {
          setState(() {
            _image = File(pickedFile.path);
          });
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Vui lòng cấp quyền truy cập ảnh")),
        );
      }
    } catch (e) {
      print("Lỗi khi chọn ảnh: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Lỗi khi chọn ảnh: $e")),
      );
    }
  }

  Future<String> register() async {
    return await APIRepository().register(Signup(
      accountID: _accountController.text,
      birthDay: _birthDayController.text,
      password: _passwordController.text,
      confirmPassword: _confirmPasswordController.text,
      fullName: _fullNameController.text,
      phoneNumber: _phoneNumberController.text,
      schoolKey: _schoolKeyController.text,
      schoolYear: _schoolYearController.text,
      gender: getGender(),
      imageUrl: _image != null ? _image!.path : '',
      numberID: _numberIDController.text,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Đăng ký")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Text(
                'Thông tin đăng ký',
                style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: _image != null ? FileImage(_image!) : null,
                  child: _image == null
                      ? const Icon(Icons.add_a_photo, size: 50)
                      : null,
                ),
              ),
              const SizedBox(height: 16),
              textField(_accountController, "Tài khoản", Icons.person),
              textField(_passwordController, "Mật khẩu", Icons.password),
              textField(_confirmPasswordController, "Xác nhận mật khẩu",
                  Icons.password),
              textField(
                  _fullNameController, "Họ tên", Icons.text_fields_outlined),
              textField(_numberIDController, "CMND/CCCD", Icons.key),
              textField(_phoneNumberController, "Số điện thoại", Icons.phone),
              textField(_birthDayController, "Ngày sinh", Icons.date_range),
              textField(_schoolYearController, "Năm học", Icons.school),
              textField(_schoolKeyController, "Mã trường", Icons.school),
              const Text("Giới tính của bạn?"),
              Row(
                children: [
                  Expanded(
                    child: ListTile(
                      title: const Text("Nam"),
                      leading: Radio(
                        value: 1,
                        groupValue: _gender,
                        onChanged: (value) {
                          setState(() {
                            _gender = value!;
                          });
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListTile(
                      title: const Text("Nữ"),
                      leading: Radio(
                        value: 2,
                        groupValue: _gender,
                        onChanged: (value) {
                          setState(() {
                            _gender = value!;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  Signup signup = Signup(
                    accountID: _accountController.text,
                    numberID: _numberIDController.text,
                    password: _passwordController.text,
                    confirmPassword: _confirmPasswordController.text,
                    fullName: _fullNameController.text,
                    phoneNumber: _phoneNumberController.text,
                    gender: getGender(),
                    birthDay: _birthDayController.text,
                    schoolYear: _schoolYearController.text,
                    schoolKey: _schoolKeyController.text,
                    imageUrl: _image != null ? _image!.path : '',
                  );
                  await saveSignupInfo(signup);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()));
                },
                child: const Text('Đăng ký'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String getGender() {
    if (_gender == 1) return "Nam";
    return "Nữ";
  }

  Widget textField(
      TextEditingController controller, String label, IconData icon) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: controller,
        obscureText: label.contains('Mật khẩu'),
        decoration: InputDecoration(
          labelText: label,
          icon: Icon(icon),
          border: const OutlineInputBorder(),
          errorText: controller.text.trim().isEmpty ? 'Vui lòng nhập' : null,
        ),
      ),
    );
  }
}

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../model/user.dart';
import '../model/register.dart';

class Detail extends StatefulWidget {
  const Detail({super.key});

  @override
  State<Detail> createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  User user = User.userEmpty();
  File? _image;
  int _gender = 0;
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _birthDayController = TextEditingController();
  final TextEditingController _numberIDController = TextEditingController();
  final TextEditingController _schoolYearController = TextEditingController();
  final TextEditingController _schoolKeyController = TextEditingController();
  final TextEditingController _accountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getDataUser();
  }

  Future<void> getDataUser() async {
    Signup? signup = await getSignupInfo();
    if (signup != null) {
      user = User(
        status: true,
        accountId: signup.accountID,
        idNumber: signup.numberID,
        fullName: signup.fullName,
        phoneNumber: signup.phoneNumber,
        gender: signup.gender,
        birthDay: signup.birthDay,
        schoolYear: signup.schoolYear,
        schoolKey: signup.schoolKey,
        imageURL: signup.imageUrl,
        dateCreated: DateTime.now().toString(),
      );
      _accountController.text = user.accountId ?? '';
      _fullNameController.text = user.fullName ?? '';
      _phoneNumberController.text = user.phoneNumber ?? '';
      _birthDayController.text = user.birthDay ?? '';
      _numberIDController.text = user.idNumber ?? '';
      _schoolYearController.text = user.schoolYear ?? '';
      _schoolKeyController.text = user.schoolKey ?? '';
      _gender = signup.gender == "Nam"
          ? 1
          : signup.gender == "Nữ"
              ? 2
              : 3;
      setState(() {});
    }
  }

  Future<void> _pickImage() async {
    try {
      var status = await Permission.photos.request();
      if (status.isGranted) {
        final picker = ImagePicker();
        final pickedFile = await picker.pickImage(source: ImageSource.gallery);
        if (pickedFile != null) {
          setState(() {
            _image = File(pickedFile.path);
            user.imageURL = _image!.path;
          });
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Vui lòng cấp quyền truy cập ảnh")),
        );
      }
    } catch (e) {
      print("Lỗi khi chọn ảnh: $e");
    }
  }

  Future<void> _updateUser() async {
    Signup updatedSignup = Signup(
      accountID: _accountController.text,
      numberID: _numberIDController.text,
      password: '', // Không thay đổi mật khẩu ở đây
      confirmPassword: '',
      fullName: _fullNameController.text,
      phoneNumber: _phoneNumberController.text,
      gender: getGender(),
      birthDay: _birthDayController.text,
      schoolYear: _schoolYearController.text,
      schoolKey: _schoolKeyController.text,
      imageUrl: _image != null ? _image!.path : user.imageURL,
    );
    await saveSignupInfo(updatedSignup);
    await getDataUser();
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Cập nhật thành công")));
  }

  String getGender() {
    if (_gender == 1) return "Nam";
    if (_gender == 2) return "Nữ";
    return "Khác";
  }

  Widget textField(
      TextEditingController controller, String label, IconData icon) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          icon: Icon(icon),
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 60,
                backgroundImage: user.imageURL!.isEmpty
                    ? null
                    : (user.imageURL!.startsWith('http')
                        ? NetworkImage(user.imageURL!)
                        : FileImage(File(user.imageURL!)) as ImageProvider),
                child: user.imageURL!.isEmpty
                    ? const Icon(Icons.person, size: 60)
                    : null,
              ),
            ),
            const SizedBox(height: 16),
            // textField(_accountController, "Tài khoản", Icons.person),
            textField(
                _fullNameController, "Họ tên", Icons.text_fields_outlined),
            // textField(_numberIDController, "CMND/CCCD", Icons.key),
            textField(_phoneNumberController, "Số điện thoại", Icons.phone),
            textField(_birthDayController, "Ngày sinh", Icons.date_range),
            textField(_schoolYearController, "Năm học", Icons.school),
            textField(_schoolKeyController, "Mã trường", Icons.school),
            const SizedBox(height: 10),
            const Text(
              "Giới tính:",
              style: TextStyle(fontSize: 18),
            ),
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
              onPressed: _updateUser,
              child: const Text("Cập nhật thông tin"),
            ),
          ],
        ),
      ),
    );
  }
}

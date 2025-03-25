import 'package:app_json/app/page/register.dart';
import 'package:flutter/material.dart';
import 'package:app_json/app/model/register.dart';
import 'package:app_json/mainpage.dart';
import 'package:flutter_svg/svg.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController accountController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSignupInfo();
  }

  Future<void> _loadSignupInfo() async {
    Signup? signup = await getSignupInfo();
    if (signup != null) {
      accountController.text = signup.accountID ?? '';
      passwordController.text = signup.password ?? '';
    }
  }

  login() async {
    Signup? signup = await getSignupInfo();
    if (signup != null) {
      if (signup.accountID == accountController.text &&
          signup.password == passwordController.text) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Mainpage()),
        );
      } else {
        // Handle login failure
        print("Login failed");
      }
    } else {
      // Handle no signup info found
      print("No signup info found");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Column(
                children: [
                  // Replace with your actual logo asset
                  SvgPicture.asset(
                      'assets/images/logo.svg',
                      width: 100, // Điều chỉnh kích thước nếu cần
                      height: 100,
                      colorFilter: ColorFilter.mode(Colors.blue, BlendMode.srcIn), // Đổi màu SVG
                      placeholderBuilder: (context) => const Icon(Icons.image, size: 50), // Hiển thị icon nếu lỗi
                    ),
                    SizedBox(height: 10,),
                  const Text(
                    "LOGIN INFORMATION",
                    style: TextStyle(fontSize: 24, color: Colors.blue),
                  ),
                  TextFormField(
                    controller: accountController,
                    decoration: const InputDecoration(
                      labelText: "Account",
                      icon: Icon(Icons.person),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: "Password",
                      icon: Icon(Icons.password),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                          child: ElevatedButton(
                        onPressed: login,
                        child: const Text("Login"),
                      )),
                      const SizedBox(
                        width: 16,
                      ),
                      Expanded(
                          child: OutlinedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Register()));
                        },
                        child: const Text("Register"),
                      ))
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

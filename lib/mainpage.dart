import 'dart:io';

import 'package:app_json/app/data/sharepre.dart';
import 'package:app_json/app/model/register.dart';
import 'package:app_json/app/model/user.dart';
import 'package:app_json/app/page/cart/cart_screen.dart';
import 'package:app_json/app/page/defaultwidget.dart';
import 'package:app_json/app/page/detail.dart';
import 'package:app_json/app/page/history/history.dart';
import 'package:app_json/app/page/home.dart';
import 'package:app_json/app/provider/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Mainpage extends StatefulWidget {
  const Mainpage({super.key});

  @override
  State<Mainpage> createState() => _MainpageState();
}

class _MainpageState extends State<Mainpage> {
  User user = User.userEmpty();
  int _selectedIndex = 0;

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
      setState(() {});
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _loadWidget(int index) {
    switch (index) {
      case 0:
        return const Home();
      case 1:
        return const History();
      case 2:
        return const CartScreen();
      case 3:
        return const Detail();
      default:
        return const DefaultWidget(title: "Không tìm thấy");
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider =
        Provider.of<CartProvider>(context); // Lấy dữ liệu từ CartProvider
    final cartItemCount = cartProvider.cartItems
        .fold(0, (sum, item) => sum + item.quantity); // Tổng số lượng sản phẩm

    return Scaffold(
      appBar: AppBar(
        title: const Text("Cửa hàng Phụ Kiện", style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold)),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.brown,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  user.imageURL!.isEmpty
                      ? const CircleAvatar(
                          radius: 40,
                          child: Icon(Icons.person),
                        )
                      : CircleAvatar(
                          radius: 40,
                          backgroundImage: user.imageURL!.startsWith('http')
                              ? NetworkImage(user.imageURL!)
                              : FileImage(File(user.imageURL!))
                                  as ImageProvider,
                        ),
                  const SizedBox(height: 8),
                  Text(
                    user.fullName ?? "Khách",
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Trang chủ'),
              onTap: () {
                Navigator.pop(context);
                _selectedIndex = 0;
                setState(() {});
              },
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('Lịch sử đặt hàng'),
              onTap: () {
                Navigator.pop(context);
                _selectedIndex = 1;
                setState(() {});
              },
            ),
            ListTile(
              leading: const Icon(Icons.shopping_cart),
              title: const Text('Giỏ hàng'),
              onTap: () {
                Navigator.pop(context);
                _selectedIndex = 2;
                setState(() {});
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Thông tin cá nhân'),
              onTap: () {
                Navigator.pop(context);
                _selectedIndex = 3;
                setState(() {});
              },
            ),
            const Divider(color: Colors.grey),
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text('Đăng xuất'),
              onTap: () {
                logOut(context);
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          const BottomNavigationBarItem(
              icon: Icon(Icons.home), label: 'Trang chủ'),
          const BottomNavigationBarItem(
              icon: Icon(Icons.history), label: 'Lịch sử'),
          BottomNavigationBarItem(
            icon: Stack(
              children: [
                const Icon(Icons.shopping_cart),
                if (cartItemCount > 0)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        '$cartItemCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            label: 'Giỏ hàng',
          ),
          const BottomNavigationBarItem(
              icon: Icon(Icons.person), label: 'Cá nhân'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.brown[800],
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
      body: _loadWidget(_selectedIndex),
    );
  }
}

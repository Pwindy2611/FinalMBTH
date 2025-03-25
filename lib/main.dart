import 'package:app_json/app/model/category.dart';
import 'package:app_json/app/page/auth/login.dart';
import 'package:app_json/app/provider/cart_provider.dart';
import 'package:app_json/app/provider/history_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => HistoryProvider()),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cửa hàng phụ kiện',
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white, // Màu nền cho toàn bộ ứng dụng
        appBarTheme: const AppBarTheme(
          backgroundColor:
              Colors.transparent, // Màu nền AppBar cho toàn bộ ứng dụng
        ),
        inputDecorationTheme: const InputDecorationTheme(
          floatingLabelStyle:
              TextStyle(color: Color(0xFF00A2FF)), // Màu label khi focus
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF00A2FF), width: 2.0),
          ),
        ),
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Color(0xFF00A2FF), // Đặt màu dấu nháy (cursor)
        ),
      ), 
      home: const LoginScreen(),
      onGenerateRoute: AppRoute.onGenerateRoute,
      // initialRoute: "/",
      // onGenerateRoute: AppRoute.onGenerateRoute,  -> su dung auto route (pushName)
    );
  }
}

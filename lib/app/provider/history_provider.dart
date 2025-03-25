import 'package:app_json/app/model/order_model.dart';
import 'package:app_json/app/provider/cart_provider.dart';
import 'package:flutter/material.dart';

class HistoryProvider with ChangeNotifier {
  List<Order> _orders = []; // Danh sách đơn hàng

  List<Order> get orders => _orders;

  void addOrder(List<CartItem> cartItems) {
    _orders.add(
      Order(
        orderDate: DateTime.now(), // Lưu ngày đặt hàng
        items: List.from(cartItems), // Sao chép danh sách sản phẩm
      ),
    );
    notifyListeners();
  }
}

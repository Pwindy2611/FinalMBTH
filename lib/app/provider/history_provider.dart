import 'package:app_json/app/provider/cart_provider.dart';
import 'package:flutter/material.dart';

class HistoryProvider with ChangeNotifier {
  List<List<CartItem>> _orders = [];

  List<List<CartItem>> get orders => _orders;

  void addOrder(List<CartItem> cartItems) {
    _orders.add(List.from(cartItems));
    notifyListeners();
  }
}
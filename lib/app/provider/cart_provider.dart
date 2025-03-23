import 'package:app_json/app/model/product.dart';
import 'package:flutter/material.dart';

class CartItem {
  Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});
}

class CartProvider with ChangeNotifier {
  List<CartItem> _cartItems = [];

  List<CartItem> get cartItems => _cartItems;

  void addProduct(Product product, BuildContext context) {
    final existingItem = _cartItems.firstWhere(
      (item) => item.product.id == product.id,
      orElse: () => CartItem(product: product),
    );
    if (_cartItems.contains(existingItem)) {
      existingItem.quantity++;
    } else {
      _cartItems.add(existingItem);
    }
    notifyListeners();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("${product.name} đã được thêm vào giỏ hàng")),
    );
  }

  void increaseQuantity(int productId) {
    final item = _cartItems.firstWhere((item) => item.product.id == productId);
    item.quantity++;
    notifyListeners();
  }

  void decreaseQuantity(int productId) {
    final item = _cartItems.firstWhere((item) => item.product.id == productId);
    if (item.quantity > 1) {
      item.quantity--;
    } else {
      _cartItems.remove(item);
    }
    notifyListeners();
  }

  void removeItem(int productId) {
    _cartItems.removeWhere((item) => item.product.id == productId);
    notifyListeners();
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }

  int get totalPrice {
    return _cartItems.fold(0, (sum, item) => sum + (item.product.price * item.quantity));
  }
}
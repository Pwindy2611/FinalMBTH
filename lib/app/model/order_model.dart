import 'package:app_json/app/provider/cart_provider.dart';

class Order {
  final DateTime orderDate; // Ngày đặt hàng
  final List<CartItem> items; // Danh sách sản phẩm trong đơn

  Order({required this.orderDate, required this.items});
}
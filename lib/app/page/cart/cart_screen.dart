import 'package:app_json/app/provider/cart_provider.dart';
import 'package:app_json/app/provider/history_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  // Hàm định dạng số tiền
  String formatPrice(int price) {
    final formatter = NumberFormat("#,###", "vi_VN");
    return "${formatter.format(price)} đ";
  }
  
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: cartProvider.cartItems.isEmpty
                ? const Center(child: Text("Giỏ hàng trống"))
                : ListView.builder(
                    itemCount: cartProvider.cartItems.length,
                    itemBuilder: (context, index) {
                      final cartItem = cartProvider.cartItems[index];
                      return ListTile(
                        leading: Image.network(cartItem.product.linkImage,
                            width: 80, height: 80, fit: BoxFit.cover),
                        title: Text(cartItem.product.name),
                        subtitle: Row(
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove),
                                  onPressed: () {
                                    cartProvider.decreaseQuantity(cartItem.product.id);
                                  },
                                ),
                                Text("${cartItem.quantity}"),
                                IconButton(
                                  icon: const Icon(Icons.add),
                                  onPressed: () {
                                    cartProvider.increaseQuantity(cartItem.product.id);
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            cartProvider.removeItem(cartItem.product.id);
                          },
                        ),
                      );
                    },
                  ),
          ),
          if (cartProvider.cartItems.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    "Tổng tiền: ${formatPrice(cartProvider.totalPrice)}",
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          cartProvider.clearCart();
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red),
                        child: const Text("Xóa tất cả"),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Provider.of<HistoryProvider>(context, listen: false)
                              .addOrder(cartProvider.cartItems);
                          cartProvider.clearCart();
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Đặt hàng thành công")));
                        },
                        child: const Text("Đặt hàng"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

import 'package:app_json/app/provider/history_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class History extends StatelessWidget {
  const History({super.key});

  @override
  Widget build(BuildContext context) {
    final historyProvider = Provider.of<HistoryProvider>(context);

    return Scaffold(
      body: historyProvider.orders.isEmpty
          ? const Center(child: Text("Chưa có đơn hàng nào"))
          : ListView.builder(
              itemCount: historyProvider.orders.length,
              itemBuilder: (context, index) {
                final order = historyProvider.orders[index];
                final total = order.fold(0, (sum, item) => sum + (item.product.price * item.quantity));
                return ExpansionTile(
                  title: Text("Đơn hàng #${index + 1} - Tổng: $total VNĐ"),
                  subtitle: Text("Số món: ${order.length}"),
                  children: order.map((item) => ListTile(
                        leading: Image.network(item.product.linkImage, width: 50, height: 50, fit: BoxFit.cover),
                        title: Text(item.product.name),
                        subtitle: Text("Số lượng: ${item.quantity} - ${item.product.price * item.quantity} VNĐ"),
                      )).toList(),
                );
              },
            ),
    );
  }
}
import 'package:app_json/app/provider/history_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  Map<int, bool> isExpanded = {}; // Trạng thái mở rộng của từng đơn hàng

  @override
  Widget build(BuildContext context) {
    final historyProvider = Provider.of<HistoryProvider>(context);

    String formatPrice(int price) {
      final formatter = NumberFormat("#,###", "vi_VN");
      return "${formatter.format(price)} đ";
    }

    return Scaffold(
      body: historyProvider.orders.isEmpty
          ? const Center(child: Text("Chưa có đơn hàng nào"))
          : ListView.builder(
              itemCount: historyProvider.orders.length,
              itemBuilder: (context, index) {
                final order = historyProvider.orders[index];
                final total = order.items.fold(
                    0, (sum, item) => sum + (item.product.price * item.quantity));

                return Card(
                  margin: const EdgeInsets.all(10),
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Thông tin đơn hàng
                        Text(
                          "Đơn hàng #${index + 1}",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),  
                              
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "Ngày đặt hàng: ${DateFormat('dd/MM/yyyy HH:mm').format(order.orderDate)}",
                          style: const TextStyle(color: Colors.black54),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "Tổng cộng: ${formatPrice(total)}",
                          style: const TextStyle(
                              color: Colors.green, fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),

                        // Nút "Chi tiết"
                        TextButton(
                          onPressed: () {
                            setState(() {
                              isExpanded[index] = !(isExpanded[index] ?? false);
                            });
                          },
                          child: Text(
                            isExpanded[index] ?? false ? "Thu gọn" : "Chi tiết",
                            style: const TextStyle(color: Colors.blue),
                          ),
                        ),

                        // Danh sách sản phẩm (chỉ hiển thị khi mở rộng)
                        if (isExpanded[index] ?? false) ...[
                          const Divider(),
                          Column(
                            children: order.items.map((item) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 5),
                                child: Row(
                                  children: [
                                    Image.network(item.product.linkImage,
                                        width: 50, height: 50, fit: BoxFit.cover),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item.product.name,
                                            style: const TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                          Text("Số lượng: ${item.quantity}"),
                                          Text(
                                            "Thành tiền: ${formatPrice(item.product.price * item.quantity)}",
                                            style: const TextStyle(color: Colors.red),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

import 'package:app_json/app/model/product.dart';
import 'package:app_json/app/page/category/categorywidget.dart';
import 'package:app_json/app/provider/cart_provider.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  List<Product> products = [];
  List<Product> filteredProducts = [];
  List<CategoryModel> categories = [];
  Map<int, String> categoryMap = {};
  String allCategory = "Tất cả";
  String? selectedCategory = "Tất cả";
  TextEditingController searchController = TextEditingController();
  late final AnimationController _animationController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 200),
    value: 0.0, // Initialize with starting value
  );
  int? selectedProductIndex;
  IconData getCategoryIcon(int id) {
    switch (id) {
      case 1:
        return Icons.hiking; // or Icons.shoes
      case 2:
        return Icons.watch;
      case 3:
        return Icons.shopping_bag;
      default:
        return Icons.category;
    }
  }

  @override
  void initState() {
    super.initState();
    loadCategories();
    loadProducts();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> loadCategories() async {
    try {
      final String response =
          await rootBundle.loadString('assets/json/coffee_categories.json');
      final List<dynamic> data = jsonDecode(response);
      setState(() {
        categories = data.map((json) => CategoryModel.fromJson(json)).toList();
        categoryMap = {
          for (var category in categories) category.id!: category.name
        };
      });
    } catch (e) {
      debugPrint('Error loading categories: $e');
    }
  }

  Future<void> loadProducts() async {
    final String response =
        await rootBundle.loadString('assets/json/coffee_products.json');
    final List<dynamic> data = jsonDecode(response);
    setState(() {
      products = data.map((json) => Product.fromJson(json)).toList();
      filteredProducts = products;
    });
  }

  void filterProducts(String query) {
    setState(() {
      filteredProducts = products.where((product) {
        final matchesQuery =
            product.name.toLowerCase().contains(query.toLowerCase());
        final matchesCategory = selectedCategory == allCategory ||
            categoryMap[product.idCategory] == selectedCategory;
        return matchesQuery && matchesCategory;
      }).toList();
    });
  }

  void filterProductsByCategory(int? idCategory) {
    setState(() {
      filteredProducts = products.where((product) {
        final matchesQuery = product.name
            .toLowerCase()
            .contains(searchController.text.toLowerCase());
        final matchesCategory =
            idCategory == null || product.idCategory == idCategory;
        return matchesQuery && matchesCategory;
      }).toList();
    });
  }

  // Hàm định dạng số tiền
  String formatPrice(int price) {
    final formatter = NumberFormat("#,###", "vi_VN");
    return "${formatter.format(price)} đ";
  }

  void _showAddToCartDialog(BuildContext context, Product product) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(product.name),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.network(
                product.linkImage,
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              SizedBox(height: 10),
              Text('Giá: ${formatPrice(product.price)}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () {
                Provider.of<CartProvider>(context, listen: false)
                    .addProduct(product, context);
                Navigator.pop(context);
              },
              child: Text('Thêm vào giỏ'),
            ),
          ],
        );
      },
    );
  }

  void _handleLongPressStart(int index) {
    setState(() => selectedProductIndex = index);
    _animationController.forward();
  }

  void _handleLongPressEnd(Product product) {
    _animationController.reverse().then((_) {
      if (mounted) {
        setState(() => selectedProductIndex = null);
      }
    });
    _showAddToCartDialog(context, product);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          body: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    labelText: "Tìm kiếm sản phẩm",
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  onChanged: filterProducts,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.start, // Changed to start
                  children: [
                    Container(
                      height: 80,
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            // Tất cả category
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedCategory = allCategory;
                                  filterProducts(searchController.text);
                                });
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16.0),
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.all_inclusive,
                                      size: 30,
                                      color: selectedCategory == allCategory
                                          ? Colors.blue
                                          : Colors.black87,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      allCategory,
                                      style: TextStyle(
                                        color: selectedCategory == allCategory
                                            ? Colors.blue
                                            : Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            // Other categories
                            ...categories.map((category) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedCategory = category.name;
                                    filterProductsByCategory(category.id);
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0),
                                  child: Column(
                                    children: [
                                      Icon(
                                        getCategoryIcon(category.id!),
                                        size: 30,
                                        color: selectedCategory == category.name
                                            ? Colors.blue
                                            : Colors.black87,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        category.name,
                                        style: TextStyle(
                                          color:
                                              selectedCategory == category.name
                                                  ? Colors.blue
                                                  : Colors.black87,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                            mainAxisExtent: 240),
                    itemCount: filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = filteredProducts[index];
                      return GestureDetector(
                        onLongPressStart: (_) => _handleLongPressStart(index),
                        onLongPressEnd: (_) => _handleLongPressEnd(product),
                        child: AnimatedBuilder(
                          animation: _animationController,
                          builder: (context, child) {
                            final scale = selectedProductIndex == index
                                ? 1.0 - (_animationController.value * 0.1)
                                : 1.0;
                            return Transform.scale(
                              scale: scale,
                              child: Stack(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.2),
                                          blurRadius: 5,
                                          spreadRadius: 2,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Image.network(
                                            product.linkImage,
                                            height: 150,
                                            width: double.infinity,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: Text(
                                            product.name,
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.normal,
                                              color: Color.fromARGB(
                                                  255, 124, 124, 124),
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: Text(
                                            formatPrice(product.price),
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (selectedProductIndex == index)
                                    Positioned.fill(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.3),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: const Center(
                                          child: Icon(
                                            Icons.add_shopping_cart,
                                            color: Colors.white,
                                            size: 40,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
